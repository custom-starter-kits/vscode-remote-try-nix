#!/usr/bin/env nix
#! nix develop ../../../. --ignore-env --keep-env-var TERM --keep-env-var HOME --command bash

# ─────────────────────────────────────────────────────────────
# Nix-Shebang Interpreter
# Docs:
# - https://nix.dev/manual/nix/2.29/command-ref/new-cli/nix.html#shebang-interpreter
# - https://nix.dev/manual/nix/2.29/command-ref/new-cli/nix3-env-shell.html#options-that-change-environment-variables

# ─────────────────────────────────────────────────────────────
# Functions

nix__hello_world() {
    cowsay "Nix is awesome!" | lolcat 
}

# ─────────────────────────────────────────────────────────────
# Main Function

main() {
    nix__hello_world
}

main