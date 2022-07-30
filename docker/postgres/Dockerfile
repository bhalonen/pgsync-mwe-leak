ARG IMAGE
FROM ${IMAGE}


VOLUME /init/migrations

RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.orig.sh 

COPY docker-entrypoint.sh /usr/local/bin/