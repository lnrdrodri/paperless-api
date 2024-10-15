FROM ruby:3.3.0

RUN apt-get update \
  && apt-get install -y --no-install-recommends default-jdk postgresql-client poppler-utils 

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz --quiet \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip --quiet \
  && unzip ngrok-stable-linux-amd64.zip \ 
  && mv ./ngrok /usr/bin/ngrok

WORKDIR /usr/src/app
