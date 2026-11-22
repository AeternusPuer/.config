#!/bin/bash
# ~/.config/hypr/scripts/unmount-ntfs.sh
exec >>"$HOME/.cache/unmount-ntfs.log" 2>&1
echo "=== $(date) ==="
findmnt -t ntfs,ntfs3,fuseblk -o TARGET,SOURCE -n | while read -r mountpoint source; do
    if [[ "$mountpoint" == /run/media/* ]]; then
        if udisksctl unmount -b "$source" --no-user-interaction; then
            echo "OK   $source ($mountpoint)"
        else
            echo "FAIL $source ($mountpoint) rc=$?"
            # не блокируем выключение, но и не оставляем busy-mount
            sudo -n umount -l "$mountpoint" 2>/dev/null \
                && echo "LAZY $mountpoint" \
                || echo "STILL MOUNTED $mountpoint"
        fi
    fi
done
exit 0