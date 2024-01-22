import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami


Kirigami.FormLayout {
    id: pageURLS
    anchors.fill: parent
    
    property alias cfg_urlList: urlList.text
    property alias cfg_browser: browser.text
    
    Text {
        text: i18n("Open URLs with")
        Layout.alignment: Qt.AlignTop
        color: theme.textColor
    }
    
    TextField {
        id: browser
        Layout.fillWidth: true
    }

    Text {
        text: i18n("URLs (one per line)")
        Layout.alignment: Qt.AlignTop
        color: theme.textColor
    }
    
    TextArea {
        id: urlList
        Layout.fillWidth: true
        Layout.minimumWidth: parent.width
        Layout.fillHeight: true
    }
}
