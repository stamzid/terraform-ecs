#!/usr/bin/env python3

import io
import os
import sys
import boto3
import web_app.settings as Settings
from web_app.logging_utils import logger
from botocore.client import ClientError


class S3Utils:
    def __init__(self):
        self.s3_client = boto3.client(
            's3',
            aws_access_key_id=Settings.AWS_ACCESS_KEY,
            aws_secret_access_key=Settings.AWS_SECRET_KEY,
            region_name=Settings.REGION
        )
        self.s3_resource = boto3.resource(
            's3',
            aws_access_key_id=Settings.AWS_ACCESS_KEY,
            aws_secret_access_key=Settings.AWS_SECRET_KEY,
            region_name=Settings.REGION
        )

    def create_bucket(self):
        try:
            self.s3_client.head_bucket(Bucket=Settings.BUCKET)
        except ClientError:
            bucket = self.s3_client.create_bucket(Bucket=Settings.BUCKET)
        except Exception as e:
            logger.error(e)

    def check_s3_file(self):
        try:
            self.s3_client.head_object(Bucket=Settings.BUCKET, Key=Settings.FILE_KEY)
            return True
        except ClientError:
            return False

    def download_s3_file(self):
        if self.check_s3_file():
            self.s3_resource.Bucket(Settings.BUCKET).download_file(Settings.FILE_KEY, Settings.DB_FILE)
            logger.info("Downloaded File")
        else:
            logger.error("S3 File not found")

    def upload_file(self):
        try:
            self.s3_resource.Bucket(Settings.BUCKET).upload_file(Settings.DB_FILE, Settings.FILE_KEY)
            logger.info("Uploaded File")
        except ClientError as e:
            logger.error(e)
        except FileNotFoundError as f:
            logger.error(f)
