import uuid

from rest_framework import generics, status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import FoundItem, LostItem
from .serializers import FoundItemSerializer, LostItemListSerializer, LostItemSerializer


class ReportLostItemView(generics.CreateAPIView):
    serializer_class = LostItemSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def perform_create(self, serializer):
        tracking_code = str(uuid.uuid4()).replace('-', '')[:16]
        serializer.save(user=self.request.user, qr_tracking_code=tracking_code)

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        except Exception as e:
            return Response({'error': 'Failed to report lost item.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ReportFoundItemView(generics.CreateAPIView):
    serializer_class = FoundItemSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def perform_create(self, serializer):
        serializer.save(reported_by=self.request.user)

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        except Exception as e:
            return Response({'error': 'Failed to report found item.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class MyLostItemsView(generics.ListAPIView):
    serializer_class = LostItemListSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return LostItem.objects.filter(user=self.request.user)

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            page = self.paginate_queryset(queryset)
            if page is not None:
                serializer = self.get_serializer(page, many=True)
                return self.get_paginated_response(serializer.data)
            serializer = self.get_serializer(queryset, many=True)
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': 'Failed to retrieve lost items.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class SearchLostItemsView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        try:
            tracking_code = request.query_params.get('tracking_code', '')
            if not tracking_code:
                return Response({'error': 'tracking_code query parameter is required.'}, status=status.HTTP_400_BAD_REQUEST)

            try:
                item = LostItem.objects.get(qr_tracking_code=tracking_code)
                serializer = LostItemSerializer(item)
                return Response(serializer.data)
            except LostItem.DoesNotExist:
                return Response({'error': 'No lost item found with this tracking code.'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': 'Search failed.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class MatchItemsView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        try:
            category = request.query_params.get('category')
            location = request.query_params.get('location')

            lost_qs = LostItem.objects.filter(status='open')
            found_qs = FoundItem.objects.filter(status='unclaimed')

            if category:
                lost_qs = lost_qs.filter(category=category)
                found_qs = found_qs.filter(category=category)
            if location:
                lost_qs = lost_qs.filter(location_lost__icontains=location)
                found_qs = found_qs.filter(location_found__icontains=location)

            lost_data = LostItemListSerializer(lost_qs, many=True).data
            found_data = FoundItemSerializer(found_qs, many=True).data

            matches = []
            for lost in lost_qs:
                for found in found_qs:
                    if lost.category == found.category:
                        matches.append({
                            'lost_item': LostItemListSerializer(lost).data,
                            'found_item': FoundItemSerializer(found).data,
                            'match_score': 0.5,
                        })

            return Response({
                'matches': matches[:20],
                'lost_count': lost_qs.count(),
                'found_count': found_qs.count(),
            })
        except Exception as e:
            return Response({'error': 'Failed to match items.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
