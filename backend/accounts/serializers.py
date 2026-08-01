from django.contrib.auth import get_user_model, authenticate
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken

from .models import Profile

User = get_user_model()


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ('email', 'username', 'password', 'name', 'phone', 'auth_provider')

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        user = authenticate(request=self.context.get('request'), email=email, password=password)
        if not user:
            raise serializers.ValidationError('Invalid email or password.')
        if not user.is_active:
            raise serializers.ValidationError('User account is disabled.')

        refresh = RefreshToken.for_user(user)
        attrs['user'] = user
        attrs['refresh'] = str(refresh)
        attrs['access'] = str(refresh.access_token)
        return attrs


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            'id', 'email', 'username', 'name', 'age', 'nationality',
            'passport_number', 'visa_info', 'language',
            'emergency_contact_name', 'emergency_contact_phone',
            'special_needs', 'medical_notes', 'frequent_flyer_number',
            'is_guest', 'email_verified', 'phone', 'phone_verified',
            'avatar', 'auth_provider', 'date_joined', 'last_login',
        )
        read_only_fields = (
            'id', 'email', 'is_guest', 'email_verified', 'auth_provider',
            'date_joined', 'last_login',
        )


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ('date_of_birth', 'address', 'city', 'country', 'postal_code')


class SocialAuthSerializer(serializers.Serializer):
    provider = serializers.ChoiceField(choices=['google', 'apple'])
    access_token = serializers.CharField(required=False, allow_blank=True)
    email = serializers.EmailField(required=False, allow_blank=True)

    def validate(self, attrs):
        if not attrs.get('access_token') and not attrs.get('email'):
            raise serializers.ValidationError('Either access_token or email must be provided.')
        return attrs


class GuestSerializer(serializers.Serializer):
    def create(self, validated_data):
        import uuid
        guest_id = str(uuid.uuid4())[:8]
        user = User(
            username=f'guest_{guest_id}',
            email=f'guest_{guest_id}@cyclone.local',
            is_guest=True,
            auth_provider='email',
        )
        user.set_password(uuid.uuid4().hex)
        user.save()
        return user
