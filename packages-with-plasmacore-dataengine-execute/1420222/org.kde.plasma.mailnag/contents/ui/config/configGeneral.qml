import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0

Item {
    id: configGeneral
    Layout.fillWidth: true
    property alias cfg_updateInterval: updateIntervalSpinBox.value
    property bool cfg_notification: plasmoid.configuration.notification
    property bool cfg_sound: plasmoid.configuration.sound
    GridLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        columns: 2

        Label {
            text: i18n("Update interval")
        }
        SpinBox {
            id: updateIntervalSpinBox
            decimals: 1
            stepSize: 0.5
            minimumValue: 0.5
            suffix: i18n("min")
        }

        Label {
            text: i18n("Show notification")
        }
        CheckBox {
            id: notif
            checked: cfg_notification
            onClicked: {
                cfg_notification = checked
            }
        }
        Label {
            visible: notif.checked
            text: i18n("Play sound")
        }
        CheckBox {
            visible: notif.checked
            checked: cfg_sound
            onClicked: {
                cfg_sound = checked
            }
        }
    }
}
