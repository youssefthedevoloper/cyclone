from django.urls import path
from . import views

urlpatterns = [
    path('auth/register/', views.RegisterView.as_view(), name='auth-register'),
    path('auth/login/', views.LoginView.as_view(), name='auth-login'),
    path('auth/token/refresh/', views.TokenRefreshView.as_view(), name='auth-token-refresh'),
    path('auth/google/', views.GoogleLoginView.as_view(), name='auth-google'),
    path('auth/apple/', views.AppleLoginView.as_view(), name='auth-apple'),
    path('auth/phone/', views.PhoneLoginView.as_view(), name='auth-phone'),
    path('auth/guest/', views.GuestLoginView.as_view(), name='auth-guest'),
    path('auth/me/', views.MeView.as_view(), name='auth-me'),
    path('auth/profile/', views.ProfileView.as_view(), name='auth-profile'),
    path('auth/verify-email/', views.VerifyEmailView.as_view(), name='auth-verify-email'),
    path('auth/forgot-password/', views.ForgotPasswordView.as_view(), name='auth-forgot-password'),
    path('auth/reset-password/', views.ResetPasswordView.as_view(), name='auth-reset-password'),
]
