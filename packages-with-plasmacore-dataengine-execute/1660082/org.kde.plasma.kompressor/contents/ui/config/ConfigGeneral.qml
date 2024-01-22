import QtQuick 2.4
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.7 as Kirigami

ColumnLayout {
    Layout.fillWidth: true
    property string cfg_postfix: plasmoid.configuration.postfix
    property int cfg_quality: plasmoid.configuration.quality
    property alias cfg_exif: exif.checked

    Kirigami.FormLayout {
        Layout.alignment: Qt.AlignTop
        QQC2.TextField {
            placeholderText: i18n("Postfix for compressed files. If empty, replace source!")
            Kirigami.FormData.label: i18n("Postfix")
            text: cfg_postfix
            onTextChanged: {
                cfg_postfix = text
            }
        }
        QQC2.SpinBox {
            editable: true
            id: quality
            from: 0
            to: 100
            value: cfg_quality
            stepSize: 1
            Kirigami.FormData.label: i18n("Quality")
            inputMethodHints: Qt.ImhDigitsOnly
            textFromValue: function (value) {
                return value + "%"
            }
            valueFromText: function (text) {
                return parseInt(text)
            }

            onValueModified: {
                cfg_quality = quality.value
            }
        }
        QQC2.Switch {
            id: exif
            //  checked: root.exif
            text: i18n("Keep exif")
            onCheckedChanged: {
                cfg_exif = exif.checked
            }
        }
    }
}
