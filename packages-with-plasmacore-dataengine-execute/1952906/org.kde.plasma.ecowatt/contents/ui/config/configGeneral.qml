import QtQuick 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    Layout.fillWidth: true
    id: formLayout
    property alias cfg_title: label.text
    property alias cfg_geturl: url.text
    property alias cfg_getselector: selector.text
    property alias cfg_getinterval: interval.value
    property alias cfg_kdeNotification: notification.checked
    
    RowLayout {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Title: ")
        
        TextField {
            id: label
        }
        
        Label {
            textFormat: Text.PlainText
            text: i18n(" (optional)")
        }
    }
    
    TextField {
        id: url
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("URL: ")
    }
    TextField {
        id: selector
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("CSS selector: ")
    }
    SpinBox {
        id: interval
        Kirigami.FormData.label: i18n("Update interval: ")
        Layout.fillWidth: true
        textFromValue: function (value) {
            return value + " " + i18n("min")
        }
        valueFromText: function (text) {
            return parseInt(text)
        }
        from: 1
        to: 60
        stepSize: 1
        value: cfg_interval
        onValueChanged: {
            cfg_getinterval = value
        }
    }
    
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Notification")
    }
    
    RowLayout {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Display ? ")
        
        CheckBox {
            id: notification
        }
        
        Label {
            textFormat: Text.PlainText
            text: i18n(" (zenity needed)")
        }
    }
}

