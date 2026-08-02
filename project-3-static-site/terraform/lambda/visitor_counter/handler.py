import json
import os

import boto3

TABLE_NAME = os.environ["TABLE_NAME"]
COUNTER_ID = os.environ.get("COUNTER_ID", "site")

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(TABLE_NAME)


def handler(event, context):
    response = table.update_item(
        Key={"id": COUNTER_ID},
        UpdateExpression="ADD visits :one",
        ExpressionAttributeValues={":one": 1},
        ReturnValues="UPDATED_NEW",
    )
    visits = int(response["Attributes"]["visits"])

    return {
        "statusCode": 200,
        "headers": {
            "content-type": "application/json",
            "cache-control": "no-store",
        },
        "body": json.dumps({"visits": visits}),
    }
