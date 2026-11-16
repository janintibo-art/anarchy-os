#!/usr/bin/env bash
set -euo pipefail
TARGET_DIR="$1"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CC="$ROOT/output/host/bin/aarch64-buildroot-linux-gnu-gcc"
"$CC" -Os -Wall -Wextra -o "$TARGET_DIR/usr/bin/anarchy" "$ROOT/src/anarchy.c"
chmod 755 "$TARGET_DIR/usr/bin/anarchy"

# Garantir le droit d'execution apres extraction depuis ZIP/Termux.
chmod 755 "$TARGET_DIR/usr/bin/anarchy-lab"
