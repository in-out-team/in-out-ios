#!/bin/sh

curl https://mise.jdx.dev/install.sh | sh

# Installs the version from .mise.toml
mise install

# Runs the version of Tuist indicated in the .mise.toml file
mise x -- tuist generate
