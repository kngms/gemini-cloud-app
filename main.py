import os
import logging
from flask import Flask, request, jsonify
import google.generativeai as genai

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

API_KEY = os.environ.get("GEMINI_API_KEY")
if not API_KEY:
    logging.error("GEMINI_API_KEY not set!")
else:
    genai.configure(api_key=API_KEY)

def get_gemini_response(prompt_input):
    try:
        # SPECIFICALLY REQUESTING GEMINI 3.0
        target_model = 'gemini-3-pro-preview'
        
        logging.info(f"Requesting model: {target_model}")
        model = genai.GenerativeModel(target_model)
        response = model.generate_content(prompt_input)
        return response.text
    except Exception as e:
        logging.error(f"Error: {e}")
        return f"Error: {str(e)}"

@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        data = request.get_json(silent=True) or request.form
        user_input = data.get('message', '')
        if not user_input:
            return jsonify({"error": "No message provided"}), 400
        
        ai_response = get_gemini_response(user_input)
        return jsonify({"response": ai_response})
    
    return "Gemini 3.0 App is Live! Send a POST request."

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
