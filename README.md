# Docker Shell Utilities

Repository with shell utilities for Docker images.

## Usage

```shell
docker run -it --rm -v "./$VARIANT:/src/utils" "$VARIANT_IMAGE:latest"
source /src/utils/install.sh
```

## Structure

- `debian-based` - utilities for Debian-based images
- `dev` - utilities for development

### Debian-based

#### List of utils

- `log.sh` - utility for logging
- `replace-or-add.sh` - utility for replacing or adding lines to files
- `smart-apt.sh` - utility for easily installing packages by `apt-get` command
- `smart-git.sh` - utility for easily working with git repositories
- `to_lower.sh` - utility for converting string to lower case
- `try_parse_boolean.sh` - utility for parsing boolean values from strings

##### log.sh

Utility for send logging messages to stdout.

```shell
log.sh <level> <message>
```
Use environment variables for configure:

- `LOG_LEVEL` - maximum log level (default: `info`)
- `LOG_FILE` - path to file for logging (default: empty). __WARNING__: all output will be redirected to this file.

###### Supported log levels:
 - `all`
 - `trace`
 - `debug`
 - `info`
 - `warning`
 - `error`
 - `none`

##### replace-or-add.sh

Utility for replacing or adding lines to files.

```shell
replace-or-add.sh <regexp_for_remove> <string_to_add> <file_path>
```

##### smart-apt.sh

Utility for easily installing packages by `apt-get` command.

###### Subcommands

- `pre` - preparing apt-get utility for work with other commands
- `post` - cleaning apt-get utility after work with other commands
- `update` - update apt-get cache
- `clean` - clean apt-get cache and packages
- `install-only <package> [packages]` - install packages without preparations and cleaning cache
- `install <package> [packages]` - install packages with all preparations and cleaning after installation

##### smart-git.sh

Utility for easily working with git repositories.

###### Subcommands

- `install` - install git by `smart-apt.sh` utility
- `configure` - configure git for cloning repositories
- `pre` - preparations for work with git
- `last-tag local` - get last version from tags from local repository
- `last-tag remote <url>` - get last version from tags from remote repository
- `clone-only` - clone repository without preparations
- `clone` - clone repository with all preparations

##### to_lower.sh

Utility for converting string to lower case. 
It returns lower case string.

```shell
to_lower.sh <string>
```

##### try_parse_boolean.sh

Utility for parsing boolean values from strings.
It returns `true` or `false` based on the input string.

```shell
try_parse_boolean.sh <string>
```

### Development

#### check.sh 

Utility for checking code style for all bash scripts and dockerfiles in the repository.

#### Installing to your project

```shell
git clone https://github.com/EdmonDantes/docker-shell-utils.git utils

# Optional
alias check-docker=./utils/dev/check.sh 
```

#### Usage

```shell
check-docker [project-folder] 
```

__OR__

```shell
./utils/dev/check.sh [project-folder]
```