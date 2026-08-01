from django.db import models
from rest_framework import generics, status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Achievement, UserAchievement, UserLevel, XPTransaction
from .serializers import AchievementSerializer, UserLevelSerializer, XPTransactionSerializer


class XPHistoryView(generics.ListAPIView):
    serializer_class = XPTransactionSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return XPTransaction.objects.filter(user=self.request.user)

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            page = self.paginate_queryset(queryset)
            if page is not None:
                serializer = self.get_serializer(page, many=True)
                return self.get_paginated_response(serializer.data)
            serializer = self.get_serializer(queryset, many=True)
            total_xp = queryset.aggregate(total=models.Sum('amount'))['total'] or 0
            return Response({'total_xp': total_xp, 'transactions': serializer.data})
        except Exception as e:
            return Response({'error': 'Failed to retrieve XP history.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class AchievementsView(generics.ListAPIView):
    serializer_class = AchievementSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return Achievement.objects.all()

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            serializer = self.get_serializer(queryset, many=True)
            earned_count = UserAchievement.objects.filter(user=request.user).count()
            return Response({
                'earned_count': earned_count,
                'total_count': queryset.count(),
                'results': serializer.data,
            })
        except Exception as e:
            return Response({'error': 'Failed to retrieve achievements.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class UserLevelView(generics.RetrieveAPIView):
    serializer_class = UserLevelSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_object(self):
        level, _ = UserLevel.objects.get_or_create(user=self.request.user)
        return level

    def retrieve(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': 'Failed to retrieve level.', 'detail': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



