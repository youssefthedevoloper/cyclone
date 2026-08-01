from django.urls import path

from . import views

urlpatterns = [
    path('maps/airport/<str:code>/', views.AirportMapView.as_view(), name='maps-airport-detail'),
    path('maps/airport/', views.AirportMapView.as_view(), name='maps-airport-default'),
    path('maps/search/', views.SearchAmenitiesView.as_view(), name='maps-search'),
    path('maps/terminals/<str:terminal>/', views.TerminalDetailView.as_view(), name='maps-terminal-detail'),
]
