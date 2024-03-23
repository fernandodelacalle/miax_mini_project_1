import datetime
from decimal import Decimal

import boto3

import api_handler


def download_data(
    ah: api_handler.BMEApiHandler,
    tck: str,
    fecha: datetime,
):
    s_data = ah.get_close_data(tck)
    s_data.to_csv(f"s3://mini-proyect-miax/{fecha}/{tck}.csv")

    # A dynamo
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('market_data_table')
    with table.batch_writer() as batch:
        for date, price in s_data.items():
            batch.put_item(
                Item={
                    "TCK": tck,
                    "DATE": date.strftime('%d-%m-%Y'),
                    "PRICE": Decimal(str(price)),
                }
            )


def handler(event, context):
    ah = api_handler.BMEApiHandler()
    fecha = datetime.datetime.now().strftime("%m_%d_%Y_%H_%M_%S")

    tcks = ["SAN", "TEF"]
    for tck in tcks:
        print(tck)
        download_data(ah, tck, fecha)
