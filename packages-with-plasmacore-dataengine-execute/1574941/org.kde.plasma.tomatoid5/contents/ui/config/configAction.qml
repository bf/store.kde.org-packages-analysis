import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    id: layout
    Layout.fillWidth: true
    Layout.fillHeight: true
    property alias cfg_actionStartTimer: startTimer.text
    property alias cfg_actionStartBreak: startBreak.text
    property alias cfg_actionEndBreak: endBreak.text
    property alias cfg_actionEndCycle: endCycle.text
    GridLayout {
        columns: 2
        PlasmaComponents3.Label {
            text: i18n("Start Timer:")
        }
        PlasmaComponents3.TextField {
            id: startTimer
        }
        PlasmaComponents3.Label {
            text: i18n("Start Break:")
        }
        PlasmaComponents3.TextField {
            id: startBreak
        }
        PlasmaComponents3.Label {
            text: i18n("End Break:")
        }
        PlasmaComponents3.TextField {
            id: endBreak
        }
        PlasmaComponents3.Label {
            text: i18n("End Cycle:")
        }
        PlasmaComponents3.TextField {
            id: endCycle
        }
    }
}
