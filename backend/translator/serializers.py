from rest_framework import serializers


class TranslateSerializer(serializers.Serializer):
    text = serializers.CharField(required=True)
    source_language = serializers.CharField(required=True)
    target_language = serializers.CharField(required=True)


class OCRTranslateSerializer(serializers.Serializer):
    text = serializers.CharField(required=True)
    source_language = serializers.CharField(default='auto')
    target_language = serializers.CharField(required=True)


class LanguageSerializer(serializers.Serializer):
    code = serializers.CharField()
    name = serializers.CharField()
    native_name = serializers.CharField()
