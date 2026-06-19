#!/usr/bin/env bash
if ! command -v nvidia-smi &> /dev/null; then
    echo '{"text":"N/A","tooltip":"NVIDIA GPU not found or nvidia-smi not installed"}'
    exit 0
fi
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
if [ -z "$temp" ] || ! [[ "$temp" =~ ^[0-9]+$ ]]; then
    echo '{"text":"N/A","tooltip":"Unable to read GPU temperature"}'
    exit 0
fi
gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null)
gpu_utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)
gpu_memory=$(nvidia-smi --query-gpu=utilization.memory --format=csv,noheader,nounits 2>/dev/null)
power_draw=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader 2>/dev/null)
clock_graphics=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits 2>/dev/null | xargs)
if [ -n "$clock_graphics" ] && [ "$clock_graphics" != "N/A" ] && [ "$clock_graphics" != "[Not Supported]" ]; then
    clock_formatted="${clock_graphics}MHz"
else
    clock_formatted="N/A"
fi
if [ "$temp" -ge 80 ]; then
    icon="󰸇"
    class="critical"
elif [ "$temp" -ge 70 ]; then
    icon="󰔏"
    class="warning"
else
    icon="󰢮"
    class="normal"
fi
tooltip="<span color='#42aaff'><b>${gpu_name}</b></span>\n"
tooltip+="GPU Usage: <span color='#42aaff'>${gpu_utilization}%</span>\n"
tooltip+="Memory Usage: <span color='#42aaff'>${gpu_memory}%</span>\n"
tooltip+="Power Draw: <span color='#42aaff'>${power_draw}</span>"
buff="${icon} ${temp}°C ${clock_graphics}MHz"
echo "{\"text\":\"${buff}\",\"tooltip\":\"${tooltip}\",\"class\":\"${class}\"}"


