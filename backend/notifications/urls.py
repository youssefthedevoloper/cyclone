from django.urls import path

from . import views

urlpatterns = [
    path('', views.NotificationListView.as_view(), name='notification-list'),
    path('mark-all-read/', views.NotificationMarkAllReadView.as_view(), name='notification-mark-all-read'),
    path('preferences/', views.NotificationPreferenceView.as_view(), name='notification-preferences'),
    path('<uuid:pk>/', views.NotificationListView.as_view(), name='notification-mark-read'),
]
