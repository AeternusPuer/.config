#!/bin/bash
if fuser /dev/video0 > /dev/null 2>&1; then
    echo '{"text": "", "tooltip": "Камера активна", "class": "active", "alt": "active"}'
else
    echo '{"text": "", "tooltip": "Камера выключена", "class": "inactive", "alt": "inactive"}'
fi