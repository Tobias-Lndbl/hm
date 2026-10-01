#!/usr/bin/env bash
# Create (or inspect) the hibernation swapfile and print the resume_offset that
# nixos/nix_conf/amaterasu/configuration.nix needs.
#
# Root is on ext4, so the kernel cannot find the swapfile by itself: it needs
# boot.resumeDevice (the filesystem) plus resume_offset (the physical block of
# the swapfile's first extent). That offset only exists once the file does,
# which is why this runs before the first nixos-rebuild.
#
# Size is kept byte-identical to swapDevices[].size so NixOS's mkswap-*.service
# sees a correctly sized file and leaves it alone instead of recreating it --
# recreation would move the extents and invalidate resume_offset.
#
#   sudo bash scripts/hibernate-swapfile.sh
#
set -euo pipefail

SWAPFILE=/var/lib/swapfile
SIZE_MIB=34816 # keep in sync with swapDevices[].size in configuration.nix

if [[ $EUID -ne 0 ]]; then
  echo "error: needs root (sudo bash $0)" >&2
  exit 1
fi

want_bytes=$((SIZE_MIB * 1024 * 1024))

if [[ -e $SWAPFILE ]]; then
  have_bytes=$(stat -c %s "$SWAPFILE")
  if [[ $have_bytes -ne $want_bytes ]]; then
    echo "error: $SWAPFILE exists but is $have_bytes bytes, expected $want_bytes." >&2
    echo "       Refusing to touch it. 'swapoff $SWAPFILE && rm $SWAPFILE' first" >&2
    echo "       if you really want it recreated at ${SIZE_MIB} MiB." >&2
    exit 1
  fi
  echo "$SWAPFILE already exists at the expected size, leaving it alone."
else
  free_blocks=$(stat -f -c '%a' /var/lib)
  block_size=$(stat -f -c '%S' /var/lib)
  avail_mib=$((free_blocks * block_size / 1024 / 1024))
  if [[ $avail_mib -lt $((SIZE_MIB + 5120)) ]]; then
    echo "error: only ${avail_mib} MiB free on /, need ${SIZE_MIB} MiB + headroom." >&2
    exit 1
  fi
  echo "Allocating ${SIZE_MIB} MiB at $SWAPFILE ..."
  install -m 600 -o root -g root /dev/null "$SWAPFILE"
  dd if=/dev/zero of="$SWAPFILE" bs=1M count="$SIZE_MIB" status=progress
  mkswap "$SWAPFILE"
fi

# First extent's physical start, in filesystem blocks. filefrag prints it as
# "12345678.." so strip the trailing dots.
offset=$(filefrag -v "$SWAPFILE" | awk '$1 == "0:" { gsub(/\.\./, "", $4); print $4; exit }')

if [[ -z ${offset:-} ]]; then
  echo "error: could not parse an extent offset out of filefrag" >&2
  filefrag -v "$SWAPFILE" >&2
  exit 1
fi

echo
echo "resume_offset=$offset"
echo
echo "Put that in boot.kernelParams in nixos/nix_conf/amaterasu/configuration.nix,"
echo "then rebuild. Verify after rebuilding with:"
echo "  swapon --show && cat /sys/power/resume && cat /sys/power/resume_offset"
