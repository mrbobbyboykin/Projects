import json
import logging
import os

import azure.functions as func
from azure.data.tables import TableClient, UpdateMode
from azure.core.exceptions import ResourceNotFoundError

PARTITION_KEY = "site"
ROW_KEY = "counter"
TABLE_NAME = os.environ.get("VISITS_TABLE_NAME", "visits")


def main(req: func.HttpRequest) -> func.HttpResponse:
    connection = os.environ["AzureWebJobsStorage"]
    table = TableClient.from_connection_string(connection, table_name=TABLE_NAME)

    try:
        table.create_table()
    except Exception:
        pass

    visits = 1
    try:
        entity = table.get_entity(partition_key=PARTITION_KEY, row_key=ROW_KEY)
        visits = int(entity.get("visits", 0)) + 1
    except ResourceNotFoundError:
        visits = 1
    except Exception as exc:
        logging.exception("Failed reading counter: %s", exc)
        return func.HttpResponse(
            json.dumps({"error": "counter_read_failed"}),
            status_code=500,
            mimetype="application/json",
        )

    table.upsert_entity(
        {
            "PartitionKey": PARTITION_KEY,
            "RowKey": ROW_KEY,
            "visits": visits,
        },
        mode=UpdateMode.REPLACE,
    )

    return func.HttpResponse(
        json.dumps({"visits": visits}),
        status_code=200,
        mimetype="application/json",
        headers={"Cache-Control": "no-store"},
    )
