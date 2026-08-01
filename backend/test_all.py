import subprocess, time, json, urllib.request, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

p = subprocess.Popen(
    [sys.executable, 'manage.py', 'runserver', '8000', '--noreload'],
    cwd=r'F:\cyclone-apk\backend',
    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
)
time.sleep(5)

base = 'http://localhost:8000'
results = []

def get(path):
    try:
        r = urllib.request.urlopen(f'{base}{path}', timeout=10)
        return json.loads(r.read().decode('utf-8'))
    except Exception as e:
        return f'ERROR: {e}'

def post(path, data):
    try:
        body = json.dumps(data).encode('utf-8')
        req = urllib.request.Request(f'{base}{path}', data=body, headers={'Content-Type': 'application/json'}, method='POST')
        r = urllib.request.urlopen(req, timeout=10)
        return json.loads(r.read().decode('utf-8'))
    except Exception as e:
        return f'ERROR: {e}'

print('=== TESTING DJANGO API ===')

# 1. Flights
flights = get('/api/flights/')
r = f'GET /api/flights/: {len(flights) if isinstance(flights, list) else "ERROR"} flights'
results.append(('✅' if isinstance(flights, list) else '❌') + ' ' + r)
print(r)

# 2. Assistant
assistant = post('/api/assistant/chat/', {'message': 'How do I find my gate?', 'history': []})
if isinstance(assistant, dict):
    r = f'POST /api/assistant/chat: {assistant.get("response", "ERROR")[:80]}...'
    results.append('✅ ' + r)
    print(r)
else:
    results.append('❌ POST /api/assistant/chat: ' + str(assistant))
    print(f'POST /api/assistant/chat: {assistant}')

# 3. Translator
trans = post('/api/translator/translate/', {'text': 'Hello, where is the gate?', 'source_language': 'auto', 'target_language': 'arabic'})
if isinstance(trans, dict):
    r = f'POST /api/translator/translate: {trans.get("translated_text", "ERROR")[:60]}'
    results.append('✅ ' + r)
    print(r)
else:
    results.append('❌ POST /api/translator/translate: ' + str(trans))
    print(f'POST /api/translator/translate: {trans}')

# 4. Maps
airport = get('/api/maps/airport/JFK/')
if isinstance(airport, dict):
    r = f'GET /api/maps/airport/JFK/: code={airport.get("code")}, terminals={len(airport.get("terminals", []))}'
    results.append('✅ ' + r)
    print(r)
else:
    results.append('❌ GET /api/maps/airport/JFK/: ' + str(airport))
    print(f'GET /api/maps/airport/JFK/: {airport}')

# 5. Emergency
emergency = get('/api/emergency/contacts/')
if isinstance(emergency, (list, dict)):
    count = len(emergency) if isinstance(emergency, list) else len(emergency.get('results', []))
    results.append(f'✅ GET /api/emergency/contacts/: {count} items')
    print(f'GET /api/emergency/contacts/: {count} items')
else:
    results.append('❌ GET /api/emergency/contacts/: ' + str(emergency))

# 6. Promotions
promos = get('/api/promotions/')
if isinstance(promos, (list, dict)):
    count = len(promos) if isinstance(promos, list) else len(promos.get('results', []))
    results.append(f'✅ GET /api/promotions/: {count} promotions')
    print(f'GET /api/promotions/: {count} promotions')
else:
    results.append('❌ GET /api/promotions/: ' + str(promos))

# 7. Rewards
achievements = get('/api/rewards/achievements/')
if isinstance(achievements, (list, dict)):
    count = len(achievements) if isinstance(achievements, list) else len(achievements.get('results', []))
    results.append(f'✅ GET /api/rewards/achievements/: {count} achievements')
    print(f'GET /api/rewards/achievements/: {count} achievements')
else:
    results.append('❌ GET /api/rewards/achievements/: ' + str(achievements))

# Summary
print('\n' + '='*50)
print('RESULTS SUMMARY')
print('='*50)
for r in results:
    print(r)

p.kill()
p.wait()
