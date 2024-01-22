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

    TextField {
        id: label
        Kirigami.FormData.label: "Title (optional): "
      Layout.fillWidth: true
    }
    TextField {
        id: url
        Layout.fillWidth: true
        Kirigami.FormData.label: "URL: "
    }
    TextField {
        id: selector
        Layout.fillWidth: true
        Kirigami.FormData.label: "Selector: "
    }
    SpinBox {
        id: interval
        Kirigami.FormData.label: "Update interval: "
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

}

