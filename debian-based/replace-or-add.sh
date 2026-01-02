#!/bin/bash

if [[ -z "$1" ]]; then
  log.sh error "Can not replace or add without argument for remove. Please call with arguments <remove> <add> <file>"
  exit 1
fi

if [[ -z "$2" ]]; then
  log.sh error "Can not replace or add without argument for add. Please call with arguments <remove> <add> <file>"
  exit 1
fi

if [[ -z "$3" ]]; then
  log.sh error "Can not replace or add without file argument. Please call with arguments <remove> <add> <file>"
  exit 1
fi

if [[ -e "$3" && $(cat "$3" | grep -Ec "$1") -gt 0 ]]; then
  sed -i "s/$1/$2/" "$3"
else
  echo "$2" >> "$3"
fi