#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMG="$ROOT/output/images/rootfs.ext2"
KERNEL="$ROOT/output/images/Image"
[ -e "$IMG" ] && [ -e "$KERNEL" ] || { echo 'Compile avec scripts/build.sh';exit 1; }
QEMU="$(command -v qemu-system-aarch64 || true)"
[ -n "$QEMU" ] || QEMU="$ROOT/output/host/bin/qemu-system-aarch64"
exec "$QEMU" -M virt -cpu cortex-a57 -smp 2 -m 1024 -nographic \
  -kernel "$KERNEL" -append 'root=/dev/vda console=ttyAMA0' \
  -drive file="$IMG",if=none,format=raw,id=hd0 \
  -device virtio-blk-device,drive=hd0 \
  -netdev user,id=net0 -device virtio-net-device,netdev=net0
