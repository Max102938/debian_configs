import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

PanelWindow {
    id: rootPower
    visible: root.showPowerMenu

    color: "transparent"

    anchors{
        top: true
        bottom: true
        left: true
        right: true
    }

    implicitHeight: 135
    implicitWidth: 160

    Rectangle {
        anchors.fill: parent
        color: "#88000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.showPowerMenu = false
        }

         Rectangle {
            anchors.centerIn: parent
            width: 160
            height: 135
            color: "#141414"
            border.color: "#99123a"
            border.width: 2
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Power Menu"
                    color: "#99123a"
                    font.bold: true
                    font.pixelSize: 13
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 28
                    radius: 4
                    color: logoutMouse.containsMouse ? "#99123a" : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        spacing: 8
                        Text { text: ""; color: logoutMouse.containsMouse ? "#141414" : "#99123a"; font.family: "FontAwesome" }
                        Text { text: "Log Out"; color: logoutMouse.containsMouse ? "#141414" : "#99123a" }
                    }
                        
                    MouseArea {
                        id: logoutMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: { root.showPowerMenu = false; logoutProcess.running = true; }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 28
                    radius: 4
                    color: shutdownMouse.containsMouse ? "#99123a" : "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        spacing: 12
                        Text { text: ""; color: shutdownMouse.containsMouse ? "#141414" : "#99123a"; font.family: "FontAwesome" }
                        Text { text: "Shutdown"; color: shutdownMouse.containsMouse ? "#141414" : "#99123a" }
                    }

                    MouseArea {
                        id: shutdownMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: { root.showPowerMenu = false; shutdownProcess.running = true; }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 28
                    radius: 4
                    color: rebootMouse.containsMouse ? "#99123a" : "transparent"
                        
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        spacing: 8
                        Text { text: ""; color: rebootMouse.containsMouse ? "#141414" : "#99123a"; font.family: "FontAwesome" }
                        Text { text: "Reboot"; color: rebootMouse.containsMouse ? "#141414" : "#99123a" }
                    }
                    
                    MouseArea {
                        id: rebootMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: { root.showPowerMenu = false; rebootProcess.running = true; }
                    }
                }
            }
        }
    }
    Process { id: logoutProcess; command: ["hyprctl", "dispatch", "exit"] }
    Process { id: shutdownProcess; command: ["systemctl", "poweroff"] }
    Process { id: rebootProcess; command: ["systemctl", "reboot"] }
}
