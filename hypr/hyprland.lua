local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "thunar"
local menu = "hyprlauncher"
local browser = "firefox"
local editor = "codium"

local directions = {
    Left = "l",
    Right = "r",
    Up = "u",
    Down = "d"
}

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("quickshell")
end)

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor))

hl.bind("XF86AudioMute", function()
    hl.dispatch(hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
    hl.dispatch(hl.dsp.global("quickshell:updateSound"))
end)

hl.bind("XF86AudioRaiseVolume", function()
    hl.dispatch(hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0"))
    hl.dispatch(hl.dsp.global("quickshell:updateSound"))
end)

hl.bind("XF86AudioLowerVolume", function()
    hl.dispatch(hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
    hl.dispatch(hl.dsp.global("quickshell:updateSound"))
end)

hl.bind("SUPER + ESCAPE", hl.dsp.global("quickshell:powerMenu"))

hl.bind(mainMod .. " + P", hl.dsp.window.fullscreen({ action = "toggle", mode = 0 }))
hl.bind(mainMod .. " + K", hl.dsp.window.close())

hl.bind(mainMod .. " + SHIFT + M", hl.dsp.layout("orientationnext"))

hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "+1" }))
hl.bind("ALT + 1", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "-1" }))

for i = 1, 10 do
    hl.bind(mainMod .. " + " .. i % 10, hl.dsp.focus({ workspace = i }))

    hl.bind(mainMod .. " + SHIFT + " .. i % 10, hl.dsp.window.move({ workspace = i, follow = true }))
end

for key, dir in pairs(directions) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))

    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

hl.layer_rule({
    match = { namespace = "quickshell" },
    blur = true,
    ignore_alpha = 0.2,
})

hl.window_rule({
    match = { class = "kitty" },
    opacity = "0.7 override 0.4 override"
})

hl.window_rule({
    match = { class = "com.visualstudio.CodeOSS" },
    opacity = "0.9 override 0.8 override"
})

hl.config({
    general = {
        layout = "master",
        border_size = 2,
        gaps_in = 5,
        gaps_out = 10,

        col = {
            active_border = "rgba(99123aff)",
            inactive_border = "rgba(99123a66)"
        }
    },

    master = {
        new_status = "slave",
        mfact = 0.60
    },

    input = {
        kb_layout = "de",

        touchpad = {
            natural_scroll = true
        }
    },

    animations = {
        enabled = true
    },

    decoration = {
        rounding = 10,
        rounding_power = 2.0,

        blur = {
            enabled = true,
            size = 6,
            passes = 3,

            new_optimizations = true
        }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.curve("easeOut", {
    type = "bezier",
    points = { { 0.16, 1 }, { 0.3, 1 } }
})

hl.animation({
    leaf = "global",
    enabled = true,
    speed = 2,
    bezier = "easeOut"
})
