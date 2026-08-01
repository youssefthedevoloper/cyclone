import os
import re

from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import ChatSerializer

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

SYSTEM_PROMPT = "You are a helpful airport assistant for Cyclone, an airport travel companion app. Answer questions about airport services, gates, dining, lounges, transportation, shopping, and travel tips. Keep answers friendly, concise, and practical. The airport is JFK (John F. Kennedy International Airport) unless the user specifies otherwise."


def _build_prompt(message, history):
    prompt = SYSTEM_PROMPT + "\n\n"
    for h in history[-6:]:
        role = h.get("role", "user")
        text = h.get("text", "")
        prompt += f"{'User' if role == 'user' else 'Assistant'}: {text}\n"
    prompt += f"User: {message}\nAssistant:"
    return prompt


def _call_gemini(prompt):
    try:
        import requests
        resp = requests.post(
            f"{GEMINI_URL}?key={GEMINI_API_KEY}",
            json={"contents": [{"parts": [{"text": prompt}]}]},
            timeout=15,
        )
        if resp.status_code != 200:
            return None
        data = resp.json()
        candidates = data.get("candidates", [])
        if not candidates:
            return None
        text = candidates[0].get("content", {}).get("parts", [{}])[0].get("text", "")
        return text.strip() if text else None
    except Exception:
        return None


