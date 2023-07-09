#!/bin/sh

set -eu

prefilter() {
  gm convert - -colorspace Gray -resize 200% -
}

ocr() {
  tesseract --psm 6 - -
}

prefilter | ocr
