#!/bin/sh

curl https://mise.jdx.dev/install.sh | sh

# Installs the version from .mise.toml
/Users/local/.local/bin/mise install

# Runs the version of Tuist indicated in the .mise.toml file
/Users/local/.local/bin/mise x tuist generate
