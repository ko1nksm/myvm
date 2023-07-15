#!/bin/sh

set -eu

PREFIX="vm-"

find . -name "*.shrc" | sort -V | {
  while IFS= read -r file; do
    set -- ${file#./}

    SHRC=$1
    DOMAIN="${1%/*}${1#*/}" && DOMAIN=${DOMAIN%.shrc}
    HOSTNAME="$(echo "$DOMAIN" | tr . -)"

    echo "Host vm-$HOSTNAME"
  done
}
