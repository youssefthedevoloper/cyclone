import uuid

from django.conf import settings
from django.db import models


class LostItem(models.Model):
    CATEGORY_CHOICES = (
        ('electronics', 'Electronics'),
        ('baggage', 'Baggage'),
        ('documents', 'Documents'),
        ('clothing', 'Clothing'),
        ('other', 'Other'),
    )
    STATUS_CHOICES = (
        ('open', 'Open'),
        ('matched', 'Matched'),
        ('closed', 'Closed'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='lost_items')
    description = models.TextField()
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='other')
    location_found = models.CharField(max_length=255, blank=True, default='')
    location_lost = models.CharField(max_length=255, blank=True, default='')
    date_reported = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='open')
    photo_urls = models.JSONField(null=True, blank=True, default=list)
    qr_tracking_code = models.CharField(max_length=100, unique=True, blank=True, null=True)
    ai_classification = models.CharField(max_length=255, blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('-created_at',)

    def __str__(self):
        return f'Lost {self.category} - {self.user.email}'


class FoundItem(models.Model):
    CATEGORY_CHOICES = (
        ('electronics', 'Electronics'),
        ('baggage', 'Baggage'),
        ('documents', 'Documents'),
        ('clothing', 'Clothing'),
        ('other', 'Other'),
    )
    STATUS_CHOICES = (
        ('unclaimed', 'Unclaimed'),
        ('matched', 'Matched'),
        ('returned', 'Returned'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    reported_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name='found_items')
    description = models.TextField()
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='other')
    location_found = models.CharField(max_length=255, blank=True, default='')
    date_found = models.DateTimeField(auto_now_add=True)
    photo_urls = models.JSONField(null=True, blank=True, default=list)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='unclaimed')

    class Meta:
        ordering = ('-date_found',)

    def __str__(self):
        return f'Found {self.category} at {self.location_found}'
