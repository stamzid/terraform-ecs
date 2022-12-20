#!/usr/bin/env python3

import os
import sys
import boto3
import signal

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import uvicorn
from web_app.app import app


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080, debug=True, log_level="info")
