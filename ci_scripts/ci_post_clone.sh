#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
mise install # Installs the version from .mise.toml
export PATH="$HOME/.local/bin:$PATH"

# Runs the version of Tuist indicated in the .mise.toml file
mise x tuist generate
