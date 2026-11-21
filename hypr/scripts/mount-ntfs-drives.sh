#!/bin/bash

# UUID разделов NTFS, которые нужно автоматически монтировать.
# Узнать UUID: sudo blkid   (или lsblk -f)
UUIDS=(
    "3270561C7055E6DF"   # File
    "E0F4187FF41859DC"   # Games
    "96DE5998DE59718B"   # Steam
)

is_target() {
    local uuid="$1"
    [[ -z "$uuid" ]] && return 1
    local u
    for u in "${UUIDS[@]}"; do
        [[ "$u" == "$uuid" ]] && return 0
    done
    return 1
}

lsblk -lno NAME,FSTYPE,UUID | while read -r dev fstype uuid; do
    [[ "$fstype" == "ntfs" || "$fstype" == "ntfs3" ]] || continue
    is_target "$uuid" || continue

    dev_path="/dev/$dev"
    if findmnt -S "$dev_path" &>/dev/null; then
        # echo "already mounted: $dev_path (UUID=$uuid)"
        continue
    else
        # echo "mounting: $dev_path (UUID=$uuid)"
        udisksctl mount -b "$dev_path" --no-user-interaction
    fi
done