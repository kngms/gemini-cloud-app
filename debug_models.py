import os
import google.generativeai as genai

# Usage: export GEMINI_API_KEY="your_key" && python3 debug_models.py

api_key = os.environ.get("GEMINI_API_KEY")
if not api_key:
    print("Error: Please set GEMINI_API_KEY environment variable.")
    exit(1)

genai.configure(api_key=api_key)

print(f"{'Model Name':<30} | {'Supported Methods'}")
print("-" * 60)

try:
    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            print(f"{m.name:<30} | generateContent (Chat/Text)")
except Exception as e:
    print(f"Error listing models: {e}")
