import QtQuick
import Quickshell

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            property bool modalOpen: false
            color: "transparent"
            screen: modelData
            implicitHeight: modalOpen ? 24 : 1
            anchors {
                top: true
            }

            Text {
                id: clock
                anchors.centerIn: parent
                text: Globals.timeMin
                font {
                    family: Globals.fontFamily
                    pixelSize: Globals.fontSize
                }
            }

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {
                    bar.modalOpen = true;
                }

                onExited: {
                    bar.modalOpen = false;
                }
            }
        }
    }
}
