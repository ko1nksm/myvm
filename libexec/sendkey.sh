#!/bin/sh

set -eu

virsh_sendkey() {
  virsh send-key "$domain" "$@" >/dev/null
}

define_keymap() {
  keymap() {
    while [ $# -gt 0 ]; do
      echo "      '${1%:*}') virsh_sendkey ${1##*:} ;;"
      shift
    done
  }

  keymap '1:KEY_1' '2:KEY_2' '3:KEY_3' '4:KEY_4' '5:KEY_5'
  keymap '6:KEY_6' '7:KEY_7' '8:KEY_8' '9:KEY_9' '0:KEY_0'

  keymap '!:KEY_LEFTSHIFT KEY_1' '@:KEY_LEFTSHIFT KEY_2'
  keymap '#:KEY_LEFTSHIFT KEY_3' '$:KEY_LEFTSHIFT KEY_4'
  keymap '%:KEY_LEFTSHIFT KEY_5' '^:KEY_LEFTSHIFT KEY_6'
  keymap '&:KEY_LEFTSHIFT KEY_7' '*:KEY_LEFTSHIFT KEY_8'
  keymap '(:KEY_LEFTSHIFT KEY_9' '):KEY_LEFTSHIFT KEY_0'

  keymap 'a:KEY_A' 'b:KEY_B' 'c:KEY_C' 'd:KEY_D' 'e:KEY_E'
  keymap 'f:KEY_F' 'g:KEY_G' 'h:KEY_H' 'i:KEY_I' 'j:KEY_J'
  keymap 'k:KEY_K' 'l:KEY_L' 'm:KEY_M' 'n:KEY_N' 'o:KEY_O'
  keymap 'p:KEY_P' 'q:KEY_Q' 'r:KEY_R' 's:KEY_S' 't:KEY_T'
  keymap 'u:KEY_U' 'v:KEY_V' 'w:KEY_W' 'x:KEY_X' 'y:KEY_Y'
  keymap 'z:KEY_Z' ' :KEY_SPACE'

  keymap 'A:KEY_LEFTSHIFT KEY_A' 'B:KEY_LEFTSHIFT KEY_B'
  keymap 'C:KEY_LEFTSHIFT KEY_C' 'D:KEY_LEFTSHIFT KEY_D'
  keymap 'E:KEY_LEFTSHIFT KEY_E' 'F:KEY_LEFTSHIFT KEY_F'
  keymap 'G:KEY_LEFTSHIFT KEY_G' 'H:KEY_LEFTSHIFT KEY_H'
  keymap 'I:KEY_LEFTSHIFT KEY_I' 'J:KEY_LEFTSHIFT KEY_J'
  keymap 'K:KEY_LEFTSHIFT KEY_K' 'L:KEY_LEFTSHIFT KEY_L'
  keymap 'M:KEY_LEFTSHIFT KEY_M' 'N:KEY_LEFTSHIFT KEY_N'
  keymap 'O:KEY_LEFTSHIFT KEY_O' 'P:KEY_LEFTSHIFT KEY_P'
  keymap 'Q:KEY_LEFTSHIFT KEY_Q' 'R:KEY_LEFTSHIFT KEY_R'
  keymap 'S:KEY_LEFTSHIFT KEY_S' 'T:KEY_LEFTSHIFT KEY_T'
  keymap 'U:KEY_LEFTSHIFT KEY_U' 'V:KEY_LEFTSHIFT KEY_V'
  keymap 'W:KEY_LEFTSHIFT KEY_W' 'X:KEY_LEFTSHIFT KEY_X'
  keymap 'Y:KEY_LEFTSHIFT KEY_Y' 'Z:KEY_LEFTSHIFT KEY_Z'

  keymap '`:KEY_GRAVE'          '~:KEY_LEFTSHIFT KEY_GRAVE'
  keymap '-:KEY_MINUS'          '_:KEY_LEFTSHIFT KEY_MINUS'
  keymap '=:KEY_EQUAL'          '+:KEY_LEFTSHIFT KEY_EQUAL'
  keymap '\:KEY_BACKSLASH'      '|:KEY_LEFTSHIFT KEY_BACKSLASH'
  keymap '[:KEY_LEFTBRACE'      '{:KEY_LEFTSHIFT KEY_LEFTBRACE'
  keymap ']:KEY_RIGHTBRACE'     '}:KEY_LEFTSHIFT KEY_RIGHTBRACE'
  keymap ';:KEY_SEMICOLON'      '::KEY_LEFTSHIFT KEY_SEMICOLON'
  keymap "'\\'':KEY_APOSTROPHE" '":KEY_LEFTSHIFT KEY_APOSTROPHE'
  keymap ',:KEY_COMMA'          '<:KEY_LEFTSHIFT KEY_COMMA'
  keymap '.:KEY_DOT'            '>:KEY_LEFTSHIFT KEY_DOT'
  keymap '/:KEY_SLASH'          '?:KEY_LEFTSHIFT KEY_SLASH'
}

define_special_keymap() {
  keymap() {
    while [ $# -gt 0 ]; do
      echo "      '${1%:*}') virsh_sendkey ${1##*:} ;;"
      shift
    done
  }

  keymap 'F1:KEY_F1'  'F2:KEY_F2'   'F3:KEY_F3'   'F4:KEY_F4'
  keymap 'F5:KEY_F5'  'F6:KEY_F6'   'F7:KEY_F7'   'F8:KEY_F8'
  keymap 'F9:KEY_F9'  'F10:KEY_F10' 'F11:KEY_F11' 'F12:KEY_F12'
  keymap 'UP:KEY_UP' 'DOWN:KEY_DOWN' 'LEFT:KEY_LEFT' 'RIGHT:KEY_RIGHT'
  keymap 'ENTER:KEY_ENTER' 'TAB:KEY_TAB' 'HOME:KEY_HOME' 'END:KEY_END'
  keymap 'BS:KEY_BACKSPACE' 'DEL:KEY_DELETE' 'INSERT:KEY_INSERT'
  keymap 'PAGEDOWN:KEY_PAGEDOWN' 'PAGEUP:KEY_PAGEUP'
  keymap 'CAPSLOCK:KEY_CAPSLOCK' 'SCROLLLOCK:SCROLLLOCK'
  keymap 'SYSRQ:KEY_SYSRQ' 'BREAK:KEY_BREAK' 'SPACE:KEY_SPACE'
}

define_modifier_keymap() {
  keymap() {
    while [ $# -gt 0 ]; do
      echo "    '${1%:*}') virsh_sendkey ${1##*:} \"KEY_\$2\" ;;"
      shift
    done
  }

  keymap 'ALT:KEY_LEFTALT' 'CTRL:KEY_LEFTCTRL'
  keymap 'ALT+CTRL:KEY_LEFTALT KEY_LEFTCTRL'
  keymap 'CTRL+ALT:KEY_LEFTCTRL KEY_LEFTALT'
}

define_send_normal_key() {
  echo 'send_normal_key() {'
  echo '  while [ "$1" ]; do'
  echo '    set -- "${1%"${1#?}"}" "${1#?}"'
  echo '    case $1 in'
  define_keymap
  echo '      *) echo "Unknown normal key: $1" && exit 1'
  echo '    esac'
  echo '    set -- "$2"'
  echo '  done'
  echo '}'
}

define_send_special_key() {
  echo 'send_special_key() {'
  echo '  set -- "${1#?}" "${2:-1}" && set -- "${1%?}" "$2"'
  echo '  while [ $2 -gt 0 ]; do'
  echo '    case $1 in'
  define_special_keymap
  echo '      *) echo "Unknown special key: $1" && exit 1'
  echo '    esac'
  echo '    set -- "$1" $(($2 - 1))'
  echo '  done'
  echo '}'
}

define_send_key_with_modifier() {
  echo 'send_key_with_modifier() {'
  echo '  set -- "${1#?}" "$2" && set -- "${1%?}" "$2"'
  echo '  case $1 in'
  define_modifier_keymap
  echo '    *) echo "Unknown modifier key: $1" && exit 1'
  echo '  esac'
  echo '}'
}

sendkey() {
  # example: send_key abcd {HOME} {TAB}x2
  while [ $# -gt 0 ]; do
    case $1 in
      '{'*'}') send_special_key "$1" ;;
      '{'*'}x'[0-9] | '{'*'}x'[0-9][0-9])
        send_special_key "${1%x*}" "${1#*x}"
        ;;
      '{'*'}-'[A-Z0-9])
        send_key_with_modifier "${1%-*}" "${1#*-}"
        ;;
      *) send_normal_key "$1" ;;
    esac
    sleep 0.5
    shift
  done
}

eval "$(define_send_normal_key)"
eval "$(define_send_special_key)"
eval "$(define_send_key_with_modifier)"

domain=$1
shift
sendkey "$@"
