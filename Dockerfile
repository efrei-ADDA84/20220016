FROM python:3.9-slim-buster

WORKDIR /

RUN pip install requests
RUN pip install flask
COPY . .

CMD [ "python", "./app.py" ]
