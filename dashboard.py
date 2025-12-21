import time
import requests
import os
import json

# CONFIGURATION
SERVICE_URL = "https://gemini-app-1057191446230.europe-west3.run.app"
TEST_PROMPT = "Explain quantum entanglement in 5 words."

def generate_dashboard():
    print("\n" + "="*60)
    print(f"   GEMINI APP LIVE DASHBOARD   ")
    print("="*60)

    # 1. Configuration Table
    print(f"\n[ SYSTEM CONFIGURATION ]")
    print(f"{'Parameter':<20} | {'Value'}")
    print("-" * 50)
    print(f"{'Service URL':<20} | {SERVICE_URL}")
    print(f"{'Region':<20} | europe-west3 (Frankfurt)")
    print(f"{'Model Target':<20} | gemini-3-pro-preview")
    print("-" * 50)

    # 2. Performance Test
    print(f"\n[ PERFORMANCE TEST ]")
    print(f"Sending probe: '{TEST_PROMPT}'...")
    
    start_time = time.time()
    try:
        response = requests.post(
            SERVICE_URL, 
            json={"message": TEST_PROMPT},
            timeout=30
        )
        end_time = time.time()
        latency = round((end_time - start_time), 2)
        
        status_icon = "✅ ONLINE" if response.status_code == 200 else f"❌ ERROR {response.status_code}"
        
        # Parse Response
        try:
            data = response.json()
            ai_reply = data.get("response", "No response text")
            # Truncate for table
            if len(ai_reply) > 50: ai_reply = ai_reply[:47] + "..."
        except:
            ai_reply = "Invalid JSON"

        # 3. Results Table
        print(f"\n{'Metric':<20} | {'Result'}")
        print("-" * 50)
        print(f"{'Status':<20} | {status_icon}")
        print(f"{'Latency':<20} | {latency} seconds")
        print(f"{'Response Payload':<20} | {ai_reply}")
        print("-" * 50)
        
    except Exception as e:
        print(f"\n❌ CONNECTION FAILED: {e}")

    print("\n" + "="*60 + "\n")

if __name__ == "__main__":
    generate_dashboard()
