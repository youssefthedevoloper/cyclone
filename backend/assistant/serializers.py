from rest_framework import serializers


class ChatMessageSerializer(serializers.Serializer):
    role = serializers.CharField()
    text = serializers.CharField()


class ChatSerializer(serializers.Serializer):
    message = serializers.CharField(required=True)
    history = ChatMessageSerializer(many=True, required=False, default=list)


class SuggestionSerializer(serializers.Serializer):
    id = serializers.CharField()
    text = serializers.CharField()
    icon = serializers.CharField()
