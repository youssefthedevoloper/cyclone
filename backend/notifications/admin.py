from django.contrib import admin

from .models import Notification, NotificationPreference


class NotificationAdmin(admin.ModelAdmin):
    list_display = ('title', 'user', 'type', 'is_read', 'created_at')
    list_filter = ('type', 'is_read')
    search_fields = ('title', 'body', 'user__email')
    readonly_fields = ('id', 'created_at')


class NotificationPreferenceAdmin(admin.ModelAdmin):
    list_display = ('user', 'notification_type', 'enabled')
    list_filter = ('enabled', 'notification_type')
    search_fields = ('user__email',)


admin.site.register(Notification, NotificationAdmin)
admin.site.register(NotificationPreference, NotificationPreferenceAdmin)
