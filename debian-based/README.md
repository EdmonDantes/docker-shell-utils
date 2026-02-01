# Docker Shell Utils for Debian-based images

This variant contains utilities for Debian-based Docker images (based on Debian or Ubuntu). It requires `bash` for
correct work.

## Requirements

- [bash](https://www.gnu.org/software/bash/)

## Usage

```shell
docker run -it --rm -v "./$VARIANT:/src/utils" "$VARIANT_IMAGE:latest"
source /src/utils/install.sh
```

## List of utils

- `install.sh` - utility for installing all utils
- `is_debug_enabled.sh` - utility for checking if debug mode is enabled
- `log.sh` - utility for logging
- `replace-or-add.sh` - utility for replacing or adding lines to files
- `smart-apt.sh` - utility for easily installing packages by `apt-get` command
- `smart-git.sh` - utility for easily working with git repositories
- `to_lower.sh` - utility for converting string to lower case
- `try_parse_boolean.sh` - utility for parsing boolean values from strings

### install.sh

Utility for installing all utils.

```shell
source install.sh
```

Add folder with utils to `PATH` environment variable.

### is_debug_enabled.sh

Utility for checking if debug mode is enabled.

```shell
is_debug_enabled.sh
```

Returns `0` exit code if debug mode is enabled else `1`.

### log.sh

Utility for send logging messages to stdout.

```shell
log.sh <level> <message>
```

Use environment variables for configure:

- `LOG_LEVEL` - maximum log level (default: `info`)
- `LOG_FILE` - path to file for logging (default: empty). __WARNING__: all output will be redirected to this file.

#### Supported log levels:

- `all`
- `trace`
- `debug`
- `info`
- `warning`
- `error`
- `none`

### replace-or-add.sh

Utility for replacing or adding lines to files.

```shell
replace-or-add.sh <regexp_for_remove> <string_to_add> <file_path>
```

### smart-apt.sh

Utility for easily installing packages by `apt-get` command.

#### Subcommands

- `pre` - preparing apt-get utility for work with other commands
- `post` - cleaning apt-get utility after work with other commands
- `update` - update apt-get cache
- `clean` - clean apt-get cache and packages
- `install <package> [packages]` - install packages without any preparations and/or cleaning
- `full-install <package> [packages]` - install packages with all preparations and cleaning after installation
- `resolve <command> [package]` - check if command is installed and install it if not without any preparations and/or
  cleaning

##### Preparations

- If environment `HTTP_PROXY` is setted then the script set http proxy for `apt-get`
- If environment `HTTPS_PROXY` is setted then the script set https proxy for `apt-get`

### smart-git.sh

Utility for easily working with git repositories.

#### Subcommands

- `install` - install git by `smart-apt.sh` utility
- `full-install` - install git by `smart-apt.sh` with all preparations and cleaning after installation
- `configure` - configure git for cloning repositories
- `tag local last` - get last version from tags from local repository
- `tag remote last <url>` - get last version from tags from remote repository. __WARNING__: without `v` prefix
- `tag remote check <url>` - check if remote repository has tags
- `prepare-submodules` - init and download git submodules for local repository
- `clone-only <url> [folder]` - clone repository without preparations
- `clone <url> [folder]` - clone repository with all preparations

### to_lower.sh

Utility for converting string to lower case.
It prints lower-case string.

```shell
to_lower.sh <string>
```

### try_parse_boolean.sh

Utility for parsing boolean values from strings.
It prints `true` or `false` based on the input string.

```shell
try_parse_boolean.sh <string>
```

Possible values for `true` (case-insensitive):

- `y`
- `yes`
- `t`
- `true`
- `on`
- `1`