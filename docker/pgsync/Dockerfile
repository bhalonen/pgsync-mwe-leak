ARG IMAGE
FROM ${IMAGE}

ARG PGSYNC_VERSION

RUN \
  apk add --no-cache postgresql13-client curl && \
  apk add --no-cache --virtual build-dependencies gcc musl-dev g++ && \
  pip install pgsync==${PGSYNC_VERSION} && \
  apk del build-dependencies && \
true

WORKDIR /pgsync

COPY docker-entrypoint.sh /usr/local/bin/
CMD ["/usr/local/bin/docker-entrypoint.sh"]
