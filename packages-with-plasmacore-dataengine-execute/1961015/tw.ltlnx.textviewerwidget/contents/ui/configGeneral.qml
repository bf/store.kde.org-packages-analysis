import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

ColumnLayout {
    id: appearancePage
    property alias cfg_font_size: font_size.value
    property alias cfg_use_local_file_enabled: use_local_file_enabled.checked
    property alias cfg_show_as_one_line: show_as_one_line.checked
    property alias cfg_url_text: url_text.text
    property alias cfg_text_type: text_type.currentIndex

    GroupBox {
        Layout.fillWidth: true
        title: i18n("Source")
        flat: true
        ColumnLayout {
            width: parent.width
            RowLayout {
                CheckBox {
                    id: use_local_file_enabled
                    text: i18n("Use local file as source")
                    onClicked: use_local_file_enabled.checked ? url_label.text = i18n("Local file:") : url_label.text = i18n("URL:")
                }
            }
            RowLayout {
                Label {
                    id: url_label
                    text: use_local_file_enabled.checked ? i18n("Local file:") : i18n("URL:")
                }
                TextField {
                    id: url_text
                    Layout.fillWidth: true
                    enabled: use_local_file_enabled
                    placeholderText: ""
                }
                Button {
                    visible: use_local_file_enabled.checked
                    text: i18n("Choose")
                    onClicked: filepathDialog.visible = true
                    enabled: use_local_file_enabled
                }
            }
        }
    }
    GroupBox {
        Layout.fillWidth: true
        title: i18n("Text")
        flat: true
        ColumnLayout {
            RowLayout {
                Label {
                    text: i18n("Text type:")
                }
                ComboBox {
                    id: text_type
                    model: [ "Plain text", "Markdown text" ]
                }
            }
            RowLayout {
                Label {
                    font.italic: true
                    text: i18n("Supports plain text and Markdown text.")
                }
            }
            RowLayout {
                Label {
                    text: i18n("Font size:")
                }
                SpinBox {
                    id: font_size
                    maximumValue: 999
                    minimumValue: 1
                }
            }
            RowLayout {
                CheckBox {
                    id: show_as_one_line
                    text: i18n("Show text as one line (useful when placed in a panel)")
                }
            }
        }
    }

    Item {
        // tighten layout
        Layout.fillHeight: true
    }

    FileDialog {
        id: filepathDialog
        title: i18n("Choose text file")
        nameFilters: [ "All files (*)" ]
        onAccepted: {
            url_text.text = fileUrl
        }
        onRejected: {
            console.log("Cancelled")
        }
    }
}
