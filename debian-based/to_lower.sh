#!/bin/bash

function main {
  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [[ -n "$1" ]]; then
    echo "$1" | tr '[:upper:]' '[:lower:]'
  fi
}

if ! main "$@"; then
  exit 1;
fi
