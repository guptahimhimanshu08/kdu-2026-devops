import json
import os
import time
import boto3
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["TABLE_NAME"])

def handler(event, context):
    # Handle CORS preflight
    if event.get("httpMethod") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST,OPTIONS"
            },
            "body": ""
        }

    try:
        body = json.loads(event.get("body", "{}"))

        message = body.get("message")
        if not message:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "*"
                },
                "body": json.dumps({"error": "Message is required"})
            }

        item = {
            "messageId": str(int(time.time() * 1000)),
            "message": message,
            "createdAt": datetime.utcnow().isoformat()
        }

        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST,OPTIONS"
            },
            "body": json.dumps({"success": True})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": str(e)})
        }