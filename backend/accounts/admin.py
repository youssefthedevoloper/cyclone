from django.contrib import admin
from .models import User, Profile


class UserAdmin(admin.ModelAdmin):
    list_display = ('email', 'username', 'name', 'auth_provider', 'is_guest', 'is_active', 'is_staff')
    list_filter = ('auth_provider', 'is_guest', 'is_active', 'is_staff', 'email_verified', 'phone_verified')
    search_fields = ('email', 'username', 'name', 'phone', 'passport_number', 'frequent_flyer_number')
    ordering = ('email',)
    readonly_fields = ('id', 'date_joined', 'last_login')


class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'city', 'country', 'date_of_birth')
    list_filter = ('country', 'city')
    search_fields = ('user__email', 'user__username', 'address', 'city', 'country', 'postal_code')


admin.site.register(User, UserAdmin)
admin.site.register(Profile, ProfileAdmin)
