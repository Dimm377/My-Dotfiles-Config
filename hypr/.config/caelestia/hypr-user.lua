-- Layar internal laptop: resolusi native dengan refresh rate maksimum
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})

-- Update-safe enhanced gaming toggle.
-- SUPER + SHIFT + G toggles Caelestia Game Mode and power profile.
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/caelestia-game-mode-enhanced"))

-- SUPER + A toggles the focused window between a centered panel and tiled.
hl.bind("SUPER + A", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/hypr-toggle-panel"))

-- Spotify panel in the music special workspace.
hl.window_rule({
    match  = { class = "Spotify" },
    float  = true,
    size   = "(monitor_w*0.7) (monitor_h*0.8)",
    center = true,
})

-- Persistent Kitty dropdown terminal in its own special workspace.
hl.window_rule({
    match     = { class = "dropdown-terminal" },
    workspace = "special:terminal",
    float     = true,
    opacity   = "0.95 override",
})

hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/caelestia-dropdown-terminal"))

-- Autostart hyprpm plugins on Hyprland startup
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")
end)

-- Hyprexpo overview on the currently focused monitor.
if hl.plugin.hyprexpo then
    hl.config({
        plugin = {
            hyprexpo = {
                label_enable = 0,
            },
        },
    })
end

hl.bind("SUPER + TAB", function()
    if hl.plugin.hyprexpo and hl.plugin.hyprexpo.expo then
        hl.plugin.hyprexpo.expo("toggle")
    end
end, {
    description = "Toggle Hyprexpo overview",
})
