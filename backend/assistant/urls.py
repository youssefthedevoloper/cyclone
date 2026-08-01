from django.urls import path

from . import views

urlpatterns = [
    path('assistant/chat/', views.ChatView.as_view(), name='assistant-chat'),
    path('assistant/suggestions/', views.SuggestionsView.as_view(), name='assistant-suggestions'),
]
