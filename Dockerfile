FROM --platform=$BUILDPLATFORM debian:bookworm-slim as download

ARG TARGETPLATFORM
ENV DEBIAN_FRONTEND=noninteractive
# renovate: datasource=github-releases depName=arp242/goatcounter
ARG GOATCOUNTER_VERSION=v2.5.0

RUN arch=$(echo "$TARGETPLATFORM" | sed -E 's/(linux)\/(arm|amd)64.*/\1-\264/') &&\
  apt update &&\
  apt install -y wget &&\
  wget "https://github.com/arp242/goatcounter/releases/download/$GOATCOUNTER_VERSION/goatcounter-$GOATCOUNTER_VERSION-$arch.gz" &&\
  gzip -d "goatcounter-$GOATCOUNTER_VERSION-$arch.gz" &&\
  mv "goatcounter-$GOATCOUNTER_VERSION-$arch" /goatcounter

FROM --platform=$BUILDPLATFORM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV GOATCOUNTER_LISTEN='0.0.0.0:8080'
ENV GOATCOUNTER_DB='sqlite+/goatcounter/db/goatcounter.sqlite3'
ENV GOATCOUNTER_SMTP=''
ENV TZ='Etc/UTC'

WORKDIR /goatcounter

RUN apt update &&\
  apt install -y ca-certificates curl &&\
  update-ca-certificates --fresh &&\
  rm -rf /var/lib/apt/lists/* /var/cache/*

COPY --from=download --chmod=0755 /goatcounter /usr/bin/goatcounter
COPY goatcounter.sh ./
COPY entrypoint.sh /

VOLUME ["/goatcounter/db"]
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD curl -f -H "Host: $GOATCOUNTER_DOMAIN" http://localhost:8080 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/goatcounter/goatcounter.sh"]
