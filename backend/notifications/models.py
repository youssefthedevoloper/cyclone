import uuid

from django.conf import settings
from django.db import models


class Notification(models.Model):
    NOTIFICATION_TYPES = (
        ('boarding', 'Boarding'),
        ('gate_change', 'Gate Change'),
        ('delay', 'Delay'),
        ('weather', 'Weather'),
        ('security', 'Security'),
        ('promotion', 'Promotion'),
        ('general', 'General'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notifications')
    type = models.CharField(max_length=20, choices=NOTIFICATION_TYPES, default='general')
    title = models.CharField(max_length=255)
    body = models.TextField(blank=True, default='')
    data = models.JSONField(null=True, blank=True, default=dict)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ('-created_at',)

    def __str__(self):
        return f'[{self.type}] {self.title} - {self.user.email}'


class NotificationPreference(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notification_preferences')
    notification_type = models.CharField(max_length=20, choices=Notification.NOTIFICATION_TYPES)
    enabled = models.BooleanField(default=True)

    class Meta:
        unique_together = ('user', 'notification_type')
        verbose_name = 'Notification Preference'
        verbose_name_plural = 'Notification Preferences'

    def __str__(self):
        return f'{self.user.email} - {self.notification_type}: {"enabled" if self.enabled else "disabled"}'
