from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status


@api_view(["POST"])
@permission_classes([AllowAny])
def translate_text(request):
    """Translate text between languages using Google Translate."""
    text = request.data.get("text", "").strip()
    source_lang = request.data.get("source_language", "auto")
    target_lang = request.data.get("target_language", "en")

    if not text:
        return Response(
            {"error": "No text provided."},
            status=status.HTTP_400_BAD_REQUEST,
        )

    try:
        lang_map = {
            "Arabic": "ar",
            "English": "en",
            "French": "fr",
            "German": "de",
            "Spanish": "es",
            "Italian": "it",
            "Turkish": "tr",
            "auto": "auto",
        }

        src = lang_map.get(source_lang, "auto")
        tgt = lang_map.get(target_lang, "en")

        # Mock translation for development (replace with real API call)
        translated = f"[{target_lang}] {text}"

        # Detect language if auto
        detected = None
        if source_lang == "Auto" or source_lang == "auto":
            detected = "en"

        return Response(
            {
                "translated_text": translated,
                "detected_language": detected,
                "source_language": source_lang,
                "target_language": target_lang,
            },
            status=status.HTTP_200_OK,
        )

    except Exception as e:
        return Response(
            {
                "error": f"Translation failed: {str(e)}",
                "translated_text": text,
                "detected_language": None,
            },
            status=status.HTTP_200_OK,
        )


@api_view(["GET"])
@permission_classes([AllowAny])
def health_check(request):
    """Health check endpoint for translator service."""
    return Response({"status": "ok", "service": "translator"})
