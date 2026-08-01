import uuid

from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    AUTH_PROVIDER_CHOICES = (
        ('email', 'Email'),
        ('google', 'Google'),
        ('apple', 'Apple'),
        ('phone', 'Phone'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True, db_index=True)
    name = models.CharField(max_length=255, blank=True, default='')
    age = models.IntegerField(null=True, blank=True)
    nationality = models.CharField(max_length=100, blank=True, default='')
    passport_number = models.CharField(max_length=50, blank=True, default='')
    visa_info = models.JSONField(null=True, blank=True, default=dict)
    language = models.CharField(max_length=50, blank=True, default='')
    emergency_contact_name = models.CharField(max_length=255, blank=True, default='')
    emergency_contact_phone = models.CharField(max_length=50, blank=True, default='')
    special_needs = models.TextField(blank=True, default='')
    medical_notes = models.TextField(blank=True, default='')
    frequent_flyer_number = models.CharField(max_length=50, blank=True, default='')
    is_guest = models.BooleanField(default=False)
    email_verified = models.BooleanField(default=False)
    phone = models.CharField(max_length=50, blank=True, default='')
    phone_verified = models.BooleanField(default=False)
    avatar = models.URLField(blank=True, default='')
    auth_provider = models.CharField(max_length=20, choices=AUTH_PROVIDER_CHOICES, default='email')

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta:
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    def __str__(self):
        return self.email or self.username


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    date_of_birth = models.DateField(null=True, blank=True)
    address = models.CharField(max_length=500, blank=True, default='')
    city = models.CharField(max_length=100, blank=True, default='')
    country = models.CharField(max_length=100, blank=True, default='')
    postal_code = models.CharField(max_length=20, blank=True, default='')

    class Meta:
        verbose_name = 'Profile'
        verbose_name_plural = 'Profiles'

    def __str__(self):
        return f'{self.user.email} Profile'
