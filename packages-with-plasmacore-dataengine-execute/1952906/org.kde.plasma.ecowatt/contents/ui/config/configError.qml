import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    Layout.fillWidth: true
    id: configError
    property alias cfg_getTitleError: titleError.text
    property alias cfg_getMsgError: msgError.text
    
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Error loading page")
    }

    TextField {
        id: titleError
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Notification title: ")
    }
    TextField {
        id: msgError
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Notification message: ")
    }
}

