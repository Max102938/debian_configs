import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import "./modules"

Scope {
    id: root

    signal volumeKeyPressed()

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [defaultSink]
    }

    readonly property real volumeFloat: defaultSink && defaultSink.audio 
        ? defaultSink.audio.volume 
        : 0.0

    readonly property bool isMuted: defaultSink && defaultSink.audio 
        ? defaultSink.audio.muted 
        : false

    property bool showPowerMenu: false
    property bool soundUpdated: false
    property bool showNetworkPanel: true

    GlobalShortcut {
        name: "powerMenu"
        onPressed: {
            root.showPowerMenu = !root.showPowerMenu;
        }
    }

    TopBar {}
    PowerMenu {}
    SoundBar {}

    GlobalShortcut {
        name: "updateSound"
        onPressed: root.volumeKeyPressed()
    }
}