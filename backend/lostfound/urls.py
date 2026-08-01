from django.urls import path

from . import views

urlpatterns = [
    path('report-lost/', views.ReportLostItemView.as_view(), name='report-lost'),
    path('report-found/', views.ReportFoundItemView.as_view(), name='report-found'),
    path('my-items/', views.MyLostItemsView.as_view(), name='my-lost-items'),
    path('search/', views.SearchLostItemsView.as_view(), name='search-lost-items'),
    path('match/', views.MatchItemsView.as_view(), name='match-items'),
]
