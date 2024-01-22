import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: layout
    Layout.fillWidth: true
    Layout.fillHeight: true
    property alias cfg_popupNotification: popup.checked
    property alias cfg_kdeNotification: kde.checked
    property alias cfg_noNotification: no.checked
    ColumnLayout {
        RowLayout {
            PlasmaComponents3.CheckBox {
                id: play
                text: i18n("Play notification sound")
            }
        }
        PlasmaExtras.Heading {
            text: i18n("Notification Action")
            level: 4
        }
        ButtonGroup {
            buttons: buttons.children
        }
        ColumnLayout {
            id: buttons
            PlasmaComponents3.RadioButton {
                id: popup
                text: i18n("Popup Tomatoid")
            }
            PlasmaComponents3.RadioButton {
                id: kde
                text: i18n("Standart Plasma Notification")
            }
            PlasmaComponents3.RadioButton {
                id: no
                text: i18n("Do Nothing")
            }
        }
    }
}
