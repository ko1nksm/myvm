#!/bin/sh

set -eu

screenshot() {
  virsh screenshot "$1" --file /dev/stdout
}

prefilter() {
  gm convert - -colorspace Gray -resize 200% -
}

ocr() {
  tesseract --psm 6 - -
}

postfilter() {
  grep . | tr -d '()'
}

screenshot "$1" | prefilter | ocr | postfilter
