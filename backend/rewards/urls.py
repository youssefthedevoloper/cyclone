from django.urls import path

from . import views

urlpatterns = [
    path('xp-history/', views.XPHistoryView.as_view(), name='xp-history'),
    path('achievements/', views.AchievementsView.as_view(), name='achievements'),
    path('level/', views.UserLevelView.as_view(), name='user-level'),
]
