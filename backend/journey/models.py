import uuid

from django.conf import settings
from django.db import models


class Journey(models.Model):
    STATUS_CHOICES = (
        ('not_started', 'Not Started'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='journeys')
    flight = models.ForeignKey('flights.Flight', on_delete=models.CASCADE, related_name='journeys')
    start_time = models.DateTimeField(null=True, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='not_started')
    current_step = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('-created_at',)
        verbose_name_plural = 'Journeys'

    def __str__(self):
        return f'{self.user.email} - {self.flight.flight_number}'


class JourneyStep(models.Model):
    STEP_TYPE_CHOICES = (
        ('leave_home', 'Leave Home'),
        ('arrive_airport', 'Arrive at Airport'),
        ('parking', 'Parking'),
        ('check_in', 'Check-in'),
        ('bag_drop', 'Bag Drop'),
        ('passport_control', 'Passport Control'),
        ('security', 'Security'),
        ('duty_free', 'Duty Free'),
        ('gate', 'Gate'),
        ('boarding', 'Boarding'),
        ('seat', 'Seat'),
    )

    journey = models.ForeignKey(Journey, on_delete=models.CASCADE, related_name='steps')
    step_type = models.CharField(max_length=30, choices=STEP_TYPE_CHOICES)
    order = models.PositiveIntegerField()
    estimated_minutes = models.PositiveIntegerField(default=0)
    is_completed = models.BooleanField(default=False)
    completed_at = models.DateTimeField(null=True, blank=True)
    instructions = models.TextField(blank=True, default='')
    voice_guide_url = models.URLField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('order',)
        unique_together = ('journey', 'order')

    def __str__(self):
        return f'{self.get_step_type_display()} - {self.journey.flight.flight_number}'


class TravelChecklist(models.Model):
    CATEGORY_CHOICES = (
        ('documents', 'Documents'),
        ('electronics', 'Electronics'),
        ('medicine', 'Medicine'),
        ('clothing', 'Clothing'),
        ('other', 'Other'),
    )

    journey = models.ForeignKey(Journey, on_delete=models.CASCADE, related_name='checklist_items')
    item_name = models.CharField(max_length=255)
    is_packed = models.BooleanField(default=False)
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='other')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('category', 'item_name')
        verbose_name_plural = 'Travel Checklist Items'

    def __str__(self):
        return f'{self.item_name} ({self.get_category_display()})'
