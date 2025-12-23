# Gemini 3.0 Cloud App

This is a Python Flask application powered by **Gemini 2.0 Flash** with Google Search and Code Execution capabilities. The app can be deployed locally, in Docker, on GitHub Codespaces, or on Google Cloud Run.

## Features
- **Frontend:** Dark-mode chat interface (HTML/JS) with markdown support
- **Backend:** Flask (Python) + Gunicorn
- **AI Model:** Gemini 2.0 Flash via Google GenAI SDK
- **Tools:** Google Search & Code Execution enabled
- **Deployment:** Local, Docker, Codespaces, or Google Cloud Run

## Prerequisites
- Python 3.8 or higher
- Google Gemini API Key ([Get one here](https://makersuite.google.com/app/apikey))
- Docker (optional, for containerized deployment)

## Quick Start

### Method 1: Automated Setup (Recommended)
```bash
# Clone the repository
git clone https://github.com/kngms/gemini-cloud-app.git
cd gemini-cloud-app

# Run setup script
chmod +x setup.sh
./setup.sh

# Edit .env file and add your GEMINI_API_KEY
nano .env

# Run the application
source venv/bin/activate
python3 main.py
```

Open your browser to [http://localhost:8080](http://localhost:8080)

### Method 2: Manual Setup
1. **Clone and install dependencies:**
   ```bash
   git clone https://github.com/kngms/gemini-cloud-app.git
   cd gemini-cloud-app
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

2. **Configure environment:**
   ```bash
   cp .env.example .env
   # Edit .env and add your GEMINI_API_KEY
   ```

3. **Run the application:**
   ```bash
   python3 main.py
   ```

4. **Access the app:**
   Open [http://localhost:8080](http://localhost:8080)

### Method 3: Docker
```bash
# Clone the repository
git clone https://github.com/kngms/gemini-cloud-app.git
cd gemini-cloud-app

# Create .env file with your API key
cp .env.example .env
# Edit .env and add your GEMINI_API_KEY

# Build and run with Docker Compose
docker-compose up --build

# Or build and run with Docker directly
docker build -t gemini-app .
docker run -p 8080:8080 --env-file .env gemini-app
```

Open your browser to [http://localhost:8080](http://localhost:8080)

### Method 4: GitHub Codespaces

1. **Open in Codespaces:**
   - Click the green "Code" button on GitHub
   - Select "Codespaces" tab
   - Click "Create codespace on main"

2. **Set up API key:**
   ```bash
   cp .env.example .env
   # Edit .env and add your GEMINI_API_KEY
   ```

3. **Run the application:**
   ```bash
   python3 main.py
   ```

4. **Access the app:**
   - Codespaces will automatically forward port 8080
   - Click on the "Ports" tab and open the forwarded URL
   - Or click the notification popup to open the app

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `GEMINI_API_KEY` | Yes | - | Your Google Gemini API key |
| `MODEL_ID` | No | `gemini-2.0-flash` | Model to use |
| `PORT` | No | `8080` | Port to run the server on |

## Deployment to Google Cloud Run

```bash
# Deploy directly from source
gcloud run deploy gemini-app \
  --source . \
  --region europe-west3 \
  --allow-unauthenticated \
  --set-env-vars GEMINI_API_KEY=your_api_key_here

# Or deploy from a Docker image
docker build -t gcr.io/YOUR_PROJECT_ID/gemini-app .
docker push gcr.io/YOUR_PROJECT_ID/gemini-app
gcloud run deploy gemini-app \
  --image gcr.io/YOUR_PROJECT_ID/gemini-app \
  --region europe-west3 \
  --allow-unauthenticated \
  --set-env-vars GEMINI_API_KEY=your_api_key_here
```

## Troubleshooting

### API Key Issues
- Make sure your `GEMINI_API_KEY` is valid and not expired
- Get a new key from [Google AI Studio](https://makersuite.google.com/app/apikey)
- Ensure the `.env` file is in the project root directory

### Port Already in Use
```bash
# Change the port in .env file
PORT=8081

# Or set it directly when running
PORT=8081 python3 main.py
```

### Docker Issues
```bash
# Clean up and rebuild
docker-compose down
docker-compose up --build
```

## Development

The application structure:
- `main.py` - Flask application and UI
- `requirements.txt` - Python dependencies
- `Dockerfile` - Docker configuration
- `docker-compose.yml` - Docker Compose configuration
- `.devcontainer/` - GitHub Codespaces configuration
- `setup.sh` - Automated setup script

## License

MIT
