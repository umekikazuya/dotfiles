#!/usr/bin/env bash
#
# Dotfiles bootstrap is managed by mise.

set -euo pipefail

exec mise bootstrap --only dotfiles --yes "$@"
