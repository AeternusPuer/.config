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
    hl.exec_cmd("~/.config/hypr/scripts/mount-ntfs-drives.sh")
    hl.exec_cmd("~/.azotebg-hyprland")
    hl.exec_cmd("waybar -c ~/.config/waybar/config/DP-2.jsonc -s ~/.config/waybar/styles/DP-2.css")
    hl.exec_cmd("waybar -c ~/.config/waybar/config/HDMI-A-1.jsonc -s ~/.config/waybar/styles/HDMI-A-1.css")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")
end)
----POWEROFF---
hl.on("hyprland.shutdown", function()
    os.execute("~/.config/hypr/scripts/unmount-ntfs.sh")
end)
-- Приложения для исключения
local exceptions = {
    classes = { steam = true,
                vlc = true, 
                obs = true,
                ["org.kde.kdenlive"] = true,},
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
    -- Вычисляем центр окна
    local center_x = win.at.x + win.size.x / 2
    local center_y = win.at.y + win.size.y / 2
    hl.dispatch(hl.dsp.cursor.move({ x = center_x, y = center_y }))
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
    name         = "Thunar_Действия над файлами",
    match        = {
        class = "Thunar|thunar",
        title = "Действия над файлами",
    },
    animation    = "popin",
    stay_focused = false,
    size         = "600 140",
    float        = true,
    -- center убран
    move = "(monitor_w-610) (monitor_h-150)",
})
-- razer
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

-- Vesctop
hl.window_rule({
    name         = "vesktop",
    match        = {
        initial_class = "vesktop",      
    },
    workspace    = "6",
    float        = false,
    animation    = "popin",
    stay_focused = false
})
-- Discord
hl.window_rule({
    name         = "discord",
    match        = {
        initial_class = "discord",      
    },
    workspace    = "6",
    float        = false,
    animation    = "popin",
    stay_focused = false
})
-- OBS
hl.window_rule({
    name         = "obs",
    match        = {
        initial_class = "com.obsproject.Studio",      
    },
    workspace    = "2",
    float        = false,
    animation    = "popin",
    stay_focused = false
})
hl.window_rule({
    name         = "obs-настройки",
    match        = {
        initial_class = "com.obsproject.Studio",      
        initial_title = "Настройки|Менеджер плагинов|Мастер автоматической настройки|Таймер записи и трансляции|Свойства «.*»|Файл изображения"
    },
    workspace    = "2",
    size = "1040 620",
    float        = true,
    center       = true,
    animation    = "popin",
    stay_focused = false
})
hl.window_rule({
    name         = "obs-изображение",
    match        = {
        initial_class = "obs",      
        initial_title = "Файл изображения"
    },
    workspace    = "2",
    size = "1040 620",
    float        = true,
    center       = true,
    animation    = "popin",
    stay_focused = false
})
--Kdenlive
hl.window_rule({
    name         = "Kdenlive",
    match        = {
        class = "org.kde.kdenlive",
	    title = "Kdenlive",
	    initial_class = "org.kde.kdenlive",
	    initial_title = "Kdenlive"
    },
    size = "1040 620",
    float        = true,
    center       = true,
    animation    = "popin",
    stay_focused = false
})

