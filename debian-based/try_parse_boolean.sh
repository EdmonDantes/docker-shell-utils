#!/bin/bash

function try_parse_boolean {
  if [[ -n "$(which to_lower.sh)" && -n "$1" && "$(to_lower.sh "$1")" =~ [y(es)?|t(rue)?|1|on?] ]]; then
    return 0
  fi

  return 1
}

if try_parse_boolean "$@"; then
  echo 'true';
else
  echo 'false';
fi



