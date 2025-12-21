cd ~/gcloud/gemini-app

# 1. Create a README.md (Documentation)
cat <<EOF > README.md
# Gemini 3.0 Cloud App

This is a Python Flask application deployed on **Google Cloud Run**, powered by **Gemini 3.0 Pro Preview**.

## Features
- **Frontend:** Dark-mode chat interface (HTML/JS).
- **Backend:** Flask (Python) + Gunicorn.
- **AI Model:** Gemini 3.0 Pro Preview via Google GenAI SDK.
- **Infrastructure:** Google Cloud Run (Serverless).

## Setup (Local)
1. Install dependencies:
   \`\`\`bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   \`\`\`
2. Set API Key:
   \`\`\`bash
   export GEMINI_API_KEY="your_key_here"
   \`\`\`
3. Run:
   \`\`\`bash
   python3 main.py
   \`\`\`

## Deployment
Deployed to Google Cloud Run via CLI:
\`\`\`bash
gcloud run deploy gemini-app --source .
\`\`\`
EOF

# 2. Add the README to Git
git add README.md
git commit -m "Add project documentation"

# 3. Create Repo on GitHub & Push (Using your 'gh' auth)
# This creates a public repo named 'gemini-cloud-app' and pushes your code.
echo "Creating GitHub repository..."
gh repo create gemini-cloud-app --public --source=. --remote=origin --push

echo ""
echo "✅ SUCCESS! Your code is now live on GitHub."
echo "View it here: https://github.com/kngms/gemini-cloud-app"
