cd ~/gcloud/gemini-app

# 1. Create the virtual environment (if not exists)
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# 2. Activate it
source venv/bin/activate

# 3. Install dependencies (Flask, Google AI, etc.)
echo "Installing libraries..."
pip install -r requirements.txt

# 4. NOW run the check script with your key
echo "---------------------------------------------------"
read -sp "Paste API Key one last time to check models: " KEY
export GEMINI_API_KEY="$KEY"
echo ""
python3 check_models.py
