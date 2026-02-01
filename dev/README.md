# Shell Utils for develop docker images

This folder contains utils for development docker images.

## Requirements

- [Docker](https://www.docker.com/)

## List of utils

- `check.sh` - utility for checking code style for all bash scripts and dockerfiles in the repository

### check.sh

Utility for checking code style for all bash scripts and dockerfiles in the repository.

#### Installing to your project

```shell
git clone https://github.com/EdmonDantes/docker-shell-utils.git /usr/local/etc/docker-shell-utils

# Optional
alias check-docker=/usr/local/etc/docker-shell-utils/dev/check.sh 
```

#### Usage

```shell
check-docker [project-folder] 
```

__OR__

```shell
/usr/local/etc/docker-shell-utils/dev/check.sh [project-folder]
```