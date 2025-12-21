# Gemini 3.0 Cloud App

This is a Python Flask application deployed on **Google Cloud Run**, powered by **Gemini 3.0 Pro Preview**.

## Features
- **Frontend:** Dark-mode chat interface (HTML/JS).
- **Backend:** Flask (Python) + Gunicorn.
- **AI Model:** Gemini 3.0 Pro Preview via Google GenAI SDK.
- **Infrastructure:** Google Cloud Run (Serverless).

## Setup (Local)
1. Install dependencies:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```
2. Set API Key:
   ```bash
   export GEMINI_API_KEY="your_key_here"
   ```
3. Run:
   ```bash
   python3 main.py
   ```

## Deployment
Deployed to Google Cloud Run via CLI:
```bash
gcloud run deploy gemini-app --source .
```
