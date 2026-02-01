#!/bin/bash

PATH="$PATH:$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")";
export PATH;