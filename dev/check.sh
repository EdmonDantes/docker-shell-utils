#!/bin/sh

if [ -z "$1" ]; then
  TARGET_FOLDER="$(pwd)"
else
  TARGET_FOLDER="$1"
fi

find . -name "*.sh" -type f -exec docker run --rm -v "$TARGET_FOLDER:/app" koalaman/shellcheck:stable "/app/{}" ';'

find . -name "Dockerfile*" -type f -exec docker run --rm -v "$TARGET_FOLDER:/app" hadolint/hadolint hadolint "/app/{}" ';'