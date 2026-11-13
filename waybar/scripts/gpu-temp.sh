#!/usr/bin/env bash
output_json() {
    local text="$1" tooltip="$2" class="$3"
    if command -v jq &>/dev/null; then
        jq -n --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
            '{text: $text, tooltip: $tooltip, class: $class}'
    else
        local t="$text" tp="$tooltip" c="$class"
        t="${t//\\/\\\\}";   t="${t//\"/\\\"}";   t="${t//$'\n'/\\n}"
        tp="${tp//\\/\\\\}"; tp="${tp//\"/\\\"}"; tp="${tp//$'\n'/\\n}"
        c="${c//\\/\\\\}";   c="${c//\"/\\\"}";   c="${c//$'\n'/\\n}"
        printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$t" "$tp" "$c"
    fi
}

if ! command -v nvidia-smi &>/dev/null; then
    output_json "N/A" "NVIDIA GPU not found or nvidia-smi not installed" ""
    exit 0
fi

# --- Температура (в 620.x приходит float: 34.22 → обрезаем до 34) ---
temp_raw=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | xargs)
temp="${temp_raw%%.*}"
if [ -z "$temp" ] || ! [[ "$temp" =~ ^[0-9]+$ ]]; then
    output_json "N/A" "Unable to read GPU temperature (raw='${temp_raw}')" ""
    exit 0
fi

# --- Остальные метрики ---
gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | xargs)
gpu_utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | xargs)
mem_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | xargs)
mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | xargs)
power_draw=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader 2>/dev/null | xargs)
clock_graphics=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits 2>/dev/null | xargs)

# --- Процент занятой видеопамяти ---
mem_pct="N/A"
if [ -n "$mem_used" ] && [ -n "$mem_total" ] && [ "$mem_total" -gt 0 ] 2>/dev/null; then
    mem_pct=$(( mem_used * 100 / mem_total ))
fi

# --- Форматирование частоты ---
if [ -n "$clock_graphics" ] && [ "$clock_graphics" != "N/A" ] && [ "$clock_graphics" != "[Not Supported]" ]; then
    clock_formatted="${clock_graphics}MHz"
else
    clock_formatted="N/A"
fi

# --- Иконка и класс по температуре ---
if [ "$temp" -ge 80 ]; then
    icon="󰸇";  class="critical"
elif [ "$temp" -ge 70 ]; then
    icon="󰔏";  class="warning"
else
    icon="󰢮";  class="normal"
fi

# --- Тултип ---
tooltip="<span color='#42aaff'><b>${gpu_name}</b></span>"$'\n'
tooltip+="GPU Usage: <span color='#42aaff'>${gpu_utilization}%</span>"$'\n'
tooltip+="Memory: <span color='#42aaff'>${mem_used} / ${mem_total} MiB (${mem_pct}%)</span>"$'\n'
tooltip+="Power Draw: <span color='#42aaff'>${power_draw}</span>"$'\n'
tooltip+="Clock: <span color='#42aaff'>${clock_formatted}</span>"

buff="${icon} ${temp}°C ${clock_formatted}"

output_json "$buff" "$tooltip" "$class"