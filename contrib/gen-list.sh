#!/bin/sh

set -eu

PREFIX="vm-"

usage() {
  echo "Usage: ./gen-bsd-version-list.sh <table | list | hosts | dhcp>"
}

bsd_family_tree() {
  # URL: https://cgit.freebsd.org/src/plain/share/misc/bsd-family-tree"
  cat bsd-family-tree
  echo "FreeBSD 14.0 Upcoming [FBD]"
}

bsd_list() {
  bsd_family_tree | grep ' \['"$1"'\]' | sort -V | {
    awk -v prefix="$PREFIX" -v num="$2" '{
      name = $1 $2
      hostname = prefix tolower($1) $2; gsub(/\./, "-", hostname);
      date = $3
      ipaddr = sprintf("10.0.%d.%-3d", num, NR)
      macaddr = sprintf("52:54:00:00:%02X:%02X", num, NR)
      print name, hostname, ipaddr, macaddr, date
    }'
  }
}

other_list() {
  cat << HERE
Solaris10.u11       ${PREFIX}solaris10-u11       10.0.5.1  52:54:00:00:05:01
Solaris11.3         ${PREFIX}solaris11-3         10.0.5.2  52:54:00:00:05:02
Solaris11.4         ${PREFIX}solaris11-4         10.0.5.3  52:54:00:00:05:03
Solaris11.4.42      ${PREFIX}solaris11-4-42      10.0.5.4  52:54:00:00:05:04
OpenIndiana2023.05  ${PREFIX}openindiana2023-05  10.0.6.1  52:54:00:00:06:01
Minix3.3.0          ${PREFIX}minix3-3-0          10.0.7.1  52:54:00:00:07:01
HERE
}

output_list() {
  {
    for i in FBD:1 NBD:2 OBD:3 DFB:4; do
      bsd_list "${i%:*}" "${i#*:}"
    done
    other_list
  } | column -t
}

output_table() {
  output_list | column -t -o ' | '
}

# dnsmasq.conf
#   addn-hosts=/etc/vm-hosts
#   dhcp-hostsfile=/etc/vm-hosts.conf

# for /etc/vm-hosts
output_hosts() {
  output_list | while read -r name host ip mac date; do
    echo "$ip" "$host"
  done
}

# for /etc/vm-hosts.conf
output_dhcp() {
  output_list | while read -r name host ip mac date; do
    # printf 'dhcp-host=%s,%-10s # %s (%s)\n' "$mac" "$ip" "$name" "$host"
    printf '%s,%-10s # %s (%s)\n' "$mac" "$ip" "$name" "$host"
  done
}

case ${1--help} in
  --help) usage && exit 0 ;;
  table | list | hosts | dhcp) "output_$1" ;;
  *) usage && exit 1
esac
