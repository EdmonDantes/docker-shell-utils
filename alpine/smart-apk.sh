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
  elif [ "$1" = "full-install" ]; then
    shift 1
    try_install "$@"
  elif [ "$1" = "delete" ]; then
    shift 1
    delete "$@"
  elif [ "$1" = "resolve" ]; then
    if [ -x "$(command -v "$2")" ]; then
      return 0;
    fi

    if [ -n "$3" ]; then
      _main_package_name="$3"
    else
      _main_package_name="$2"
    fi

    try_install "$_main_package_name";
  fi
}

if ! main "$@"; then
  exit 1;
fi;