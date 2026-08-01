from django.contrib import admin

from .models import Promotion, UserPromotion


class PromotionAdmin(admin.ModelAdmin):
    list_display = ('code', 'title', 'category', 'discount_percent', 'discount_amount', 'is_active', 'start_date', 'end_date')
    list_filter = ('category', 'is_active', 'start_date', 'end_date')
    search_fields = ('code', 'title', 'description')
    readonly_fields = ('id',)


class UserPromotionAdmin(admin.ModelAdmin):
    list_display = ('user', 'promotion', 'is_used', 'used_at')
    list_filter = ('is_used', 'used_at')
    search_fields = ('user__email', 'promotion__code', 'promotion__title')
    readonly_fields = ('id',)


admin.site.register(Promotion, PromotionAdmin)
admin.site.register(UserPromotion, UserPromotionAdmin)
