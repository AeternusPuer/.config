---------------------
---- MY PROGRAMS ----
---------------------
-- exec-once = "waybar"
terminal    = "kitty"
fileManager = "thunar"
menu        = "~/.config/wofi/wofi-toggle.sh"
screenlock  = "hyprlock"
pavucontrol = "org.pulseaudio.pavucontrol"
-------------------
---- AUTOSTART ----
-------------------

hl.on("window.open", function(win)
    -- Проверяем, что открылось именно окно kitty на рабочем столе 4
    if win.class == "kitty" and win.workspace and win.workspace.id == 4 then
        -- Перемещаем курсор в левый верхний угол (corner = 0) этого окна
        hl.dispatch(hl.dsp.cursor.move_to_corner({ corner = 0, window = win }))
    end
end)
-- ### Window Rules ###
hl.window_rule({
    name      = "kitty",
    match     = {
        class = terminal,
    },
    monitor   = "DP-2, HDMI-A-1",
    workspace = 4,
    animation = "popin",
    stay_focused = false,
})
-- Wofi на определённом мониторе
hl.window_rule({
    name         = "wofi",
    match        = {
        class = menu,
    },
    monitor      = "DP-2, HDMI-A-1",
    workspace    = "current",
    animation    = "popin",
    stay_focused = true,
    
})

-- Wi-Fi Manager в терминале
hl.window_rule({
    name         = "nwtui",
    match        = {
        initial_title = "Wi-Fi Manager",
        initial_class = "kitty", -- Указываем реальный класс терминала
      
    },
    size               = "1280 720",     
    monitor      = "current",
    workspace    = "current",
    float        = true,
    center       = true,
    animation    = "popin",
    stay_focused = true,
    suppress_event      = "fullscreen maximize", -- заменяет nofullscreenrequest
})
-- Pavucontrol
hl.window_rule({
    name         = "pavucontrol",
    match        = {
        class = pavucontrol,
    },
    size         = "1280 720",
    monitor      = "current",
    workspace    = "current",
    float        = true,
    center       = true,
    animation    = "popin",
    stay_focused = false,
    opacity      = 0.95,
})

-- Thunar
hl.window_rule({
    name         = "Thunar",
    match        = {
        class = "Thunar|thunar",
    },
    animation    = "popin",
    stay_focused = false,
    opacity      = 0.9,
})

-- Thunar переименование
hl.window_rule({
    name         = "Thunar_rename",
    match        = {
        class = "Thunar|thunar",
        title = "^(Переименовать .*)$",
    },
    animation    = "popin",
    stay_focused = true,
    size         = "600 140",
    float        = true,
    center       = true,
})

-- Razergenie    monitor      = "current",
    workspace    = "current",
hl.window_rule({
    name         = "razergenie",
    match        = {
        class = "xyz.z3ntu.razergenie",
    },
    animation    = "popin",
    stay_focused = false,
    opacity      = 0.9,
})
hl.window_rule({
    name         = "DesktopEditors",
    match        = {
        class = "DesktopEditors",
    },
    animation    = "popin",
    stay_focused = false,
    opacity      = 0.9,
})
hl.window_rule({
    name         = "xdg-desktop-portal-gtk",
    match        = {
        class = "xdg-desktop-portal-gtk",
    },
    animation    = "popin",
    stay_focused = false,
    opacity      = 0.9,
})
hl.window_rule({
    name         = "sddm-greeter",
    match        = {
        class = "wlroots",
    },
    animation    = "popin",
    stay_focused = false,
    monitor      = "HDMI-A-1",
})





