FROM ubuntu:14.04
MAINTAINER Eric Rasche <esr@tamu.edu>

ENV DEBIAN_FRONTEND=noninteractive \
    DEBUG=false \
    GALAXY_WEB_PORT=10000 \
    NOTEBOOK_PASSWORD=none \
    CORS_ORIGIN=none \
    DOCKER_PORT=none \
    API_KEY=none \
    HISTORY_ID=none \
    REMOTE_HOST=none \
    GALAXY_URL=none

# Ensure cran is available
RUN apt-get -qq update && \
    apt-get install --no-install-recommends -y \
        wget procps nginx python python-pip net-tools nginx git

ADD ./startup.sh /startup.sh
ADD ./monitor_traffic.sh /monitor_traffic.sh

RUN mkdir -p /import /web/helloworld

COPY ./proxy.conf /proxy.conf
COPY ./index.html /web/helloworld/

VOLUME ["/import"]
WORKDIR /import/

RUN git clone https://github.com/lifenglifeng001/flask-hello /app && \
    cd /app && \
    pip install -r requirements.txt

EXPOSE 80
CMD /startup.sh
