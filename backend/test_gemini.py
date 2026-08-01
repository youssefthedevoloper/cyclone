import subprocess, time, json, urllib.request, sys, io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

p = subprocess.Popen(
    [sys.executable, '-m', 'uvicorn', 'main:app', '--host', '0.0.0.0', '--port', '8000'],
    cwd=r'F:\cyclone-apk\backend',
    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
)
time.sleep(6)

try:
    # Test 1: General question
    body = json.dumps({
        'message': 'What restaurants are near gate B22 in Terminal 4?',
        'history': [],
    }).encode('utf-8')
    req = urllib.request.Request(
        'http://localhost:8000/api/assistant/chat', data=body,
        headers={'Content-Type': 'application/json'}, method='POST',
    )
    resp = urllib.request.urlopen(req)
    data = json.loads(resp.read().decode('utf-8'))
    print('=== GEMINI RESPONSE ===')
    print(data['response'][:500])
    
    # Test 2: Conversation follow-up
    body2 = json.dumps({
        'message': 'How long does it take to walk there?',
        'history': [{'role': 'user', 'text': 'What restaurants are near gate B22 in Terminal 4?'},
                    {'role': 'assistant', 'text': data['response']}],
    }).encode('utf-8')
    req2 = urllib.request.Request(
        'http://localhost:8000/api/assistant/chat', data=body2,
        headers={'Content-Type': 'application/json'}, method='POST',
    )
    resp2 = urllib.request.urlopen(req2)
    data2 = json.loads(resp2.read().decode('utf-8'))
    print()
    print('=== FOLLOW-UP ===')
    print(data2['response'][:300])

except Exception as e:
    print('ERROR:', repr(e))
finally:
    p.kill()
    p.wait()
