#!/bin/bash

function install {
  smart-apt.sh install git ca-certificates;
}

function configure {

  local email;
  local name;

  if [[ -n "$1" ]]; then
    email="$1";
  else
    email="$GIT_EMAIL";
  fi

  if [[ -n "$2" ]]; then
    name="$2";
  else
    name="$GIT_NAME";
  fi

  git config --global user.email "$email";
  git config --global user.name  "$name";

}

function local_last_tag {
  git describe --tags --abbrev=0;
}

function remote_last_tag {
  git ls-remote --exit-code --refs --tags "$1" \
    | grep -E 'refs/tags/v?[0-9]+.[0-9]*.[0-9]*' \
    | cut --delimiter='/' --field=3 \
    | tr '-' '~' \
    | sed -E 's/v//' \
    | sort -V \
    | tail -n 1
}

function check_remote_tag {
  if git ls-remote --exit-code --tags "$1" "$2"; then
    return 0
  else
    return 1
  fi
}

function prepare_submodules {
  git submodule init;
  git submodule update;
}

function clone {
  if [[ -z "$1" ]]; then
      return 1;
  fi

  local branch;

  if [[ -n "$3" ]]; then
    branch="$3"
  else
    branch=$(remote_last_tag "$1");
  fi

  if check_remote_tag "$1" "v$branch"; then
    branch="v$branch"
  fi

  git clone --depth 1 --recurse-submodules --shallow-submodules --branch "$branch" --single-branch "$1" "$2";
}

function main {

  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [[ "$1" == "install" ]]; then
    install;
  elif [[ "$1" == "configure" ]]; then
    install;
    configure "${@:2}";
  elif [[ "$1" == "tag" ]]; then
    if [[ "$2" == "local" && "$3" == "last" ]]; then
      local_last_tag "${@:4}";
    elif [[ "$2" == "remote" ]]; then
      if [[ "$3" == "last" ]]; then
        remote_last_tag "${@:4}"
      elif [[ "$3" == "check" ]]; then
        check_remote_tag "${@:4}";
      fi
    fi
  elif [[ "$1" == "prepare-submodules" ]]; then
    prepare_submodules "${@:2}";
  elif [[ "$1" == "clone-only" ]]; then
    clone "${@:2}";
  elif [[ "$1" == "clone" ]]; then
    install;
    configure;
    clone "${@:2}";
  fi

}

if ! main "$@"; then
  exit 1;
fi