import uuid

from django.utils import timezone
from rest_framework import generics, status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Promotion, UserPromotion
from .serializers import PromotionSerializer, UserPromotionSerializer


class AvailablePromotionsView(generics.ListAPIView):
    serializer_class = PromotionSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        now = timezone.now()
        return Promotion.objects.filter(
            is_active=True,
            start_date__lte=now,
            end_date__gte=now,
        )

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
            return Response({'error': 'Failed to retrieve promotions.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ClaimPromotionView(generics.CreateAPIView):
    serializer_class = UserPromotionSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def create(self, request, *args, **kwargs):
        try:
            promotion_id = request.data.get('promotion_id')
            if not promotion_id:
                return Response({'error': 'promotion_id is required.'}, status=status.HTTP_400_BAD_REQUEST)

            try:
                promotion = Promotion.objects.get(id=promotion_id, is_active=True)
            except Promotion.DoesNotExist:
                return Response({'error': 'Promotion not found or inactive.'}, status=status.HTTP_404_NOT_FOUND)

            if UserPromotion.objects.filter(user=request.user, promotion=promotion).exists():
                return Response({'error': 'Promotion already claimed.'}, status=status.HTTP_409_CONFLICT)

            qr_code = str(uuid.uuid4())
            user_promo = UserPromotion.objects.create(
                user=request.user,
                promotion=promotion,
                qr_code=qr_code,
            )
            serializer = self.get_serializer(user_promo)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except Exception as e:
            return Response({'error': 'Failed to claim promotion.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class MyPromotionsView(generics.ListAPIView):
    serializer_class = UserPromotionSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return UserPromotion.objects.filter(user=self.request.user).select_related('promotion')

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
            return Response({'error': 'Failed to retrieve your promotions.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
