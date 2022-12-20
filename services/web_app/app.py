#!/usr/bin/env python3

import os
import sqlite3
from pathlib import Path
from fastapi import FastAPI
from starlette.requests import Request
from web_app.s3_utils import S3Utils
from web_app.logging_utils import logger
from datetime import datetime
import web_app.settings as Settings


app = FastAPI()
s3 = S3Utils()


def write_deploy_time(conn, cursor):
    isotime = datetime.utcnow().isoformat()
    logger.info(f"Current isotime {isotime}")
    cursor.execute("""INSERT INTO deploys (timestamps) VALUES (?);""", (isotime,))
    conn.commit()


@app.get("/", status_code=200, tags="sqlite")
async def get_items(request: Request):
    conn = sqlite3.connect(Settings.DB_FILE)
    cursor = conn.cursor()
    result = cursor.execute("SELECT timestamps from deploys").fetchall()
    if result:
        result = [row[0] for row in result]
        return {"deploy_times": result}

    return {}


@app.on_event("startup")
async def start_up():
    s3.create_bucket()
    if s3.check_s3_file():
        s3.download_s3_file()
        conn = sqlite3.connect(Settings.DB_FILE)
        cursor = conn.cursor()
        write_deploy_time(conn, cursor)
    else:
        if os.path.exists(Settings.DB_FILE):
            logger.info("Loading From DB File")
            conn = sqlite3.connect(Settings.DB_FILE)
            cursor = conn.cursor()
            write_deploy_time(conn, cursor)
        else:
            logger.info("Creating DB File")
            Path(Settings.DB_FILE).touch
            conn = sqlite3.connect(Settings.DB_FILE)
            cursor = conn.cursor()
            cursor.execute("CREATE TABLE deploys(timestamps TEXT)")
            conn.commit()
            logger.info("Table created")
            write_deploy_time(conn, cursor)

    conn.close()



@app.on_event("shutdown")
async def sigterm():
    logger.info("Uploading db file to s3")
    s3.upload_file()
