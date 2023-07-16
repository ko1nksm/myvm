alias virt-install="virt_install"
virt_install() {
  "virt-install" "$@"
  vm.vnc display
}

vm_stop() {
  echo "Force stop vm"
  virsh destroy "$1"
}

vm_restart() {
  echo "Waiting for restart vm"
  state="running"
  while [ "$state" = running ]; do
    state=$(virsh dominfo "$1" | sed -n 's/State: \+//p')
    sleep 3
  done
  virsh start "$1"
}

vm_screenshot() {
  virsh screenshot "$1" --file /dev/stdout
}

vm_sendkey() {
  ./libexec/sendkey.sh "$@"
}

vm_setmem() {
  virsh setmem "$1" "$2" --config
  virsh setmaxmem "$1" "$2" --config
}

vm_vnc() {
  case ${2:-display} in
    display)
      set -- "$1" "$(virsh vncdisplay "$1")"
      echo "vncserver ($1): ${2:-unknown}"
      ;;
    enable | disable)
      (
        export MYVM_VIRSH_EDIT_COMMAND="$2-vnc"
        export EDITOR="./libexec/virsh-edit.sh"
        virsh edit "$1"
      )
      ;;
    *) echo "Unknown vnc command ${2:-}"
  esac
}

vm_attach_disk() {
  virsh attach-disk "$@"
}

vm_detach_disk() {
  virsh detach-disk "$@" --config
}

vm_demolish() {
  virsh destroy "$1" ||:
  virsh undefine "$1" --remove-all-storage
}
