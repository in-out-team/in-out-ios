#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
mise install # Installs the version from .mise.toml

echo "mise version: "
~/.local/bin/mise --version

# Runs the version of Tuist indicated in the .mise.toml file
mise x tuist generate
