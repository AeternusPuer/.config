#!/bin/bash
findmnt -t ntfs,ntfs3,fuseblk -o TARGET,SOURCE -n | while read -r mountpoint source; do
    if [[ "$mountpoint" == /run/media/* ]]; then
        udisksctl unmount -b "$source" --no-user-interaction
    fi
done