import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    color: "transparent"
    implicitHeight: 30

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 10
        left: 10
        right: 10
    }

    RowLayout {
        anchors.fill: parent

        Row {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            spacing: 5
            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    required property var modelData
                    height: workspaces_text.implicitHeight + 10
                    width: height
                    color: modelData.focused ? "#99123a" : "#99141414"
                    radius: height / 2
                    border {
                        color: "#99123a"
                        width: 1
                    }

                    Text {
                        id: workspaces_text
                        text: modelData.name
                        font {
                            pixelSize: 13
                            family: "JetBrains Mono"
                        }
                        color: modelData.focused ? "#141414" : "#99123a"
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Hyprland.dispatch("hl.dsp.focus({workspace = '" + modelData.id + "'})");
                        }
                    }
                }
            }
        }
        
        Rectangle {
            height: time.implicitHeight + 10
            width: 50
            radius: height / 2
            color: "#99141414"
            border {
                color: "#99123a"
                width: 1
            }

            anchors.centerIn: parent

            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }

            Text {
                id: time
                font.pixelSize: 13
                font.family: "JetBrains Mono"
                color: "#99123a"
                anchors.centerIn: parent
                text: Qt.formatDateTime(clock.date, "hh:mm")
            }
        }

        Row {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            spacing: 5

            Rectangle {
                anchors {
                    verticalCenter: parent.verticalCenter
                }

                height: wifi.implicitHeight + 10
                width: wifi.implicitWidth + 20
                color: "#99141414"
                radius: height / 2
                border {
                    width: 1
                    color: "#99123a"
                }

                Text {
                    id: wifi
                    text: "..."
                    anchors.centerIn: parent
                    font.pixelSize: 13
                    font.family: "JetBrains Mono"
                    color: "#99123a"
                }
            }

            Rectangle {
                anchors {
                    verticalCenter: parent.verticalCenter
                }

                height: battery.implicitHeight + 10
                width: 75
                radius: height / 2
                color: "#99141414"

                border {
                    color: "#99123a"
                }

                Text {
                    id: battery
                    anchors.centerIn: parent
                    text: {
                        const battery = UPower.displayDevice.percentage * 100;
                        switch(true) {
                            case (battery > 75):
                                return `\uf240 ${battery}%`;
                            case (battery > 50):
                                return `\uf241 ${battery}%`;
                            case (battery > 25):
                                return `\uf242 ${battery}%`;
                            case (battery > 0):
                                return `\uf243 ${battery}%`;
                        }
                    }
                    font.pixelSize: 13
                    font.family: "JetBrains Mono"
                    color: "#99123a"
                }
            }

            Process {
                id: wifiProcess
                command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || echo ''"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        var ssid = text ? text.trim() : "";
                        wifi.text = ssid.length > 0 ? `\uf1eb ${ssid}` : `\ue654 Disconnected`;
                    }
                }
            }

            Timer {
                interval: 5000
                running: true
                repeat: true
                onTriggered: {
                    wifiProcess.running = false;
                    wifiProcess.running = true;
                }
            }
        }
    }
}