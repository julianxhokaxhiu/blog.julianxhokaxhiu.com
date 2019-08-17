#!/usr/bin/env bash
set -e

HUGO_RELEASE="0.57.2"
HUGO_PATH=".bin"

if [ ! -z $1 ]; then
  if [ $1 == "clean" ]; then
    rm -rf \
      .dist \
      ${HUGO_PATH}
    exit 0
  fi
fi

if [ ! -d ${HUGO_PATH} ]; then
  # Create binary folder
  mkdir -p ${HUGO_PATH}

  # Download and Extract Hugo
  curl -q -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_RELEASE}/hugo_${HUGO_RELEASE}_Linux-64bit.tar.gz | tar xz -C ${HUGO_PATH}

  # Ensure it's executable
  chmod +x ${HUGO_PATH}/hugo
fi

# Run hugo
${HUGO_PATH}/hugo $@
