from django.urls import path

from . import views

urlpatterns = [
    path('', views.FlightListView.as_view(), name='flight-list'),
    path('live/', views.LiveFlightTracker.as_view(), name='flight-live'),
    path('search/', views.FlightSearchView.as_view(), name='flight-search'),
    path('<uuid:id>/', views.FlightDetailView.as_view(), name='flight-detail'),
]
