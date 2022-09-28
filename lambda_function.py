# ------------------------------------------------------------------------------
# Lambda Function for API Gateway Serverless Integration
#
# Version  Date              Name            Info
# 1.0      30-August-2022    Denis Astahov   Initial Version
#
# ------------------------------------------------------------------------------
import boto3
import os
import datetime

OWNER_NAME  = os.environ['OWNER_NAME']


def lambda_handler(event, context):
    try:
        message = {
            "owner"   : OWNER_NAME,
            "message" : "This is AWS APIGateway + AWS Lambda",
            "runtime" : str(datetime.datetime.now())
            }

    except Exception as error:
        print("Error occuried! Error Message: " + str(error))

    return message
