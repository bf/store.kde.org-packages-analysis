import QtQuick 2.1
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrols 2.0 as KQuickControls

Item {
    id: configGeneral
    Layout.fillWidth: true
    property alias cfg_icon: icon.checked
    property string cfg_model: plasmoid.configuration.model
    property var models: ["GE63", "GE73", "GE75", "GL63", "GS63", "GS65", "GS75", "GX63", "GT63", "GT75"]
    Component.onCompleted: {
        console.log("model")
    }

    ColumnLayout {
        PlasmaComponents3.CheckBox {
            id: icon
            text: "Change Icon Color"
        }
        GridLayout {
            columns: 2
            PlasmaComponents3.Label {
                text: i18n("Keyboard model:")
            }
            PlasmaComponents3.ComboBox {
                id: modelsCombo
                model: configGeneral.models
                currentIndex: modelsCombo.model.indexOf(configGeneral.cfg_model)
                onActivated: {
                    cfg_model = currentValue.toString()
                }
            }
        }
    }
}
