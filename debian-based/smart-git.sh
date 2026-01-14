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
  git -c 'vesionsort.suffix=-' \
    ls-remote --exit-code --refs --sort='version:refname' --tags "$1" '*.*.*' \
    | tail --lines=1 \
    | cut --delimiter='/' --field=3
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

  git clone --recursive --depth 1 --branch "$branch" --single-branch "$@";
}

function main {

  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [[ "$1" == "install" ]]; then
    install;
  elif [[ "$1" == "configure" ]]; then
    configure "${@:2}";
  elif [[ "$1" == "pre" ]]; then
    install;
    configure;
  elif [[ "$1" == "last-tag" ]]; then
    if [[ "$2" == "local" ]]; then
      local_last_tag;
    elif [[ "$2" == "remote" ]]; then
      remote_last_tag "${@:3}"
    fi
  elif [[ "$1" == "prepare-submodules" ]]; then
    prepare_submodules;
  elif [[ "$1" == "clone-only" ]]; then
    clone "${@:2}";
  elif [[ "$1" == "clone" ]]; then
    install;
    configure;
    clone "${@:2}";
  fi

}

main "$@";



