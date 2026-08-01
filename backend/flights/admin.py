from django.contrib import admin

from .models import Airport, Airline, Flight, FlightUpdate


class AirportAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'city', 'country', 'terminal_count', 'timezone')
    list_filter = ('country', 'timezone')
    search_fields = ('code', 'name', 'city', 'country')


class AirlineAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'alliance')
    list_filter = ('alliance',)
    search_fields = ('code', 'name')


class FlightAdmin(admin.ModelAdmin):
    list_display = ('flight_number', 'airline', 'departure_airport', 'arrival_airport',
                    'departure_time', 'arrival_time', 'status', 'gate', 'terminal')
    list_filter = ('status', 'airline', 'departure_airport', 'arrival_airport')
    search_fields = ('flight_number', 'airline__name', 'airline__code',
                     'departure_airport__code', 'arrival_airport__code',
                     'departure_airport__city', 'arrival_airport__city')
    readonly_fields = ('id', 'created_at', 'updated_at')
    date_hierarchy = 'departure_time'


class FlightUpdateAdmin(admin.ModelAdmin):
    list_display = ('flight', 'new_status', 'new_gate', 'reason', 'created_at')
    list_filter = ('new_status',)
    search_fields = ('flight__flight_number', 'reason')
    readonly_fields = ('created_at',)


admin.site.register(Airport, AirportAdmin)
admin.site.register(Airline, AirlineAdmin)
admin.site.register(Flight, FlightAdmin)
admin.site.register(FlightUpdate, FlightUpdateAdmin)
