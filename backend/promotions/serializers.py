from rest_framework import serializers

from .models import Promotion, UserPromotion


class PromotionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = '__all__'
        read_only_fields = ('id',)


class UserPromotionSerializer(serializers.ModelSerializer):
    promotion = PromotionSerializer(read_only=True)
    promotion_id = serializers.UUIDField(write_only=True)

    class Meta:
        model = UserPromotion
        fields = ('id', 'user', 'promotion', 'promotion_id', 'is_used', 'used_at', 'qr_code')
        read_only_fields = ('id', 'user', 'is_used', 'used_at', 'qr_code')
