#!/bin/bash
DEV=/dev/video0
apps=""
command -v lsof >/dev/null && \
    apps=$(lsof -F c "$DEV" 2>/dev/null | sed -n 's/^c//p' | sort -u | paste -sd, -)
if [ -n "$apps" ]; then
    printf '{"text":"1","tooltip":"Используют: %s","class":"active","alt":"active"}\n' "$apps"
elif fuser "$DEV" >/dev/null 2>&1; then
    echo '{"text":"1","tooltip":"Камера занята (системный процесс или другого пользователя)","class":"active","alt":"active"}'
else
    echo '{"text":"","class":"hidden"}'
fi