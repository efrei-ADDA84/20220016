FROM python:3.9-slim-buster

WORKDIR /

RUN pip install requests

COPY . .

CMD [ "python", "./app.py" ]
