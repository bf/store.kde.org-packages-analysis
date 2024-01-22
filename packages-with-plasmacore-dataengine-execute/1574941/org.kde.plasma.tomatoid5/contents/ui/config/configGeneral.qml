import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    id: layout
    Layout.fillWidth: true
    Layout.fillHeight: true
    property alias cfg_playTickingSound: play.checked
    property alias cfg_tickingVolume: volume.value
    property alias cfg_continuousMode: continuousMode.checked
    property alias cfg_showTimer: showTimer.checked
    property alias cfg_flatIconTheme: flatIconTheme.checked
    property alias cfg_simpleIconTheme: simpleIconTheme.checked
    ColumnLayout {
        RowLayout {
            PlasmaComponents3.CheckBox {
                id: play
                text: i18n("Play ticking sound")
            }
            PlasmaComponents3.Slider {
                id: volume
                enabled: play.checked
            }
            PlasmaComponents3.Label {
                text: Math.round(volume.value * 100) + "%"
            }
        }
        PlasmaComponents3.CheckBox {
            id: continuousMode
            text: i18n("Start pomodoro automaticaly after break")
        }
        PlasmaComponents3.CheckBox {
            id: showTimer
            text: i18n("Show timer")
        }
        RowLayout {
            PlasmaComponents3.Label {
                text: i18n("Icon theme:")
            }
            ButtonGroup {
                buttons: buttons.children
            }
            RowLayout {
                id: buttons
                spacing: 20
                PlasmaComponents3.RadioButton {
                    id: flatIconTheme
                    text: i18n("Flat")
                }
                PlasmaComponents3.RadioButton {
                    id: simpleIconTheme
                    text: i18n("Simple")
                }
            }
        }
    }
}
