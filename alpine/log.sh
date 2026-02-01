#!/bin/sh

level_to_number() {
  if [ -x "$(command -v to_lower.sh)" ]; then
    _level_to_number_level=$(to_lower.sh "$1")
  else
    _level_to_number_level="$1"
  fi

  if [ "$_level_to_number_level" = 'none' ]; then
    echo '0';
  elif [ "$_level_to_number_level" = 'error' ]; then
    echo '1'
  elif [ "$_level_to_number_level" = 'warn' ]; then
    echo '2'
  elif [ "$_level_to_number_level" = 'info' ]; then
    echo '3'
  elif [ "$_level_to_number_level" = 'debug' ]; then
    echo '4'
  elif [ "$_level_to_number_level" = 'trace' ]; then
    echo '5'
  elif [ "$_level_to_number_level" = 'all' ]; then
    echo '100'
  fi
}

compare_levels() {

  if [ -x "$(command -v to_lower.sh)" ]; then
    _compare_levels_a=$(to_lower.sh "$1")
  else
    _compare_levels_a="$1"
  fi

  if [ -x "$(command -v to_lower.sh)" ]; then
    _compare_levels_b=$(to_lower.sh "$2")
  else
    _compare_levels_b="$2"
  fi

  if [ "$_compare_levels_a" = "$_compare_levels_b" ]; then
    echo 'e';
  elif [ "$(level_to_number "$_compare_levels_a")" -gt "$(level_to_number "$_compare_levels_b")" ]; then
    echo 'g';
  else
    echo 'l';
  fi
}

error() {
  if [ -n "$LOG_FILE" ]; then
    echo "[ERROR]" "$@" >> "$LOG_FILE";
  elif [ -x "$(command -v try_parse_boolean.sh)" ] && [ "$(try_parse_boolean.sh "$LOG_ERROR_MERGE")" = 'true' ]; then
    echo "[ERROR]" "$@"
  else
    >&2 echo "[ERROR]" "$@"
  fi
}

warn() {
  if [ -n "$LOG_FILE" ]; then
    echo "[WARN]" "$@" >> "$LOG_FILE";
  else
    echo "[WARN]" "$@";
  fi
}

info() {
  if [ -n "$LOG_FILE" ]; then
    echo "[INFO]" "$@" >> "$LOG_FILE";
  else
    echo "[INFO]" "$@";
  fi
}

debug() {
  if [ -n "$LOG_FILE" ]; then
    echo "[DEBUG]" "$@" >> "$LOG_FILE";
  else
    echo "[DEBUG]" "$@"
  fi
}

trace() {
  if [ -n "$LOG_FILE" ]; then
    echo "[TRACE]" "$@" >> "$LOG_FILE";
  else
    echo "[TRACE]" "$@";
  fi
}

main() {

  set -e;

  if is_debug_enabled.sh; then
    set -x;
  fi

  if [ -z "$1" ]; then
    return 1
  fi

  if [ -z "$2" ]; then
    return 0;
  fi

  if [ -n "$LOG_LEVEL" ]; then
    if [ -x "$(command -v to_lower.sh)" ]; then
      _main_max_level=$(to_lower.sh "$LOG_LEVEL")
    else
      _main_max_level="$LOG_LEVEL"
    fi
  else
    _main_max_level='info';
  fi

  if [ -x "$(command -v to_lower.sh)" ]; then
    _main_level=$(to_lower.sh "$1")
  else
    _main_level="$1"
  fi

  shift 1
  if [ "$_main_level" = 'error' ] && [ "$(compare_levels "$_main_level" "$_main_max_level")" != 'g' ]; then
    error "$@";
  elif [ "$_main_level" = 'warn' ] && [ "$(compare_levels "$_main_level" "$_main_max_level")" != 'g' ]; then
    warn "$@";
  elif [ "$_main_level" = 'info' ] && [ "$(compare_levels "$_main_level" "$_main_max_level")" != 'g' ]; then
    info "$@";
  elif [ "$_main_level" = 'debug' ] && [ "$(compare_levels "$_main_level" "$_main_max_level")" != 'g' ]; then
    debug "$@";
  elif [ "$_main_level" = 'trace' ] && [ "$(compare_levels "$_main_level" "$_main_max_level")" != 'g' ]; then
    trace "$@";
  fi
}

if ! main "$@"; then
  exit 1
fi
