#!/bin/sh

try_parse_boolean() {
  if [ -x "$(command -v 'to_lower.sh')" ] && [ -n "$1" ]; then
    if expr "X$(to_lower.sh "$1")" :  'X[y(es)?|t(rue)?|1|on?]' >/dev/null; then
      return 0
    fi
  fi

  return 1
}

main() {
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