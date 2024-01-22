import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    id: layout
    Layout.fillWidth: true
    Layout.fillHeight: true
    property alias cfg_longBreakLength: longBreak.value
    property alias cfg_shortBreakLength: shortBreak.value
    property alias cfg_pomodoroLength: pomodoro.value
    property alias cfg_pomodorosPerLongBreak: cycle.value
    GridLayout {
        columns: 3
        PlasmaComponents3.Label {
            text: i18n("Long break:")
        }
        PlasmaComponents3.SpinBox {
            id: longBreak
            from: 1
            to: 60
        }
        PlasmaComponents3.Label {
            text: longBreak.value === 1 ? i18n("minute") : i18n("minutes")
        }
        PlasmaComponents3.Label {
            text: i18n("Short break:")
        }
        PlasmaComponents3.SpinBox {
            id: shortBreak
            from: 1
            to: 60
        }
        PlasmaComponents3.Label {
            text: shortBreak.value === 1 ? i18n("minute") : i18n("minutes")
        }
        PlasmaComponents3.Label {
            text: i18n("Pomodoro:")
        }
        PlasmaComponents3.SpinBox {
            id: pomodoro
            from: 1
            to: 60
            width: 300
        }
        PlasmaComponents3.Label {
            text: pomodoro.value === 1 ? i18n("minute") : i18n("minutes")
        }
        PlasmaComponents3.Label {
            text: i18n("Cycle:")
        }
        PlasmaComponents3.SpinBox {
            id: cycle
            from: 1
            to: 10
        }
        PlasmaComponents3.Label {
            text: cycle.value === 1 ? i18n("pomodoro") : i18n("pomodoros")
        }
    }
}
