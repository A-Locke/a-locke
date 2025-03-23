import requests
import json

def lambda_handler(event, context):
    webhook_url = "https://<your-n8n-domain-or-ip>/webhook/my-lambda-trigger"
    payload = {
        "event": "lambda_called",
        "data": event
    }

    response = requests.post(webhook_url, json=payload)
    
    return {
        "statusCode": response.status_code,
        "body": json.dumps({"response": response.text})
    }
