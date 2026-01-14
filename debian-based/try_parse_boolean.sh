#!/bin/bash

function try_parse_boolean {
  if [[ -x "$(command -v 'to_lower.sh')" && -n "$1" && "$(to_lower.sh "$1")" =~ [y(es)?|t(rue)?|1|on] ]]; then
    return 0
  fi

  return 1
}

function main {
  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi


  if try_parse_boolean "$@"; then
    echo 'true';
  else
    echo 'false';
  fi
}

if ! main "$@"; then
  exit 1;
fi