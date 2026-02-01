# Docker Shell Utils for Alpine-based images

This variant contains utilities for Alpine-based Docker images (based on Alpine).

## Usage

You should manually add folder with utils to `PATH` environment variable for correct work.

```shell
docker run -it --rm -v "./$VARIANT:/src/utils" "$VARIANT_IMAGE:latest"
export PATH="/src/utils:$PATH"
```

## List of utils

- `is_debug_enabled.sh` - utility for checking if debug mode is enabled
- `log.sh` - utility for logging
- `replace-or-add.sh` - utility for replacing or adding lines to files
- `smart-apk.sh` - utility for easily installing packages by `apk` command
- `smart-git.sh` - utility for easily working with git repositories
- `to_lower.sh` - utility for converting string to lower case
- `try_parse_boolean.sh` - utility for parsing boolean values from strings

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

### smart-apk.sh

Utility for easily installing packages by `apk` command.

#### Subcommands

- `install real <package> [packages]` - install packages without cache like normal packages
- `install virtual <package> [packages]` - install packages with cache like one virtual package that depends on
  specified packages (more easily for delete in future)
- `full-install` - sinomical with `install real`
- `delete <package> [package]` - delete packages
- `resolve <command> [package]` - check if command is installed and install it if not without any preparations and/or
  cleaning

##### Preparations

- If environment `HTTP_PROXY` is setted then `apk` will use it for http proxy
- If environment `HTTPS_PROXY` is setted then `apk` will use it for https proxy

### smart-git.sh

Utility for easily working with git repositories.

#### Subcommands

- `install` - install git by `smart-apk.sh` utility
- `full-install` - sinomical with `install`
- `configure` - configure git for cloning repositories
- `tag local last` - get last version from tags from local repository
- `tag remote last <url>` - get last version from tags from remote repository. __WARNING__: without `v` prefix
- `tag remote check <url>` - check if remote repository has tags
- `prepare-submodules` - init and download git submodules for local repository
- `clone-only` - clone repository without preparations
- `clone` - clone repository with all preparations

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