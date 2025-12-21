import google.generativeai as genai
import os

key = os.environ.get('GEMINI_API_KEY')
if not key:
    print("Error: GEMINI_API_KEY is not set.")
    exit(1)

genai.configure(api_key=key)

print(f"\n{'MODEL NAME':<30} | {'STATUS'}")
print("-" * 50)

try:
    found = False
    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            print(f"{m.name:<30} | OK")
            found = True
    if not found:
        print("No chat models found. Your API key might be invalid or restricted.")
except Exception as e:
    print(f"Connection Error: {e}")
print("-" * 50 + "\n")
