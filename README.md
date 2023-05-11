# Goatcounter Docker

Unofficial Docker image for [goatcounter](https://github.com/arp242/goatcounter) - simple web statistics

## How to use this image

```bash
docker run --name goatcounter \
  -p 8080:8080 \
  -e GOATCOUNTER_DOMAIN=stats.domain.com \
  -e GOATCOUNTER_EMAIL=admin@domain.com \
  -v /opt/goatcounter:/goatcounter/db
  ghcr.io/tigattack/goatcounter
```

This command will start a single instance running on port 8080 with a site named `stats.domain.com` and map the database path to `/opt/goatcounter` on the host machine.

`GOATCOUNTER_DOMAIN` and `GOATCOUNTER_EMAIL` are mandatory.

## Environment Variables

### `GOATCOUNTER_DOMAIN`

This mandatory environment variable is used to create the initial site.

### `GOATCOUNTER_EMAIL`

This mandatory environment variable defines the e-mail address of the admin user.  

It's used to create the initial site and is passed as an `-auth` option to the `serve` command.

### `GOATCOUNTER_PASSWORD`

_Available since v1.4_.

This mandatory environment variable defines the password of the admin user.

### `GOATCOUNTER_SMTP`

This optional environment variable defines the SMTP server (e.g., `smtp://user:pass@server.com:587`) which will be used by the server. 

_Default:_ `stdout` - print email contents to stdout

### `GOATCOUNTER_DB`

This optional environment variable defines the location of the database. By default, the server will use SQLite database which is recommended solution. 

It's possible to use the Postgres DB however, the image was not tested against it.  

Don't change this value unless you know what you're doing.

_Default:_ `sqlite:///goatcounter/db/goatconter.sqlite3`

### `TZ`

This optional environment variables defines the timezone in the container.

Examples: `Europe/London`, `America/New_York`, etc.

_Default:_ `Etc/UTC`

## Troubleshooting

### The server displays migration info

During startup, the container will try to execute all available migrations. What you see, is the output of `goatcounter migrate` command.

### line X: GOATCOUNTER_*: unbound variable

You forgot to set one of the mandatory environment variables.

## Local build

`docker build -t goatcounter --build-arg GOATCOUNTER_VERSION=$(cat version) .`