def _local_response(message):
    lower = message.lower().strip()

    intents = [
        (["gate", "find", "where.*gate", "navigate", "direction.*gate", "how.*get.*gate", "terminal"], [
            "Here's how to find your gate at JFK:",
            "",
            "• **Check departure screens** — they show the latest gate assignments",
            "• **Gates are organized by terminal**:",
            "  - Terminal 1: Gates 1–11 (Air France, Lufthansa, etc.)",
            "  - Terminal 2: Gates 12–21 (Delta mainly)",
            "  - Terminal 4: Gates B1–B44 (most international)",
            "  - Terminal 5: Gates 1–12 (JetBlue)",
            "  - Terminal 7: Gates 1–12 (British Airways, etc.)",
            "  - Terminal 8: Gates 1–10 (American Airlines)",
            "",
            "💡 **Pro tip:** Gates can change 30 min before departure. Check the app frequently!",
            "",
            "Need me to guide you step by step? Tell me your airline or terminal!",
        ]),
        (["security", "tsa", "checkpoint", "screening", "check.*in", "bag.*drop"], [
            "🔒 **Security at JFK — What to expect:**",
            "",
            "**Wait times:** 15–30 min typically, up to 60 min during peak (6–9 AM, 3–6 PM)",
            "**TSA PreCheck:** Use dedicated lanes if enrolled (usually <5 min)",
            "**Clear:** Available at Terminals 1, 4, 5, and 8",
            "",
            "**What to prepare:**",
            "• **ID + Boarding pass** ready (or mobile boarding pass)",
            "• **Liquids rule:** 3.4oz/100ml containers in one quart-sized bag",
            "• **Electronics:** Laptops, iPads out of bags in separate bins",
            "• **Jacket + belt + shoes** off (unless TSA PreCheck)",
            "",
            "**What NOT to pack in carry-on:**",
            "❌ Water bottles over 3.4oz | ❌ Sharp objects | ❌ Lighters | ❌ Snow globes",
            "",
            "Any specific terminal or airline? I can give more precise info!",
        ]),
        (["food", "restaurant", "eat", "dining", "cafe", "coffee", "drink", "hungry", "lunch", "dinner", "breakfast"], [
            "🍽️ **Dining at JFK — Best picks by terminal:**",
            "",
            "**Terminal 1:**",
            "• Piquillo — Spanish tapas & wine bar",
            "• Starbucks — Coffee & quick bites",
            "",
            "**Terminal 2:**",
            "• Shake Shack — Burgers, shakes (very popular!)",
            "• Palm Bar — Full bar & American fare",
            "",
            "**Terminal 4:**",
            "• Uptown Brasserie — Sit-down American",
            "• Blue Point Brewery — Craft beer & seafood",
            "• Berkshire Farms Market — Healthy bowls",
            "",
            "**Terminal 5:**",
            "• TWA Hotel — Beautiful retro bar & restaurant",
            "• AeroNuova — Italian cuisine",
            "• Starbuck — Coffee & snacks",
            "",
            "**24/7 options:** McDonald's (Terminal 1), Auntie Anne's (Terminal 4)",
            "",
            "Want me to find something specific? Tell me what you're craving!",
        ]),
        (["lounge", "priority.*pass", "vip", "club", "relax", "sit", "nap", "rest"], [
            "✈️ **JFK Lounge Access — Full guide:**",
            "",
            "**Premium Lounges:**",
            "• Delta Sky Club — Terminals 2 & 4 (Delta/SkyTeam) 🏆",
            "• American Admirals Club — Terminal 8 (oneworld)",
            "• United Club — Terminal 7 (Star Alliance)",
            "• Air France/KLM Lounge — Terminal 1 (SkyTeam)",
            "• British Airways Galleries — Terminal 7 (oneworld)",
            "",
            "**Pay-to-Enter/App-Based:**",
            "• **Centurion Lounge** — Terminal 4 (Amex Platinum/Centurion)",
            "• **Chase Sapphire Lounge** — Terminal 5 (Chase Sapphire Reserve)",
            "• **The Club JFK** — Terminal 4 (Priority Pass, DragonPass)",
            "",
            "**Amenities usually include:** Free WiFi, food, drinks, showers, quiet areas",
            "",
            "Which lounge are you interested in? Or tell me your airline & card!",
        ]),
        (["wifi", "internet", "connect", "online", "wireless", "hotspot", "network"], [
            "📶 **JFK WiFi — Get connected:**",
            "",
            "**Free WiFi:**",
            "• Network: **JFK_FREE_WIFI**",
            "• No password — just open browser and accept terms",
            "• Speed: Up to 50 Mbps (good for streaming!)",
            "• Available: All terminals, gates, public areas",
            "",
            "**Premium WiFi:** $7.95/day for faster speeds (boingo)",
            "",
            "**Can't connect?**",
            "• Toggle airplane mode off/on",
            "• Forget network and reconnect",
            "• Ask at info desk for help",
            "",
            "💡 **Pro tip:** Lounges offer complimentary high-speed WiFi too!",
        ]),
        (["charging", "charge", "power", "battery", "plug", "usb", "outlet", "phone.*dead"], [
            "🔋 **Power up at JFK:**",
            "",
            "**Charging stations located at:**",
            "• **Gate areas** — Look for blue charging towers",
            "• **Seating areas** — Many seats now have built-in USB ports & outlets",
            "• **Lounges** — All lounges have plentiful charging",
            "• **Restaurants** — Most tables have nearby outlets",
            "• **Mobile charging lockers** — Available in Terminals 4 & 5",
            "",
            "💡 **Forgot your charger?**",
            "• Tech kiosk at Terminal 4 (near B20) sells cables & power banks",
            "• InMotion stores in Terminals 1, 4, 5, 8",
            "• Some vending machines sell charging cables",
            "",
            "Need directions to the nearest charging spot?",
        ]),
        (["bathroom", "restroom", "toilet", "washroom", "baby", "family"], [
            "🚻 **Restrooms & Facilities at JFK:**",
            "",
            "• Located at **all gate areas** — never more than 2 min walk",
            "• **Family restrooms** with changing tables — every terminal",
            "• **Accessible/family** facilities clearly marked",
            "• **Nursing/feeding rooms** — ask at information desk",
            "• **Service animal relief areas** — located post-security in every terminal",
            "",
            "**Before security:** Restrooms available at arrivals level & departures level",
            "**After security:** Near central concourse in each terminal",
        ]),
        (["shop", "store", "duty.*free", "buy", "gift", "souvenir", "shopping"], [
            "🛍️ **Shopping at JFK:**",
            "",
            "**Duty Free Americas** — All terminals (cosmetics, liquor, fragrances, watches)",
            "**Fashion & Accessories:**",
            "• Coach, Michael Kors, Swarovski (Terminal 4)",
            "• Burberry, Tumi (Terminal 5)",
            "• MAC Cosmetics, Kiehl's (Terminal 4)",
            "",
            "**Tech & Travel:**",
            "• InMotion — Headphones, chargers, travel gadgets",
            "• Best Buy Express — Electronics & accessories",
            "",
            "**NYC Souvenirs:**",
            "• New York Minute — T-shirts, hats, gifts (all terminals)",
            "",
            "🕐 Most shops open 5 AM – 11 PM",
            "",
            "Looking for something specific?",
        ]),
        (["transportation", "airtrain", "subway", "taxi", "uber", "lyft", "train", "bus", "rental", "parking", "drive", "manhattan", "brooklyn", "lirr"], [
            "🚇 **Getting to/from JFK — Complete guide:**",
            "",
            "**AirTrain JFK ($7.75):** Connects all terminals ↔ Jamaica/Howard Beach",
            "  → **Subway:** E, J, Z lines from Jamaica Station",
            "  → **LIRR to Manhattan:** Jamaica → Penn Station (35 min, $7.75–$10.75)",
            "",
            "**Taxi:** Flat rate ~$52 to Manhattan (not incl. tolls + tip)",
            "**Uber/Lyft:** Follow signs to rideshare pickup — ~$40–$65 to Manhattan",
            "",
            "**Express Bus:** NYC Airporter ($19) — Grand Central, Port Authority, Times Sq",
            "**Rental Cars:** Enterprise, Hertz, Avis — free shuttle from each terminal",
            "",
            "💡 **Fastest to Manhattan:** LIRR from Jamaica (35 min)",
            "💡 **Cheapest:** Subway E train ($2.90)",
        ]),
        (["lost", "baggage", "luggage", "bag", "suitcase", "claim", "missing", "left"], [
            "🧳 **Lost & Found / Baggage Help:**",
            "",
            "**Checked baggage delayed/lost?**",
            "1. Go to your **airline's baggage service office** near baggage claim",
            "2. Keep your **baggage claim tag** — you'll need it",
            "3. File a report — get a reference number",
            "4. Track status via your airline's mobile app",
            "5. **Emergency essentials** provided for 6+ hour delays (toiletries, etc.)",
            "",
            "**Lost personal items in the terminal?**",
            "• Visit the airport **Lost & Found** (Terminal 4, near baggage claim)",
            "• Use the **Lost & Found feature** in this app!",
            "",
            "Which airline are you flying with? I can give you exact office locations!",
        ]),
        (["currency", "exchange", "money", "cash", "atm", "dollar", "euro", "convert"], [
            "💱 **Currency & Banking at JFK:**",
            "",
            "**Currency Exchange:**",
            "• **Travelex** locations — Terminals 1, 4, 5, 8",
            "• Rates are slightly worse than local banks (convenience fee)",
            "",
            "**ATMs:** Available throughout all terminals (before & after security)",
            "**Credit Cards:** Accepted everywhere in terminals",
            "",
            "💡 **Pro tip:** You don't need much cash at the airport — most places take cards!",
            "💡 **Better rates:** Use an ATM at your destination rather than airport exchange",
        ]),
        (["medical", "pharmacy", "doctor", "hospital", "medicine", "sick", "pain", "injury", "first.?aid", "emergency", "ambulance"], [
            "🏥 **Medical & Emergency Services:**",
            "",
            "**First Aid Stations:**",
            "• Located in **every terminal** — look for the red cross signs",
            "",
            "**Pharmacy:**",
            "• Terminal 4 (near B20) — Open 7 AM – 9 PM",
            "",
            "**In an emergency:**",
            "• **Call 911** from any phone",
            "• AED (defibrillators) available throughout all terminals",
            "• Medical personnel on duty 24/7",
            "• Notify any airline or airport staff immediately",
            "",
            "Need directions to the nearest first aid station?",
        ]),
        (["flight", "status", "delay", "cancelled", "departure", "arrival", "depart", "land", "take.?off", "schedule", "on.?time"], [
            "✈️ **Flight Information at JFK:**",
            "",
            "Check your **flight status** in the Flights tab of this app for:",
            "• Real-time departure/arrival updates",
            "• Gate assignments (they can change!)",
            "• Delay/cancellation alerts",
            "• Boarding time & group",
            "",
            "**Common causes of delays at JFK:**",
            "• Weather (especially winter & summer storms)",
            "• Air traffic congestion (JFK is one of the busiest)",
            "• Late incoming aircraft",
            "",
            "**If your flight is cancelled:**",
            "• Go to your airline's counter immediately",
            "• Ask about rebooking on the next available flight",
            "• Check if they offer hotel/meal vouchers",
            "",
            "Which flight number are you tracking? I can help you find info!",
        ]),
    ]

    best_score = 0
    best_response = None
    for keywords, response_lines in intents:
        score = 0
        for kw in keywords:
            if kw.startswith("~"):
                pat = kw[1:]
                if re.search(pat, lower):
                    score += 4
            else:
                if kw in lower:
                    score += 3
                elif any(kw in w for w in lower.split()):
                    score += 1
        if score > best_score:
            best_score = score
            best_response = "\n".join(response_lines)

    if best_score > 2:
        return best_response

    topics = {
        "gate": "gate directions",
        "terminal": "terminal info",
        "flight": "flight status",
        "security": "security info",
        "food": "dining options",
        "wifi": "WiFi info",
        "lounge": "lounge access",
        "shop": "shopping",
        "baggage": "baggage help",
        "transport": "ground transport",
        "help": "assistance",
        "time": "flight times",
        "delay": "flight delays",
    }
    suggestions = []
    for kw, label in topics.items():
        if kw in lower:
            suggestions.append(f"• {label}")
    if not suggestions:
        suggestions = [
            "• Gate locations and directions",
            "• Dining and shopping options",
            "• Ground transportation (AirTrain, taxi, Uber)",
            "• Security and check-in info",
            "• Lounge access",
        ]

    return (
        f"Hey! I'm here to help with anything at JFK Airport. "
        f"Try asking me about:\n\n"
        + "\n".join(suggestions)
        + "\n\nWhat would you like to know?"
    )


