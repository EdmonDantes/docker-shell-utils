#!/bin/sh

if [ -z "$DEBUG_ENABLED" ]; then
  exit 1;
fi

DEBUG_ENABLED_LOWER=$(tr '[:upper:]' '[:lower]' <<EOF
$DEBUG_ENABLED
EOF
);

if expr "X$DEBUG_ENABLED_LOWER" : 'X[y(es)?|t(rue)?|1|on?]' >/dev/null; then
  exit 0;
fi

exit 1;