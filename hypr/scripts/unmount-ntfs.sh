#!/bin/bash
findmnt -t ntfs,ntfs3,fuseblk -o TARGET,SOURCE -n | while read -r mountpoint source; do
    if [[ "$mountpoint" == /run/media/* ]]; then
        if ! udisksctl unmount -b "$source" --no-user-interaction; then
            sudo -n umount -l "$mountpoint" 2>/dev/null
        fi
    fi
done
exit 0