class ChatView(APIView):
    permission_classes = (AllowAny,)

    def post(self, request):
        serializer = ChatSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        message = serializer.validated_data['message']
        history = serializer.validated_data.get('history', [])

        try:
            if GEMINI_API_KEY:
                prompt = _build_prompt(message, history)
                result = _call_gemini(prompt)
                if result:
                    return Response({"response": result})

            response = _local_response(message)
            return Response({"response": response})
        except Exception:
            return Response({"response": _local_response(message)})


class SuggestionsView(APIView):
    permission_classes = (AllowAny,)

    def get(self, request):
        suggestions = [
            {"id": "sug_01", "text": "How do I find my gate?", "icon": "navigation"},
            {"id": "sug_02", "text": "What restaurants are near my gate?", "icon": "restaurant"},
            {"id": "sug_03", "text": "Where is the lounge?", "icon": "lounge"},
            {"id": "sug_04", "text": "How do I get to Manhattan?", "icon": "train"},
            {"id": "sug_05", "text": "What's the WiFi password?", "icon": "wifi"},
            {"id": "sug_06", "text": "TSA wait times?", "icon": "security"},
            {"id": "sug_07", "text": "Where can I charge my phone?", "icon": "battery"},
            {"id": "sug_08", "text": "Lost baggage help", "icon": "luggage"},
            {"id": "sug_09", "text": "Currency exchange locations", "icon": "currency"},
            {"id": "sug_10", "text": "Medical assistance", "icon": "medical"},
        ]
        return Response(suggestions)
