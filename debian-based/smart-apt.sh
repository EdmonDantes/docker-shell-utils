#!/bin/bash

function pre_proxy {

  local proxy_config_file;

  if [[ -z "$APT_PROXY_CONFIG_FILE" ]]; then
    proxy_config_file=/etc/apt/apt.conf.d/90proxy;
  else
    proxy_config_file="$APT_PROXY_CONFIG_FILE";
  fi

  if [[ -n "$APT_HTTP_PROXY" ]]; then
    replace-or-add.sh "Acquire::http::Proxy.*" "Acquire::http::Proxy \"$APT_HTTP_PROXY\";" "$proxy_config_file"
  fi

  if [[ -n "$APT_HTTPS_PROXY" ]]; then
    replace-or-add.sh "Acquire::https::Proxy.*" "Acquire::https::Proxy \"$DRBD_BUILDER_APT_HTTPS_PROXY\";" "$proxy_config_file"
  elif [[ -n "$APT_HTTP_PROXY" ]]; then
    replace-or-add.sh "Acquire::https::Proxy.*" "Acquire::https::Proxy \"DIRECT\";" "$proxy_config_file"
  fi

  if is_debug_enabled.sh; then
    cat "$proxy_config_file"
  fi
}

function pre {
  pre_proxy;
}

function post_proxy {

  local proxy_config_file;

  if [[ -z "$APT_PROXY_CONFIG_FILE" ]]; then
    proxy_config_file=/etc/apt/apt.conf.d/90proxy;
  else
    proxy_config_file="$APT_PROXY_CONFIG_FILE";
  fi



  if is_debug_enabled.sh; then
    cat "$proxy_config_file"
  fi

  rm -f "$proxy_config_file" || true;

}

function post {
  post_proxy;
}

function update {
  apt-get update;
}

function clean {
  apt-get clean;
  rm -rf /var/lib/apt/lists/*;
}

function try_install {
  export DEBIAN_FRONTEND=noninteractive
  apt-get install -y --no-install-recommends "$@";
}

function main {
  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [[ "$1" == "pre" ]]; then
    pre;
  elif [[ "$1" == "post" ]]; then
    post;
  elif [[ "$1" == "update" ]]; then
    update;
  elif [[ "$1" == "clean" ]]; then
    clean;
  elif [[ "$1" == "install" ]]; then
    if ! try_install "${@:2}"; then
      update;
      try_install "${@:2}";
    fi
  elif [[ "$1" == "full-install" ]]; then
    pre;
    if ! try_install "${@:2}"; then
      update;
      try_install "${@:2}";
    fi
    clean;
    post;
  elif [[ "$1" == "resolve" ]]; then
    if [[ -x $(command -v "$2") ]]; then
      return 0;
    fi

    local package_name;
    if [[ -n "$3" ]]; then
      package_name="$3"
    else
      package_name="$2"
    fi

    if ! try_install "$package_name"; then
      update;
      try_install "$package_name";
    fi
  fi
}

if ! main "$@"; then
  exit 1;
fi;