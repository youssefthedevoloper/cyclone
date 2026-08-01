from django.urls import path

from . import views

urlpatterns = [
    path('contacts/', views.EmergencyContactsView.as_view(), name='emergency-contacts'),
    path('airport-help/', views.AirportHelpView.as_view(), name='airport-help'),
    path('send-alert/', views.SendEmergencyAlertView.as_view(), name='send-emergency-alert'),
]
