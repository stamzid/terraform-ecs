#!/usr/bin/env python3

import sys
import logging


logger = logging.getLogger('uvicorn.info')
formatter = logging.Formatter('%(levelname)s: - %(asctime)s - %(message)s')
handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
handler.setFormatter(formatter)

logger.addHandler(handler)
