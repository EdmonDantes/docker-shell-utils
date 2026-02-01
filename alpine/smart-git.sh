#!/bin/sh

install() {
  smart-apk.sh install real git ca-certificates;
}

full_install() {
  install;
}

configure() {

  if [ -n "$1" ]; then
    _configure_email="$1";
  else
    _configure_email="$GIT_EMAIL";
  fi

  if [ -n "$2" ]; then
    _configure_name="$2";
  else
    _configure_name="$GIT_NAME";
  fi

  git config --global user.email "$_configure_email";
  git config --global user.name  "$_configure_name";

}

local_last_tag() {
  git describe --tags --abbrev=0;
}

remote_last_tag() {
  git ls-remote --exit-code --refs --tags "$1" \
    | grep -E 'refs/tags/v?[0-9]+.[0-9]*.[0-9]*' \
    | cut --delimiter='/' --field=3 \
    | tr '-' '~' \
    | sed -E 's/v//' \
    | sort -V \
    | tail -n 1
}

check_remote_tag() {
  if git ls-remote --exit-code --tags "$1" "$2"; then
    return 0
  else
    return 1
  fi
}

prepare_submodules() {
  git submodule init;
  git submodule update;
}

clone() {
  if [ -z "$1" ]; then
      return 1;
  fi

  if [ -n "$3" ]; then
    _clone_branch="$3"
  else
    _clone_branch=$(remote_last_tag "$1");
  fi

  if check_remote_tag "$1" "v$_clone_branch"; then
    _clone_branch="v$_clone_branch"
  fi

  git clone --depth 1 --recurse-submodules --shallow-submodules --branch "$_clone_branch" --single-branch "$1" "$2";
}

main() {

  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [ "$1" = "install" ]; then
    install;
  elif [ "$1" = "full-install" ]; then
    full_install;
  elif [ "$1" = "configure" ]; then
    full_install;
    shift 1
    configure "$@";
  elif [ "$1" = "tag" ]; then
    if [ "$2" = "local" ] && [ "$3" = "last" ]; then
      shift 3
      local_last_tag "$@";
    elif [ "$2" = "remote" ]; then
      if [ "$3" = "last" ]; then
        shift 3
        remote_last_tag "$@"
      elif [ "$3" = "check" ]; then
        shift 3
        check_remote_tag "$@";
      fi
    fi
  elif [ "$1" = "prepare-submodules" ]; then
    shift 1
    prepare_submodules "$@";
  elif [ "$1" = "clone-only" ]; then
    shift 1
    clone "$@";
  elif [ "$1" = "clone" ]; then
    full_install;
    configure;
    shift 1
    clone "$@";
  fi

}

if ! main "$@"; then
  exit 1;
fi