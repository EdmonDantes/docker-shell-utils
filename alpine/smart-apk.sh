#!/bin/sh

try_install() {
  apk add --no-cache "$@";
}

try_install_virtual() {
  _try_install_virtual_name="$1"
  shift 1
  apk add --no-cache --virtual "$_try_install_virtual_name" "$@"
}

delete() {
  apk del "$1"
}

main() {
  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [ "$1" = "install" ]; then
    if [ "$2" = "real" ]; then
      shift 2
      try_install "$@"
    elif [ "$2" = "virtual" ]; then
      shift 2
      try_install_virtual "$@"
    fi
  elif [ "$1" = "delete" ]; then
    shift 1
    delete "$@"
  fi
}

if ! main "$@"; then
  exit 1;
fi;