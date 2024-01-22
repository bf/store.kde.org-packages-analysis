import QtQuick 2.0
import QtQuick.Layouts 1.0 as QtLayouts
import QtQuick.Controls 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: generalPage

    width: childrenRect.width
    height: childrenRect.height

    property alias pollinterval: spinbox.value

    QtLayouts.RowLayout {
        anchors.left: parent.left
        Label {
            text: i18n("Polling interval: ")
        }

        SpinBox {
            id: spinbox

            suffix: i18ncp("Polling interval in minutes", "min", "min", value)
            value: plasmoid.configuration.pollinterval
            minimumValue: 1
            maximumValue: 90
        }
    }
    Component.onCompleted: {
      console.log("loaded configGeneral.qml")
    }
}
