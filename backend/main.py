import os, re, json
from datetime import datetime, timedelta, timezone
from typing import Optional

# Load .env file if present
_env_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.isfile(_env_path):
    with open(_env_path) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                k, v = line.split('=', 1)
                os.environ.setdefault(k.strip(), v.strip())

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="Cyclone API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─── Models ──────────────────────────────────────────────────────────────

class TranslateRequest(BaseModel):
    text: str
    source_language: str
    target_language: str

class ChatRequest(BaseModel):
    message: str
    history: list = []

class ChatMessage(BaseModel):
    role: str
    text: str

class FlightModel(BaseModel):
    id: str
    flightNumber: str
    airline: str
    airlineCode: str
    departureAirport: str
    departureCity: str
    arrivalAirport: str
    arrivalCity: str
    departureTime: datetime
    arrivalTime: datetime
    terminal: str
    gate: str
    seat: str
    status: str
    boardingGroup: Optional[str] = None
    boardingTime: Optional[datetime] = None
    aircraft: Optional[str] = None
    delayMinutes: Optional[int] = None
    baggageClaim: Optional[str] = None

# ─── Mock Flight Data ────────────────────────────────────────────────────

now = datetime.now(timezone.utc)

_mock_flights = [
    FlightModel(
        id="fl_001",
        flightNumber="CY 2847",
        airline="EgyptAir Airways",
        airlineCode="CY",
        departureAirport="JFK",
        departureCity="New York",
        arrivalAirport="LHR",
        arrivalCity="London",
        departureTime=now + timedelta(hours=3),
        arrivalTime=now + timedelta(hours=10),
        terminal="Terminal 4",
        gate="B22",
        seat="14A",
        status="boarding",
        boardingGroup="2",
        boardingTime=now + timedelta(minutes=45),
        aircraft="Boeing 787-9",
    ),
    FlightModel(
        id="fl_002",
        flightNumber="BA 178",
        airline="British Airways",
        airlineCode="BA",
        departureAirport="LHR",
        departureCity="London",
        arrivalAirport="JFK",
        arrivalCity="New York",
        departureTime=now + timedelta(days=7),
        arrivalTime=now + timedelta(days=7, hours=8),
        terminal="Terminal 5",
        gate="A12",
        seat="22C",
        status="scheduled",
        boardingGroup="3",
        boardingTime=now + timedelta(days=7, hours=-1),
        aircraft="Airbus A380",
    ),
    FlightModel(
        id="fl_003",
        flightNumber="EK 201",
        airline="Emirates",
        airlineCode="EK",
        departureAirport="DXB",
        departureCity="Dubai",
        arrivalAirport="JFK",
        arrivalCity="New York",
        departureTime=now - timedelta(days=14),
        arrivalTime=now - timedelta(days=14, hours=-14),
        terminal="Terminal 3",
        gate="C8",
        seat="8F",
        status="arrived",
        aircraft="Boeing 777-300ER",
        baggageClaim="Carousel 4",
    ),
]

# ─── Language mapping for deep-translator ─────────────────────────────────

_LANG_MAP = {
    "Arabic": "arabic",
    "English": "english",
    "French": "french",
    "German": "german",
    "Spanish": "spanish",
    "Italian": "italian",
    "Turkish": "turkish",
    "auto": "auto",
}

# ─── Routes ──────────────────────────────────────────────────────────────

@app.post("/api/translate/")
async def translate(req: TranslateRequest):
    source = req.source_language.lower()
    target = req.target_language.lower()

    src = _LANG_MAP.get(source, source)
    tgt = _LANG_MAP.get(target, target)

    if src == "auto":
        src = "auto"

    try:
        if src == "auto":
            from deep_translator import GoogleTranslator
            result = GoogleTranslator(source="auto", target=tgt).translate(req.text)
            detected = "English"
        else:
            from deep_translator import GoogleTranslator
            result = GoogleTranslator(source=src, target=tgt).translate(req.text)
            detected = None

        if result is None:
            result = req.text

        return {"translated_text": result, "detected_language": detected}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/flights")
async def list_flights(status: Optional[str] = Query(None)):
    if status == "upcoming":
        return [f for f in _mock_flights if f.status != "arrived"]
    elif status == "past":
        return [f for f in _mock_flights if f.status == "arrived"]
    return _mock_flights

@app.get("/api/flights/search")
async def search_flights(q: str = Query("")):
    if not q:
        return [f for f in _mock_flights if f.status != "arrived"]
    lower = q.lower()
    results = [
        f for f in _mock_flights
        if lower in f.flightNumber.lower()
        or lower in f.departureCity.lower()
        or lower in f.arrivalCity.lower()
        or lower in f.airline.lower()
    ]
    return results

@app.get("/api/flights/{flight_id}")
async def get_flight(flight_id: str):
    for f in _mock_flights:
        if f.id == flight_id:
            return f
    raise HTTPException(status_code=404, detail="Flight not found")

# ─── AI Assistant ─────────────────────────────────────────────────────────

_GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
_GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

_SYSTEM_PROMPT = """You are a helpful airport assistant for Cyclone, an airport travel companion app.
Answer questions about airport services, gates, dining, lounges, transportation, shopping, and travel tips.
Keep answers friendly, concise, and practical.
The airport is JFK (John F. Kennedy International Airport) unless the user specifies otherwise."""

def _build_prompt(message: str, history: list[dict]) -> str:
    prompt = _SYSTEM_PROMPT + "\n\n"
    for h in history[-6:]:
        role = h.get("role", "user")
        text = h.get("text", "")
        prompt += f"{'User' if role == 'user' else 'Assistant'}: {text}\n"
    prompt += f"User: {message}\nAssistant:"
    return prompt

def _call_gemini(prompt: str) -> str | None:
    try:
        import requests
        resp = requests.post(
            f"{_GEMINI_URL}?key={_GEMINI_API_KEY}",
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

def _local_response(message: str) -> str:
    lower = message.lower().strip()

    intent_scores = {}
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

    # Suggest topics
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
        + "\n".join(suggestions) +
        "\n\nWhat would you like to know?"
    )

@app.post("/api/assistant/chat")
async def assistant_chat(req: ChatRequest):
    try:
        if _GEMINI_API_KEY:
            prompt = _build_prompt(req.message, req.history)
            result = _call_gemini(prompt)
            if result:
                return {"response": result}

        response = _local_response(req.message)
        return {"response": response}
    except Exception as e:
        return {"response": _local_response(req.message)}

@app.get("/api/health")
async def health():
    return {"status": "ok", "timestamp": datetime.now(timezone.utc).isoformat()}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
