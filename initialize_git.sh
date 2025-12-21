cd ~/gcloud/gemini-app

# 1. Initialize Git
git init -b main

# 2. Create a .gitignore (Crucial: prevents uploading your secrets!)
cat <<EOF > .gitignore
venv/
__pycache__/
*.pyc
.env
.DS_Store
EOF

# 3. Add your files
git add .

# 4. Commit (Save) the current state
git commit -m "Initial commit: Gemini 3.0 App on Cloud Run"

echo "✅ Git repository initialized and code saved locally."
