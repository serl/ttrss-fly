FROM cthulhoo/ttrss-fpm-pgsql-static:latest

ARG TARGETARCH
ARG HIVEMIND_VERSION=1.1.0

EXPOSE 80/tcp

RUN apk add --no-cache nginx

RUN --mount=from=cthulhoo/ttrss-web-nginx,source=/etc/nginx,target=/ttrss-web-nginx \
    sed 's/app:9000/localhost:9000/' /ttrss-web-nginx/nginx.conf > /etc/nginx/nginx.conf

RUN \
    cd /usr/local/bin && \
    wget -O hivemind.gz https://github.com/DarthSim/hivemind/releases/download/v${HIVEMIND_VERSION}/hivemind-v${HIVEMIND_VERSION}-linux-${TARGETARCH}.gz && \
    gunzip hivemind.gz && \
    chmod +x hivemind

COPY docker/* .

CMD ["sh", "daemon.sh"]
