from django.urls import path

from . import views

urlpatterns = [
    path('', views.JourneyView.as_view(), name='journey-detail'),
    path('steps/', views.JourneyStepView.as_view(), name='journey-steps'),
    path('steps/<uuid:pk>/', views.JourneyStepView.as_view(), name='journey-step-complete'),
    path('checklist/', views.ChecklistView.as_view(), name='journey-checklist'),
    path('checklist/<uuid:pk>/', views.ChecklistView.as_view(), name='journey-checklist-item'),
]
