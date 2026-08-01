from django.urls import path

from . import views

urlpatterns = [
    path('translator/translate/', views.TranslateView.as_view(), name='translator-translate'),
    path('translator/languages/', views.LanguageListView.as_view(), name='translator-languages'),
    path('translator/ocr/', views.OCRTranslateView.as_view(), name='translator-ocr'),
]
