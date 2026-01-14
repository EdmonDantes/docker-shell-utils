#!/bin/bash

if [[ -n "$DEBUG_ENABLED" && "$(tr '[:upper:]' '[:lower:]' <<< "$DEBUG_ENABLED")" =~ [y(es)?|t(rue)?|1|on?] ]]; then
  exit 0;
fi;

exit 1;