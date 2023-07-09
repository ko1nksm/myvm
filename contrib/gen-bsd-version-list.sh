#!/bin/sh

set -eu

usage() {
  echo "Usage: ./gen-bsd-version-list.sh <FBD | NBD | OBD | DFB> < bsd-family-tree"
  echo ""
  echo "Note: https://cgit.freebsd.org/src/plain/share/misc/bsd-family-tree"
}

list() {
  grep ' \['"$1"'\]' bsd-family-tree | sort -V | {
    echo '| ID | Version          | Date       | IP address | mac address       |'
    echo '| -- | ---------------- | ---------- | ---------- | ----------------- |'
    awk -v n="$2" '{
      printf("| %2d | %-16s | %s | 10.0.%d.%-3d | 52:54:00:00:%02X:%02X | \n",
        NR, $1 " " $2, $3, n, NR, n , NR)
    }'
  }
}

FBD() {
  list FBD 1
  echo '| 86 | FreeBSD 14.0     | Upcoming   | 10.0.1.86  | 52:54:00:00:01:56 |'
}
NBD() { list NBD 2; }
OBD() { list OBD 3; }
DFB() { list DFB 4; }

[ $# -eq 0 ] && usage && exit 0
case $1 in
  FBD | NBD | OBD | DFB) "$1" ;;
  *) usage && exit 1 ;;
esac
