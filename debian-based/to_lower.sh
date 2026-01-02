#!/bin/bash

if [[ -n "$1" ]]; then
  echo "$1" | tr '[:upper:]' '[:lower:]'
fi