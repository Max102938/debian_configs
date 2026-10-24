import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

PanelWindow {
    id: rootSound

    color: "transparent"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 30
    implicitWidth: 500

    mask: Region { item: root.soundUpdated ? soundBanner : null }

    Rectangle {
        id: soundBanner
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: 30
        width: 500
        color: "#88141414"
        border.width: 2
        border.color: "#99123a"
        radius: 15

        MouseArea {
            id: soundMouse
            anchors.fill: parent
            hoverEnabled: true
        }

        anchors.bottomMargin: root.soundUpdated ? 8 : -40

        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 20
            }
            font.family: FontAwesome
            font.pixelSize: 24
            text: root.isMuted ? "\uf026" : "\uf028"
            color: "#99123a"
        }

        Rectangle {
            id: volume

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 50
            }

            width: 400 * root.volumeFloat
            height: 4
            radius: 2
            color: "#99123a"
        }

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 10
            }
            font.family: FontAwesome
            font.pixelSize: 14
            text: Math.round(root.volumeFloat * 100) + "%"
            color: "#99123a"
        }

        Timer {
            id: soundTimer
            interval: 1500
            repeat: false

            onTriggered: {
                if (soundMouse.containsMouse) {
                    soundTimer.start();
                } else {
                    root.soundUpdated = false;
                }
            }
        }

        Connections {
            target: root
            function onVolumeKeyPressed() {
                if (!root.soundUpdated) {
                    root.soundUpdated = true;
                    soundTimer.start();
                } else {
                    soundTimer.restart();
                }
            }
        }
    }
}