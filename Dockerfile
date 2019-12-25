# -*- coding: utf-8 -*-
# File  : Dockerfile
# Date  : 18.09.2019
# Author: Austin Schaffer <schaffer.austin.t@gmail.com>

FROM python:3-slim


WORKDIR /app

RUN apt-get update
RUN apt-get -y install build-essential libffi-dev

COPY requirements.txt .
RUN pip install -r requirements.txt

ENV FLASK_APP=shhh
COPY shhh shhh

EXPOSE 5000
CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000" ]
