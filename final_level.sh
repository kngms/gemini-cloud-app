cat <<EOF > main.py
import os
import logging
from flask import Flask, request, jsonify, render_template_string
from google import genai
from google.genai import types

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

# 1. Initialize Gemini Client
API_KEY = os.environ.get("GEMINI_API_KEY")
client = genai.Client(api_key=API_KEY) if API_KEY else None
MODEL_ID = os.environ.get("MODEL_ID", "gemini-2.0-flash")

# 2. Professional UI Template (Glassmorphism + Modern Dark Mode)
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
        body { margin: 0; font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; height: 100vh; }
        
        /* Sidebar */
        #sidebar { width: 260px; background: var(--panel); border-right: 1px solid var(--border); display: flex; flex-direction: column; padding: 20px; }
        .logo { font-size: 20px; font-weight: 600; color: white; margin-bottom: 30px; display: flex; align-items: center; gap: 10px; }
        .logo-dot { width: 12px; height: 12px; background: var(--accent); border-radius: 50%; box-shadow: 0 0 10px var(--accent); }
        .nav-item { padding: 10px; border-radius: 6px; cursor: pointer; color: #8b949e; transition: 0.2s; margin-bottom: 5px; }
        .nav-item:hover { background: #21262d; color: white; }

        /* Main Chat */
        #main { flex: 1; display: flex; flex-direction: column; position: relative; }
        #chat-window { flex: 1; overflow-y: auto; padding: 40px 15% 100px 15%; scroll-behavior: smooth; }
        .message { margin-bottom: 30px; line-height: 1.6; animation: fadeIn 0.3s ease-out; }
        .message.user { color: white; font-weight: 500; border-left: 3px solid var(--accent); padding-left: 15px; }
        .message.bot { color: var(--text); }
        
        /* Markdown Styling */
        pre { background: #000; padding: 16px; border-radius: 8px; border: 1px solid var(--border); overflow-x: auto; }
        code { font-family: 'Fira Code', monospace; font-size: 14px; }
        
        /* Input Area */
        #input-container { position: absolute; bottom: 30px; left: 15%; right: 15%; background: var(--panel); border: 1px solid var(--border); border-radius: 12px; padding: 10px; display: flex; align-items: center; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        #userInput { flex: 1; background: transparent; border: none; color: white; padding: 12px; font-size: 16px; outline: none; }
        #sendBtn { background: var(--accent); color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.2s; }
        #sendBtn:hover { opacity: 0.8; transform: translateY(-1px); }
        #sendBtn:disabled { background: #484f58; cursor: not-allowed; }

        /* Loader */
        .typing { font-size: 13px; color: #8b949e; margin-bottom: 20px; display: none; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <div id="sidebar">
        <div class="logo"><div class="logo-dot"></div> App-Jette</div>
        <div class="nav-item">New Chat</div>
        <div class="nav-item">History</div>
        <div class="nav-item">Settings</div>
        <div style="margin-top: auto; font-size: 11px; color: #484f58;">Gemini 2.0 Flash Enabled</div>
    </div>
    
    <div id="main">
        <div id="chat-window">
            <div class="message bot">
                <h2>Welcome, Chris.</h2>
                <p>App-Jette is now connected to <strong>Google Search</strong> and <strong>Python Code Execution</strong>. What are we building today?</p>
            </div>
        </div>
        
        <div id="chat-window-footer" style="padding: 0 15%;">
            <div id="typingIndicator" class="typing">App-Jette is searching and thinking...</div>
        </div>

        <div id="input-container">
            <input type="text" id="userInput" placeholder="Ask anything or request a task..." autocomplete="off">
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

            // User UI
            userInput.value = '';
            sendBtn.disabled = true;
            typingIndicator.style.display = 'block';
            chatWindow.innerHTML += `<div class="message user">\${text}</div>`;
            chatWindow.scrollTop = chatWindow.scrollHeight;

            try {
                const response = await fetch('/', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: text })
                });
                const data = await response.json();
                
                // Bot UI
                typingIndicator.style.display = 'none';
                const botMsgDiv = document.createElement('div');
                botMsgDiv.className = 'message bot';
                botMsgDiv.innerHTML = marked.parse(data.response);
                chatWindow.appendChild(botMsgDiv);
                
                document.querySelectorAll('pre code').forEach(hljs.highlightBlock);
            } catch (err) {
                typingIndicator.style.display = 'none';
                chatWindow.innerHTML += `<div class="message bot" style="color: #f85149;">Connection Error. Check Cloud Run Logs.</div>`;
            }

            sendBtn.disabled = false;
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }

        sendBtn.addEventListener('click', handleSend);
        userInput.addEventListener('keypress', (e) => { if (e.key === 'Enter') handleSend(); });
    </script>
</body>
</html>
"""

@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        if not client: return jsonify({"error": "Config Missing"}), 500
        data = request.get_json(silent=True)
        msg = data.get('message', '')

        try:
            # INTEGRATING SEARCH AND CODE TOOLS
            response = client.models.generate_content(
                model=MODEL_ID,
                contents=msg,
                config=types.GenerateContentConfig(
                    tools=[
                        types.Tool(google_search=types.GoogleSearchRetrieval()),
                        types.Tool(code_execution={})
                    ],
                    system_instruction="You are App-Jette AI. Be professional, efficient, and use your tools (Search/Code) automatically when needed."
                )
            )
            return jsonify({"response": response.text})
        except Exception as e:
            return jsonify({"response": f"Backend Error: {str(e)}"}), 500

    return render_template_string(HTML_UI)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
EOF
