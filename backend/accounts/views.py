from django.contrib.auth import get_user_model
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenRefreshView as SimpleJWTTokenRefreshView

from .models import Profile
from .serializers import (
    RegisterSerializer,
    LoginSerializer,
    UserSerializer,
    ProfileSerializer,
    SocialAuthSerializer,
    GuestSerializer,
)

User = get_user_model()


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = RegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        refresh = RefreshToken.for_user(user)
        return Response({
            'user': UserSerializer(user).data,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        serializer = LoginSerializer(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        return Response({
            'user': UserSerializer(serializer.validated_data['user']).data,
            'refresh': serializer.validated_data['refresh'],
            'access': serializer.validated_data['access'],
        })


class TokenRefreshView(SimpleJWTTokenRefreshView):
    pass


class GoogleLoginView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        serializer = SocialAuthSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data.get('email')
        access_token = serializer.validated_data.get('access_token')

        if access_token:
            import requests
            google_url = f'https://www.googleapis.com/oauth2/v3/tokeninfo?id_token={access_token}'
            resp = requests.get(google_url)
            if resp.status_code != 200:
                return Response({'error': 'Invalid Google token.'}, status=status.HTTP_400_BAD_REQUEST)
            google_data = resp.json()
            email = google_data.get('email', email)

        if not email:
            return Response({'error': 'Could not retrieve email from Google.'}, status=status.HTTP_400_BAD_REQUEST)

        user, created = User.objects.get_or_create(
            email=email,
            defaults={
                'username': email.split('@')[0],
                'name': email.split('@')[0],
                'auth_provider': 'google',
                'email_verified': True,
            }
        )
        if created:
            user.set_password(User.objects.make_random_password())
            user.save()

        refresh = RefreshToken.for_user(user)
        return Response({
            'user': UserSerializer(user).data,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'created': created,
        })


class AppleLoginView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        serializer = SocialAuthSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data.get('email')

        if not email:
            return Response({'error': 'Email is required for Apple login.'}, status=status.HTTP_400_BAD_REQUEST)

        user, created = User.objects.get_or_create(
            email=email,
            defaults={
                'username': email.split('@')[0],
                'name': email.split('@')[0],
                'auth_provider': 'apple',
                'email_verified': True,
            }
        )
        if created:
            user.set_password(User.objects.make_random_password())
            user.save()

        refresh = RefreshToken.for_user(user)
        return Response({
            'user': UserSerializer(user).data,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'created': created,
        })


class PhoneLoginView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        phone = request.data.get('phone')
        otp = request.data.get('otp')

        if not phone or not otp:
            return Response({'error': 'Phone and OTP are required.'}, status=status.HTTP_400_BAD_REQUEST)

        if otp != '123456':
            return Response({'error': 'Invalid OTP.'}, status=status.HTTP_400_BAD_REQUEST)

        user, created = User.objects.get_or_create(
            phone=phone,
            defaults={
                'username': f'phone_{phone}',
                'email': f'phone_{phone}@cyclone.local',
                'auth_provider': 'phone',
                'phone_verified': True,
            }
        )
        if created:
            user.set_password(User.objects.make_random_password())
            user.save()

        refresh = RefreshToken.for_user(user)
        return Response({
            'user': UserSerializer(user).data,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'created': created,
        })


class GuestLoginView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        serializer = GuestSerializer(data={})
        serializer.is_valid(raise_exception=True)
        user = serializer.create(serializer.validated_data)
        refresh = RefreshToken.for_user(user)
        return Response({
            'user': UserSerializer(user).data,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }, status=status.HTTP_201_CREATED)


class MeView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user


class ProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = ProfileSerializer

    def get_object(self):
        profile, _ = Profile.objects.get_or_create(user=self.request.user)
        return profile


class VerifyEmailView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        email = request.data.get('email')
        token = request.data.get('token')

        if not email or not token:
            return Response({'error': 'Email and token are required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

        if token != 'dummy-verify-token':
            return Response({'error': 'Invalid verification token.'}, status=status.HTTP_400_BAD_REQUEST)

        user.email_verified = True
        user.save()
        return Response({'detail': 'Email verified successfully.'})


class ForgotPasswordView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        email = request.data.get('email')

        if not email:
            return Response({'error': 'Email is required.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'detail': 'If the email exists, a reset link has been sent.'})

        return Response({'detail': 'If the email exists, a reset link has been sent.'})


class ResetPasswordView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        email = request.data.get('email')
        token = request.data.get('token')
        new_password = request.data.get('new_password')

        if not email or not token or not new_password:
            return Response({'error': 'Email, token, and new_password are required.'}, status=status.HTTP_400_BAD_REQUEST)

        if token != 'dummy-reset-token':
            return Response({'error': 'Invalid reset token.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({'error': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

        user.set_password(new_password)
        user.save()
        return Response({'detail': 'Password reset successfully.'})
