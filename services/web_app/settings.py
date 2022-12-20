#!/usr/bin/env python3

import os


AWS_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY')
AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
REGION = 'us-east-1'
BUCKET = "unstructured-poc"
DB_FILE = "/data/app-db.sqlite3"
FILE_KEY = "app-db.sqlite3"
