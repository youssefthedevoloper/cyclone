import uuid

from django.conf import settings
from django.db import models


class Promotion(models.Model):
    CATEGORY_CHOICES = (
        ('restaurant', 'Restaurant'),
        ('duty_free', 'Duty Free'),
        ('hotel', 'Hotel'),
        ('taxi', 'Taxi'),
        ('service', 'Service'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    code = models.CharField(max_length=50, unique=True, db_index=True)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True, default='')
    discount_percent = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    discount_amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    is_active = models.BooleanField(default=True)
    terms = models.TextField(blank=True, default='')
    image_url = models.URLField(blank=True, default='')

    class Meta:
        ordering = ('-start_date',)

    def __str__(self):
        return f'{self.code} - {self.title}'


class UserPromotion(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='promotions')
    promotion = models.ForeignKey(Promotion, on_delete=models.CASCADE, related_name='user_promotions')
    is_used = models.BooleanField(default=False)
    used_at = models.DateTimeField(null=True, blank=True)
    qr_code = models.TextField(blank=True, default='')

    class Meta:
        unique_together = ('user', 'promotion')
        ordering = ('-used_at',)

    def __str__(self):
        return f'{self.user.email} - {self.promotion.code}'
