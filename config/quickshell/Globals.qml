pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property string fontFamily: "JetBrainsMono NerdFont"
    readonly property int fontSize: 16

    readonly property string timeMin: Qt.formatDateTime(clock.date, "hh:mm")
    readonly property string timeSec: Qt.formatDateTime(clock.date, "hh:mm:ss")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
