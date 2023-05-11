FROM debian:bullseye-slim as download

ARG GOATCOUNTER_VERSION

RUN apt update &&\
  apt install -y wget &&\
  wget "https://github.com/arp242/goatcounter/releases/download/$GOATCOUNTER_VERSION/goatcounter-$GOATCOUNTER_VERSION-linux-amd64.gz" &&\
  gzip -d "goatcounter-$GOATCOUNTER_VERSION-linux-amd64.gz" &&\
  mv "goatcounter-$GOATCOUNTER_VERSION-linux-amd64" /goatcounter

FROM debian:bullseye-slim

WORKDIR /goatcounter

RUN apt update &&\
  apt install -y ca-certificates &&\
  update-ca-certificates --fresh &&\
  rm -rf /var/lib/apt/lists/* /var/cache/*

ENV GOATCOUNTER_LISTEN '0.0.0.0:8080'
ENV GOATCOUNTER_DB 'sqlite:///goatcounter/db/goatcounter.sqlite3'
ENV GOATCOUNTER_SMTP ''

COPY --from=download --chmod=0755 /goatcounter /usr/bin/goatcounter
COPY goatcounter.sh ./
COPY entrypoint.sh /

VOLUME ["/goatcounter/db"]
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/goatcounter/goatcounter.sh"]
