# !/bin/bash
WOFI_PID=$(pidof wofi)
[ -n "$WOFI_PID" ] && kill "$WOFI_PID" 
wofi --show drun & WOFI_PID=$! 
wait "$WOFI_PID"