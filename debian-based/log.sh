#!/bin/bash

function level_to_number {
  local level;
  if [[ -n "$(which to_lower.sh)" ]]; then
    level=$(to_lower.sh "$1")
  else
    level="$1"
  fi

  if [[ "$level" == 'none' ]]; then
    echo '0';
  elif [[ "$level" == 'error' ]]; then
    echo '1'
  elif [[ "$level" == 'warn' ]]; then
    echo '2'
  elif [[ "$level" == 'info' ]]; then
    echo '3'
  elif [[ "$level" == 'debug' ]]; then
    echo '4'
  elif [[ "$level" == 'trace' ]]; then
    echo '5'
  elif [[ "$level" == 'all' ]]; then
    echo '100'
  fi
}

function compare_levels {
  local a;

  if [[ -n "$(which to_lower.sh)" ]]; then
    a=$(to_lower.sh "$1")
  else
    a="$1"
  fi

  local b;

  if [[ -n "$(which to_lower.sh)" ]]; then
    b=$(to_lower.sh "$2")
  else
    b="$2"
  fi

  if [[ "$a" == "$b" ]]; then
    echo 'e';
  elif [[ $(level_to_number "$a") -gt $(level_to_number "$b") ]]; then
    echo 'g';
  else
    echo 'l';
  fi
}

function error {
  if [[ -n "$LOG_FILE" ]]; then
    echo "[ERROR]" "$@" >> "$LOG_FILE";
  elif [[ -n "$(which try_parse_boolean.sh)" && "$(try_parse_boolean.sh "$LOG_ERROR_MERGE")" == 'true' ]]; then
    echo "[ERROR]" "$@"
  else
    >&2 echo "[ERROR]" "$@"
  fi
}

function warn {
  if [[ -n "$LOG_FILE" ]]; then
    echo "[WARN]" "$@" >> "$LOG_FILE";
  else
    echo "[WARN]" "$@";
  fi
}

function info {
  if [[ -n "$LOG_FILE" ]]; then
    echo "[INFO]" "$@" >> "$LOG_FILE";
  else
    echo "[INFO]" "$@";
  fi
}

function debug {
  if [[ -n "$LOG_FILE" ]]; then
    echo "[DEBUG]" "$@" >> "$LOG_FILE";
  else
    echo "[DEBUG]" "$@"
  fi
}

function trace {
  if [[ -n "$LOG_FILE" ]]; then
    echo "[TRACE]" "$@" >> "$LOG_FILE";
  else
    echo "[TRACE]" "$@";
  fi
}

function main {

  if [[ -z "$1" ]]; then
    return 1
  fi

  if [[ -z "$2" ]]; then
    return 0;
  fi

  local max_level;
  if [[ -n "$LOG_LEVEL" ]]; then
    if [[ -n "$(which to_lower.sh)" ]]; then
      max_level=$(to_lower.sh "$LOG_LEVEL")
    else
      max_level="$LOG_LEVEL"
    fi
  else
    max_level='info';
  fi

  local level;
  if [[ -n "$(which to_lower.sh)" ]]; then
    level=$(to_lower.sh "$1")
  else
    level="$1"
  fi

  if [[ "$level" == 'error' && "$(compare_levels "$level" "$max_level")" != 'g' ]]; then
    error "${@:2}";
  elif [[ "$level" == 'warn' && "$(compare_levels "$level" "$max_level")" != 'g' ]]; then
    warn "${@:2}";
  elif [[ "$level" == 'info' && "$(compare_levels "$level" "$max_level")" != 'g' ]]; then
    info "${@:2}";
  elif [[ "$level" == 'debug' && "$(compare_levels "$level" "$max_level")" != 'g' ]]; then
    debug "${@:2}";
  elif [[ "$level" == 'trace' && "$(compare_levels "$level" "$max_level")" != 'g' ]]; then
    trace "${@:2}";
  fi
}

if ! main "$@"; then
  exit 1
fi
