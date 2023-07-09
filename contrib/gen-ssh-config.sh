#!/bin/sh

find . -name "*.shrc" | sort -V | {
  while IFS= read -r file; do
    set -- ${file#./}

    SHRC=$1
    DOMAIN="${1%/*}${1#*/}" && DOMAIN=${DOMAIN%.shrc}
    HOSTNAME="vm-$(echo "$DOMAIN" | tr . -)"

    echo "Host $HOSTNAME"
  done
}


