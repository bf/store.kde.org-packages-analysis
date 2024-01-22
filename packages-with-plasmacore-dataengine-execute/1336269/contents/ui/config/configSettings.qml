import QtQuick 2.2
import QtQuick.Controls 1.2 as QtControls
import QtQuick.Layouts 1.0 as QtLayouts
import QtQuick.Dialogs 1.0
Item {
    id: settingsPage

    property alias cfg_filename: filename.text    
    
    QtLayouts.RowLayout {
        QtControls.TextField {
            id: filename
        }
                
        QtControls.Button {
            QtLayouts.Layout.alignment: Qt.AlignRight;
            QtLayouts.Layout.rightMargin: 15
            text: i18n("Choose file")
            onClicked: fileDialog.open();
            }                
        }
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {
            filename.text = fileDialog.fileUrl.toString().substring(7)
            fileDialog.close()
        }
        onRejected: {
            fileDialog.close()
        }
    }
}


