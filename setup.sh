#!/bin/bash

# Gemini Cloud App - Setup Script
# This script helps you set up the application locally

set -e

echo "======================================"
echo "  Gemini Cloud App - Setup"
echo "======================================"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi
echo ""

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate
echo ""

# Install dependencies
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
echo "✅ Dependencies installed"
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env and add your GEMINI_API_KEY"
    echo "   Get your API key from: https://makersuite.google.com/app/apikey"
    echo ""
else
    echo "✅ .env file already exists"
    echo ""
fi

# Check if GEMINI_API_KEY is set
if [ -f ".env" ]; then
    source .env
    if [ -z "$GEMINI_API_KEY" ] || [ "$GEMINI_API_KEY" = "your_api_key_here" ]; then
        echo "⚠️  WARNING: GEMINI_API_KEY is not set or is using the default value"
        echo "   Please edit .env and add your API key before running the app"
        echo ""
    else
        echo "✅ GEMINI_API_KEY is configured"
        echo ""
    fi
fi

echo "======================================"
echo "  Setup Complete! 🎉"
echo "======================================"
echo ""
echo "To run the application:"
echo "  1. Activate the virtual environment: source venv/bin/activate"
echo "  2. Make sure your .env file has a valid GEMINI_API_KEY"
echo "  3. Run: python3 main.py"
echo "  4. Open: http://localhost:8080"
echo ""
echo "Or use Docker:"
echo "  1. Make sure your .env file has a valid GEMINI_API_KEY"
echo "  2. Run: docker-compose up --build"
echo "  3. Open: http://localhost:8080"
echo ""
