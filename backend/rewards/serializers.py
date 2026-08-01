from rest_framework import serializers

from .models import Achievement, UserAchievement, UserLevel, XPTransaction


class XPTransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = XPTransaction
        fields = ('id', 'user', 'amount', 'reason', 'created_at')
        read_only_fields = ('id', 'user', 'created_at')


class AchievementSerializer(serializers.ModelSerializer):
    earned = serializers.SerializerMethodField()
    earned_at = serializers.SerializerMethodField()

    class Meta:
        model = Achievement
        fields = ('id', 'code', 'name', 'description', 'icon_url', 'xp_reward', 'earned', 'earned_at')
        read_only_fields = ('id',)

    def get_earned(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return UserAchievement.objects.filter(user=request.user, achievement=obj).exists()
        return False

    def get_earned_at(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            ua = UserAchievement.objects.filter(user=request.user, achievement=obj).first()
            if ua:
                return ua.earned_at
        return None


class UserLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserLevel
        fields = ('id', 'user', 'level', 'total_xp', 'tier')
        read_only_fields = ('id', 'user')
