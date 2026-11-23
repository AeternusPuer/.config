hl.on("window.destroy", function(w)
    -- Исключаем Wofi (и Rofi на случай, если используется он) из логики
    if w.class and (w.class:lower() == "wofi" or w.class:lower() == "rofi") then
        return
    end

    local ws = hl.get_active_workspace()

    -- Проверяем, что рабочее пространство существует и опустело
    if ws and ws.is_empty then
        local target
        -- Если ID нечётный (остаток от деления на 2 не равен 0) → на 1
        if ws.id % 2 ~= 0 then
            target = 1
        else
            -- Если ID чётный → на 2
            target = 2
        end
        hl.dispatch(hl.dsp.focus({ workspace = target }))
    end
end)

hl.workspace_rule({ workspace = 1, monitor = "DP-2",    default = true })
hl.workspace_rule({ workspace = 2, monitor = "HDMI-A-1", default = true })
for i = 3, 20 do
    local mon = (i % 2 == 1) and "DP-2" or "HDMI-A-1"
    hl.workspace_rule({ workspace = i, monitor = mon })
end
