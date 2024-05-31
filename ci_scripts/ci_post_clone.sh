#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
mise install # Installs the version from .mise.toml

echo "eval \"\$(/Users/local/.local/bin/mise activate zsh)\"" >> "/Users/local/.zshrc"

# Runs the version of Tuist indicated in the .mise.toml file
mise x tuist generate
