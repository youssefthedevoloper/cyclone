from django.urls import path

from . import views

urlpatterns = [
    path('available/', views.AvailablePromotionsView.as_view(), name='promotions-available'),
    path('claim/', views.ClaimPromotionView.as_view(), name='promotions-claim'),
    path('my/', views.MyPromotionsView.as_view(), name='promotions-my'),
]
