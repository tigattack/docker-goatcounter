#!/usr/bin/env bash

set -eu

if ! goatcounter db show sites -find "$GOATCOUNTER_DOMAIN" >/dev/null 2>&1; then
  echo "No database found; Creating database"
  goatcounter db create site \
    -createdb \
    -domain "$GOATCOUNTER_DOMAIN" \
    -user.email "$GOATCOUNTER_EMAIL" \
    -password "$GOATCOUNTER_PASSWORD" \
    -db "$GOATCOUNTER_DB"
fi

exec "$@"
