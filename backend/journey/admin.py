from django.contrib import admin

from .models import Journey, JourneyStep, TravelChecklist


class JourneyStepInline(admin.TabularInline):
    model = JourneyStep
    extra = 0
    ordering = ('order',)


class TravelChecklistInline(admin.TabularInline):
    model = TravelChecklist
    extra = 0


class JourneyAdmin(admin.ModelAdmin):
    list_display = ('user', 'flight', 'status', 'start_time', 'current_step')
    list_filter = ('status',)
    search_fields = ('user__email', 'flight__flight_number')
    readonly_fields = ('id',)
    inlines = [JourneyStepInline, TravelChecklistInline]


class JourneyStepAdmin(admin.ModelAdmin):
    list_display = ('journey', 'step_type', 'order', 'is_completed', 'completed_at')
    list_filter = ('step_type', 'is_completed')
    search_fields = ('journey__user__email', 'journey__flight__flight_number')


class TravelChecklistAdmin(admin.ModelAdmin):
    list_display = ('journey', 'item_name', 'is_packed', 'category')
    list_filter = ('category', 'is_packed')
    search_fields = ('item_name', 'journey__user__email')


admin.site.register(Journey, JourneyAdmin)
admin.site.register(JourneyStep, JourneyStepAdmin)
admin.site.register(TravelChecklist, TravelChecklistAdmin)
