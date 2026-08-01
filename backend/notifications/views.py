from rest_framework import generics, status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Notification, NotificationPreference
from .serializers import (
    NotificationPreferenceSerializer,
    NotificationSerializer,
)


class NotificationListView(generics.ListAPIView):
    serializer_class = NotificationSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        unread_count = queryset.filter(is_read=False).count()
        return Response({
            'count': len(serializer.data),
            'unread_count': unread_count,
            'results': serializer.data,
        })

    def patch(self, request, *args, **kwargs):
        notification_id = kwargs.get('pk')
        if not notification_id:
            return Response({'error': 'Notification ID required.'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            notification = Notification.objects.get(id=notification_id, user=request.user)
        except Notification.DoesNotExist:
            return Response({'error': 'Notification not found.'}, status=status.HTTP_404_NOT_FOUND)
        notification.is_read = True
        notification.save(update_fields=['is_read'])
        return Response(NotificationSerializer(notification).data)


class NotificationMarkAllReadView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        try:
            updated = Notification.objects.filter(user=request.user, is_read=False).update(is_read=True)
            return Response({'marked_read': updated})
        except Exception as e:
            return Response(
                {'error': 'Failed to mark notifications as read.', 'detail': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class NotificationPreferenceView(APIView):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        try:
            prefs = NotificationPreference.objects.filter(user=request.user)
            serializer = NotificationPreferenceSerializer(prefs, many=True)
            return Response(serializer.data)
        except Exception as e:
            return Response(
                {'error': 'Failed to retrieve preferences.', 'detail': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def put(self, request):
        serializer = NotificationPreferenceSerializer(data=request.data, many=True)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        try:
            instances = []
            for item in serializer.validated_data:
                pref, _ = NotificationPreference.objects.update_or_create(
                    user=request.user,
                    notification_type=item['notification_type'],
                    defaults={'enabled': item.get('enabled', True)},
                )
                instances.append(pref)
            result = NotificationPreferenceSerializer(instances, many=True)
            return Response(result.data)
        except Exception as e:
            return Response(
                {'error': 'Failed to update preferences.', 'detail': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
