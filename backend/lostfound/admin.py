from django.contrib import admin

from .models import FoundItem, LostItem


class LostItemAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'category', 'status', 'location_lost', 'date_reported', 'qr_tracking_code')
    list_filter = ('category', 'status', 'date_reported')
    search_fields = ('user__email', 'description', 'location_lost', 'qr_tracking_code', 'ai_classification')
    readonly_fields = ('id', 'user', 'date_reported', 'qr_tracking_code', 'ai_classification', 'created_at', 'updated_at')


class FoundItemAdmin(admin.ModelAdmin):
    list_display = ('id', 'reported_by', 'category', 'status', 'location_found', 'date_found')
    list_filter = ('category', 'status', 'date_found')
    search_fields = ('reported_by__email', 'description', 'location_found')
    readonly_fields = ('id', 'reported_by', 'date_found')


admin.site.register(LostItem, LostItemAdmin)
admin.site.register(FoundItem, FoundItemAdmin)
