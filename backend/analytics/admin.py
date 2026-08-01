from django.contrib import admin

from .models import Event, PageView


class EventAdmin(admin.ModelAdmin):
    list_display = ('event_type', 'user', 'session_id', 'created_at')
    list_filter = ('event_type', 'created_at')
    search_fields = ('event_type', 'session_id', 'properties')
    readonly_fields = ('id', 'created_at')
    ordering = ('-created_at',)


class PageViewAdmin(admin.ModelAdmin):
    list_display = ('path', 'user', 'duration_seconds', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('path',)
    readonly_fields = ('id', 'created_at')
    ordering = ('-created_at',)


admin.site.register(Event, EventAdmin)
admin.site.register(PageView, PageViewAdmin)
