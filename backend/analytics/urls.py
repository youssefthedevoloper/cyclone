from django.urls import path

from . import views

urlpatterns = [
    path('analytics/dashboard/', views.DashboardStatsView.as_view(), name='analytics-dashboard'),
    path('analytics/growth/', views.UserGrowthView.as_view(), name='analytics-growth'),
    path('analytics/features/', views.FeatureUsageView.as_view(), name='analytics-features'),
    path('analytics/airports/', views.AirportStatsView.as_view(), name='analytics-airports'),
]
