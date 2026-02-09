FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl jq openjdk-21-jre-headless tzdata \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 -s /bin/bash minecraft

WORKDIR /srv/minecraft

COPY --chown=minecraft:minecraft ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# USER minecraft

EXPOSE 25519/tcp

VOLUME ["/srv/minecraft"]

ENTRYPOINT ["/usr/local/bin/start.sh"]
