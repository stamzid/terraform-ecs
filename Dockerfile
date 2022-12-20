FROM python:3.10-slim

WORKDIR /
COPY services/ /

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install gcc -y \
 && apt-get clean \
 && mkdir -p /data \
 && pip install poetry \
 && poetry export -f requirements.txt --output requirements.txt \
 && pip install -r requirements.txt

EXPOSE 8080

ENTRYPOINT ["uvicorn", "web_app.app:app", "--host", "0.0.0.0", "--port", "8080", "--timeout-keep-alive", "0"]
