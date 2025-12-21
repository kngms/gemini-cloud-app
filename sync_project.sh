#!/bin/bash
set -e

echo "--- Resetting App-Jette Project Files ---"

# 1. Create requirements.txt
cat <<'INNER' > requirements.txt
flask
gunicorn
google-genai
INNER

# 2. Create the professional main.py
cat <<'INNER' > main.py
import os
import logging
from flask import Flask, request, jsonify, render_template_string
from google import genai
from google.genai import types

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

API_KEY = os.environ.get("GEMINI_API_KEY")
client = genai.Client(api_key=API_KEY) if API_KEY else None
MODEL_ID = os.environ.get("MODEL_ID", "gemini-2.0-flash")

HTML_UI = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>App-Jette AI Pro</title>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --bg: #0b0e14; --panel: #161b22; --accent: #2f81f7; --text: #c9d1d9; --border: #30363d; }
        * { box-sizing: border-box; }
        body { margin: 0; font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; height: 100vh; overflow: hidden; }
        #sidebar { width: 260px; background: var(--panel); border-right: 1px solid var(--border); display: flex; flex-direction: column; padding: 20px; }
        .logo { font-size: 20px; font-weight: 600; color: white; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .logo-dot { width: 12px; height: 12px; background: var(--accent); border-radius: 50%; box-shadow: 0 0 10px var(--accent); }
        .nav-item { padding: 10px; border-radius: 6px; cursor: pointer; color: #8b949e; transition: 0.2s; margin-bottom: 5px; }
        .nav-item:hover { background: #21262d; color: white; }
        #main { flex: 1; display: flex; flex-direction: column; position: relative; height: 100vh; }
        #chat-window { flex: 1; overflow-y: auto; padding: 40px 15% 120px 15%; scroll-behavior: smooth; }
        .message { margin-bottom: 30px; line-height: 1.6; }
        .message.user { color: white; font-weight: 500; border-left: 3px solid var(--accent); padding-left: 15px; }
        pre { background: #000; padding: 16px; border-radius: 8px; border: 1px solid var(--border); overflow-x: auto; }
        #input-container { position: absolute; bottom: 30px; left: 15%; right: 15%; background: var(--panel); border: 1px solid var(--border); border-radius: 12px; padding: 10px; display: flex; align-items: center; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        #userInput { flex: 1; background: transparent; border: none; color: white; padding: 12px; font-size: 16px; outline: none; }
        #sendBtn { background: var(--accent); color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 600; }
        .typing { font-size: 13px; color: #8b949e; margin-bottom: 10px; display: none; }
    </style>
</head>
<body>
    <div id="sidebar">
        <div class="logo"><div class="logo-dot"></div> App-Jette AI</div>
        <div class="nav-item">Active Chat</div>
        <div class="nav-item">GCP ID: 884818776055</div>
    </div>
    <div id="main">
        <div id="chat-window"><div class="message bot"><h2>System Reset Successful.</h2><p>Running Gemini 2.0 Flash with Search & Code Interpreter tools.</p></div></div>
        <div style="padding: 0 15%;"><div id="typingIndicator" class="typing">Thinking...</div></div>
        <div id="input-container">
            <input type="text" id="userInput" placeholder="Message App-Jette..." autocomplete="off">
            <button id="sendBtn">Send</button>
        </div>
    </div>
    <script>
        const chatWindow = document.getElementById('chat-window');
        const userInput = document.getElementById('userInput');
        const sendBtn = document.getElementById('sendBtn');
        const typingIndicator = document.getElementById('typingIndicator');
        marked.setOptions({ highlight: (code) => hljs.highlightAuto(code).value });
        async function handleSend() {
            const text = userInput.value.trim();
            if (!text) return;
            userInput.value = '';
            typingIndicator.style.display = 'block';
            chatWindow.innerHTML += `<div class="message user">${text}</div>`;
            chatWindow.scrollTop = chatWindow.scrollHeight;
            const res = await fetch('/', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({message: text}) });
            const data = await res.json();
            typingIndicator.style.display = 'none';
            const botDiv = document.createElement('div');
            botDiv.className = 'message bot';
            botDiv.innerHTML = marked.parse(data.response);
            chatWindow.appendChild(botDiv);
            document.querySelectorAll('pre code').forEach(hljs.highlightElement);
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }
        sendBtn.onclick = handleSend;
        userInput.onkeypress = (e) => { if(e.key === 'Enter') handleSend(); };
    </script>
</body>
</html>
"""

@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        data = request.get_json(silent=True)
        try:
            response = client.models.generate_content(
                model=MODEL_ID,
                contents=data.get('message', ''),
                config=types.GenerateContentConfig(
                    tools=[types.Tool(google_search=types.GoogleSearchRetrieval()), types.Tool(code_execution={})],
                    system_instruction="You are App-Jette AI. Use Search and Code tools automatically."
                )
            )
            return jsonify({"response": response.text})
        except Exception as e:
            return jsonify({"response": str(e)}), 500
    return render_template_string(HTML_UI)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
INNER

# 3. Create .gitignore
cat <<'INNER' > .gitignore
venv/
__pycache__/
*.pyc
.env
INNER

echo "--- Files Synced. Redeploying to Google Cloud ---"
gcloud run deploy gemini-app --source . --region europe-west3 --quiet

echo "--- Updating GitHub ---"
git add .
git commit -m "Complete project sync: Professional UI + Google GenAI SDK"
git push origin main

echo "--- DONE! Your app is live at the URL above ---"
