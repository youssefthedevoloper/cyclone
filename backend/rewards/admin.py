from django.contrib import admin

from .models import Achievement, UserAchievement, UserLevel, XPTransaction


class XPTransactionAdmin(admin.ModelAdmin):
    list_display = ('user', 'amount', 'reason', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('user__email', 'reason')
    readonly_fields = ('id', 'created_at')


class AchievementAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'xp_reward')
    search_fields = ('code', 'name', 'description')
    readonly_fields = ('id',)


class UserAchievementAdmin(admin.ModelAdmin):
    list_display = ('user', 'achievement', 'earned_at')
    list_filter = ('earned_at',)
    search_fields = ('user__email', 'achievement__code', 'achievement__name')
    readonly_fields = ('id', 'earned_at')


class UserLevelAdmin(admin.ModelAdmin):
    list_display = ('user', 'level', 'total_xp', 'tier')
    list_filter = ('tier', 'level')
    search_fields = ('user__email',)
    readonly_fields = ('id',)


admin.site.register(XPTransaction, XPTransactionAdmin)
admin.site.register(Achievement, AchievementAdmin)
admin.site.register(UserAchievement, UserAchievementAdmin)
admin.site.register(UserLevel, UserLevelAdmin)
