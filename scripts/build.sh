#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BR_DIR="${BR_DIR:-$ROOT/.buildroot}"
BR_VERSION="2026.08.1"
if [ ! -d "$BR_DIR" ]; then
  echo "Téléchargement de Buildroot $BR_VERSION"
  curl -fL "https://buildroot.org/downloads/buildroot-$BR_VERSION.tar.xz" -o "$ROOT/buildroot.tar.xz"
  mkdir -p "$BR_DIR"
  tar -xf "$ROOT/buildroot.tar.xz" --strip-components=1 -C "$BR_DIR"
  rm -f "$ROOT/buildroot.tar.xz"
fi
make -C "$BR_DIR" O="$ROOT/output" qemu_aarch64_virt_defconfig
"$ROOT/scripts/configure.py" "$ROOT/output/.config" "$ROOT"
make -C "$BR_DIR" O="$ROOT/output" olddefconfig
make -C "$BR_DIR" O="$ROOT/output" -j"$(nproc)"
echo "Images disponibles dans: $ROOT/output/images"
