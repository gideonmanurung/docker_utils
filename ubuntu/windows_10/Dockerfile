FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev

COPY ./requirements.txt ./requirements.txt
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt

WORKDIR /app
#COPY ./requirements.txt ./requirements.txt
# Various Python and C/build dependencies

COPY . /app

ENV PORT 8080
ENV DEBUG=True
ENV FLASK_ENV=development
#CMD ["python"]

# Store notebooks in this mounted directory
WORKDIR "/root"
CMD ["python"]

