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
hl.on("hyprland.start", function()
    hl.exec_cmd("~/.azotebg-hyprland")
    hl.exec_cmd("waybar -c ~/.config/waybar/config/DP-2.jsonc -s ~/.config/waybar/styles/DP-2.css")
    hl.exec_cmd("waybar -c ~/.config/waybar/config/HDMI-A-1.jsonc -s ~/.config/waybar/styles/HDMI-A-1.css")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")
end)

-- Приложения для исключения
local exceptions = {
    classes = { steam = true, kitty = false },
    title_patterns = { "^Save", "Dialog" },
    content_types = { game = true },
}

local function is_excluded(win)
    if exceptions.classes[win.class] then
        return true
    end
    for _, pattern in ipairs(exceptions.title_patterns) do
        if win.initial_title and win.initial_title:match(pattern) then
            return true
        end
    end
    if win.content_type and exceptions.content_types[win.content_type] then
        return true
    end
    return false
end
-- Общие правила
hl.on("window.open", function(win)
    if not win.workspace or is_excluded(win) then
        return
    end
    hl.dispatch(hl.dsp.cursor.move_to_corner({ corner = 0, window = win }))
end)

-- Kitty
hl.window_rule({
    name      = "kitty",
    match     = {
        class = terminal,
    },
    monitor   = "DP-2, HDMI-A-1",
    workspace = 4,
    animation = "popin",
    stay_focused = false,
    suppress_event      = "fullscreen maximize",
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
    workspace    = "4",
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
    maximize = false,
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
hl.window_rule({
    name         = "razergenie",
    workspace    = "current",
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





