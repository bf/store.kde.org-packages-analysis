import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    Layout.fillWidth: true
    id: configLevels
    property alias cfg_getColorNormal: colorNormal.text
    property alias cfg_getColorAlert: colorAlert.text
    property alias cfg_getColorThreat: colorThreat.text
    property alias cfg_getColorUnfound: colorUnfound.text
    property alias cfg_getIconNormal: iconNormal.text
    property alias cfg_getIconAlert: iconAlert.text
    property alias cfg_getIconThreat: iconThreat.text
    property alias cfg_getIconUnfound: iconUnfound.text
    property alias cfg_getTitleAlert: titleAlert.text
    property alias cfg_getMsgAlert: msgAlert.text
    property alias cfg_getTitleThreat: titleThreat.text
    property alias cfg_getMsgThreat: msgThreat.text
    property alias cfg_getRegexpSearchNormal: regexpNormal.text
    property alias cfg_getRegexpSearchAlert: regexpAlert.text
    property alias cfg_getRegexpSearchThreat: regexpThreat.text
        
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Normal level")
    }
    
    TextField {
        id: colorNormal
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Color: ")
    }
    TextField {
        id: iconNormal
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Icon: ")
    }
    TextField {
        id: regexpNormal
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Search regexp: ")
    }

    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Alert level")
    }

    TextField {
        id: colorAlert
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Color: ")
    }
    TextField {
        id: iconAlert
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Icon: ")
    }
    TextField {
        id: titleAlert
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Notification title: ")
    }
    TextField {
        id: msgAlert
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Notification message: ")
    }
    TextField {
        id: regexpAlert
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Search regexp: ")
    }
    
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Threat level")
    }
    
    TextField {
        id: colorThreat
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Color: ")
    }
    TextField {
        id: iconThreat
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Icon: ")
    }
    TextField {
        id: titleThreat
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Notification title: ")
    }
    TextField {
        id: msgThreat
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Notification message: ")
    }
    TextField {
        id: regexpThreat
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Search regexp: ")
    }
   
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Unfound content")
    }

    TextField {
        id: colorUnfound
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Color: ")
    }
    TextField {
        id: iconUnfound
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Icon: ")
    }
}

