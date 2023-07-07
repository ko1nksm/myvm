#!/bin/sh

set -eu

overwrite() {
  { work=$(shift; "$@"); } < "$1"
  printf '%s\n' "$work" > "$1"
}

append_vnc() {
  sed '/<\/devices>/i\
    <graphics type="vnc" port="-1" autoport="yes" listen="0.0.0.0">\
      <listen type="address" address="0.0.0.0" />\
    </graphics>
'
}

remove_vnc() {
  sed '/<graphics /,/<\/graphics>/d'
}

enable_vnc() {
  overwrite "$1" remove_vnc
  overwrite "$1" append_vnc
}

disable_vnc() {
  overwrite "$1" remove_vnc
}

cmd=${MYVM_VIRSH_EDIT_COMMAND:-}
case $cmd in
  enable-vnc) enable_vnc "$@" ;;
  disable-vnc) disable_vnc "$@" ;;
  *) echo "virsh-edit: Unknown command '$cmd'"
esac
