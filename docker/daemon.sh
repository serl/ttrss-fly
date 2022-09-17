#!/usr/bin/env sh
_DB_REGEX='^postgres://\(.\+\):\(.\+\)@\(.\+\):\([0-9]\+\)/\(.\+\)$'

TTRSS_DB_USER="$(echo "$DATABASE_URL" | sed -n "s|$_DB_REGEX|\1|p")"
TTRSS_DB_PASS="$(echo "$DATABASE_URL" | sed -n "s|$_DB_REGEX|\2|p")"
TTRSS_DB_HOST="$(echo "$DATABASE_URL" | sed -n "s|$_DB_REGEX|\3|p")"
TTRSS_DB_PORT="$(echo "$DATABASE_URL" | sed -n "s|$_DB_REGEX|\4|p")"
TTRSS_DB_NAME="$(echo "$DATABASE_URL" | sed -n "s|$_DB_REGEX|\5|p")"
export TTRSS_DB_USER TTRSS_DB_PASS TTRSS_DB_NAME TTRSS_DB_HOST TTRSS_DB_PORT

if [ -z "$TTRSS_DB_USER$TTRSS_DB_PASS$TTRSS_DB_NAME$TTRSS_DB_HOST$TTRSS_DB_PORT" ]; then
    echo "DATABASE_URL missing or malformed"
    exit 1
fi

exec hivemind
