#!/bin/sh

curl https://mise.jdx.dev/install.sh | sh

export PATH="$HOME/.local/bin:$PATH"
~/.local/bin/mise --version

# Installs the version from .mise.toml
~/.local/bin/mise install

# Runs the version of Tuist indicated in the .mise.toml file
~/.local/bin/mise x -- tuist generate
