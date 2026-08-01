import re

from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .fallback import LANGUAGES, _LANG_MAP, WORD_DICT
from .serializers import OCRTranslateSerializer, TranslateSerializer


def _local_translate(text, target_code):
    lower = text.lower().strip()
    words = re.split(r'\s+', lower)

    for phrase_key, translations in WORD_DICT.items():
        if phrase_key in lower:
            translation = translations.get(target_code)
            if translation:
                if lower == phrase_key:
                    return translation
                return re.sub(phrase_key, translation, text, flags=re.IGNORECASE)

    translated_words = []
    for word in words:
        cleaned = re.sub(r'[^\w\s]', '', word)
        match = WORD_DICT.get(cleaned)
        if match and target_code in match:
            translated_words.append(match[target_code])
        else:
            translated_words.append(cleaned)

    if any(re.search(r'[a-zA-Z]', w) for w in translated_words):
        return ' '.join(translated_words)

    if translated_words:
        return ' '.join(translated_words)

    return f'[{target_code}] {text}'


def _detect_language(text):
    import re as _re
    if _re.search(r'[\u0600-\u06FF]', text):
        return 'Arabic'
    if _re.search(r'[ğüşıöçĞÜŞİÖÇ]', text):
        return 'Turkish'
    lower = text.lower().strip()
    french_words = {'bonjour', 'merci', "s'il vous plaît", 'au revoir', 'oui', 'non'}
    spanish_words = {'hola', 'gracias', 'adiós', 'por favor', 'sí', 'no'}
    german_words = {'hallo', 'danke', 'tschüss', 'bitte', 'ja', 'nein'}
    italian_words = {'ciao', 'grazie', 'arrivederci', 'per favore', 'sì', 'no'}
    if any(lower.startswith(w) for w in french_words):
        return 'French'
    if any(lower.startswith(w) for w in spanish_words):
        return 'Spanish'
    if any(lower.startswith(w) for w in german_words):
        return 'German'
    if any(lower.startswith(w) for w in italian_words):
        return 'Italian'
    return 'English'


class TranslateView(APIView):
    permission_classes = (AllowAny,)

    def post(self, request):
        serializer = TranslateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        text = serializer.validated_data['text']
        source = serializer.validated_data['source_language'].lower()
        target = serializer.validated_data['target_language'].lower()

        src = _LANG_MAP.get(source, source)
        tgt = _LANG_MAP.get(target, target)

        if src == 'auto':
            src = 'auto'

        try:
            from deep_translator import GoogleTranslator
            if src == 'auto':
                result = GoogleTranslator(source='auto', target=tgt).translate(text)
                detected = 'English'
            else:
                result = GoogleTranslator(source=src, target=tgt).translate(text)
                detected = None

            if result is None:
                result = text

            return Response({'translated_text': result, 'detected_language': detected})
        except Exception:
            detected = None
            if src == 'auto':
                detected = _detect_language(text)
            fallback_result = _local_translate(text, tgt if tgt != 'auto' else 'en')
            return Response({'translated_text': fallback_result, 'detected_language': detected})


class LanguageListView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        return Response(LANGUAGES)


class OCRTranslateView(APIView):
    permission_classes = (AllowAny,)

    def post(self, request):
        serializer = OCRTranslateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        text = serializer.validated_data['text']
        source = serializer.validated_data.get('source_language', 'auto').lower()
        target = serializer.validated_data['target_language'].lower()

        src = _LANG_MAP.get(source, source)
        tgt = _LANG_MAP.get(target, target)

        if src == 'auto':
            src = 'auto'

        try:
            from deep_translator import GoogleTranslator
            if src == 'auto':
                result = GoogleTranslator(source='auto', target=tgt).translate(text)
                detected = 'English'
            else:
                result = GoogleTranslator(source=src, target=tgt).translate(text)
                detected = None

            if result is None:
                result = text

            return Response({'translated_text': result, 'detected_language': detected, 'ocr_text': text})
        except Exception:
            detected = None
            if src == 'auto':
                detected = _detect_language(text)
            fallback_result = _local_translate(text, tgt if tgt != 'auto' else 'en')
            return Response({'translated_text': fallback_result, 'detected_language': detected, 'ocr_text': text})
