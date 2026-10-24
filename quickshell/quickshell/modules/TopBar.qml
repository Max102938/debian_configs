import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

PanelWindow {
    id: rootBar

    color: "transparent"
    
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    Rectangle {
        anchors.fill: parent
        color: "#cc141414"
        height: 30

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: 1
            color: "#99123a"
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 8
                rightMargin: 12
            }
            
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 8

                    Repeater {
                        model: Hyprland.workspaces

                        delegate: Rectangle {
                            width: 38
                            height: 20
                            radius: 6
                            color: modelData.id === Hyprland.focusedWorkspace.id ? "#99123a" : "#1a1a1a"

                            Text {
                                anchors.centerIn: parent
                                text: modelData.id
                                color: modelData.id === Hyprland.focusedWorkspace.id ? "#1a1a1a" : "#99123a"
                                font.bold: modelData.id === Hyprland.focusedWorkspace.id ? true : false
                                font.pixelSize: 14
                                font.family: "FontAwesome"
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
            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter
                spacing: 10

                Text {
                    id: clockText
                    color: "#99123a"
                    font.pixelSize: 14
                    font.bold: true
                    font.family: "FontAwesome"
                }

                Text {
                    id: dateText
                    color: "#99123a"
                    font.pixelSize: 14
                    font.family: "FontAwesome"
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        var currentDate = new Date();

                        clockText.text = currentDate.toLocaleTimeString(Qt.locale(), "HH:mm:ss");
                        dateText.text = currentDate.toLocaleDateString(Qt.locale(), "ddd, MMM d, yyyy");
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    RowLayout {
                        spacing: 4
                        Text {
                            text: ""
                            color: "#99123a"
                            font.pixelSize: 14
                            font.family: "FontAwesome"
                        }
                        Text {
                            id: wifiText
                            text: "Checking..."
                            color: "#99123a"
                            font.pixelSize: 14
                            font.family: "FontAwesome"
                        }
    
                    }

                    RowLayout {
                        spacing: 4
                        Text {
                            text: ""
                            color: "#99123a"
                            font.pixelSize: 14
                            font.family: "FontAwesome"
                        }
                        Text {
                            id: batteryText
                            text: "100%"
                            color: "#99123a"
                            font.pixelSize: 14
                            font.family: "FontAwesome"
                        }
                    }

                    RowLayout {
                        spacing: 4
                        Text {
                            id: volumeIcon
                            text: root.isMuted ? "\uf026" : "\uf028"
                            color: "#99123a"
                            font.pixelSize: 18
                            font.family: "FontAwesome"
                        }
                        Text {
                            id: volumeText
                            text: root.isMuted ? "" : Math.round(root.volumeFloat * 100) + "%"
                            color: "#99123a"
                            font.pixelSize: 14
                            font.family: "FontAwesome"
                        }
                    }

                    // Polls WiFi SSID via nmcli every 5 seconds
                    Process {
                        id: wifiProcess
                        command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || echo ''"]
                        running: true
                        stdout: StdioCollector {
                            onStreamFinished: {
                                var ssid = text ? text.trim() : "";
                                wifiText.text = ssid.length > 0 ? ssid : "Disconnected";
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

                    Process {
                        id: batteryProcess
                        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 'N/A'"]
                        running: true
                        stdout: StdioCollector {
                            onStreamFinished: {
                                var cap = text ? text.trim() : "";
                                batteryText.text = cap !== "N/A" && cap !== "" ? cap + "%" : "No Battery";
                            }
                        }
                    }

                    Timer {
                        interval: 10000
                        running: true
                        repeat: true
                        onTriggered: {
                            batteryProcess.running = false;
                            batteryProcess.running = true;
                        }
                    }
                }
            }
        }
    }
}