import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: configGeneral

    property alias cfg_delay: delay.value
    property alias cfg_nvidia: nvidia.text
    property alias cfg_intel: intel.text
    property alias cfg_prime: prime.text
    property alias cfg_size: size.value
        Rectangle {
            
            id: row1col1
            PlasmaComponents.Label {
                text: i18n("Update interval:")
            }
        }
        Rectangle {
            id: row1col2
            width: 460
            SpinBox {
                id: delay
                suffix: i18n(" sec")
                minimumValue: 1
                maximumValue: 128
                x: 310
            }
        }
        
        Rectangle {
            id: row2col1
            y: 50
            PlasmaComponents.Label {
                text: i18n("Nvidia card model:")
            }
        }
        
        Rectangle {
            id: row2col2
            y: 50
            width: 460
            TextField {
                id: nvidia
                width: parent.width
                x: 310
            } 
        }
        
        Rectangle {
            id: row3col1
            y: 100
            PlasmaComponents.Label {
                text: i18n("Intel card model:")
            }
        }
        
        Rectangle {
            id: row3col2
            y: 100
            width: 460
            TextField {
                id: intel
                width: parent.width
                x: 310
            } 
        }
        
        Rectangle {
            id: row4col1
            y: 150
            PlasmaComponents.Label {
                text: i18n("Command prime-select:")
            }
        }
        
        Rectangle {
            id: row4col2
            y: 150
            width: 460
            TextField {
                id: prime
                width: parent.width
                x: 310
            } 
        }
        
        Rectangle {
            
            id: row5col1
            y: 200
            PlasmaComponents.Label {
                text: i18n("Icon size:")
            }
        }
        Rectangle {
            id: row5col2
            y: 200
            width: 460
            SpinBox {
                id: size
                suffix: i18n(" px")
                minimumValue: 16
                maximumValue: 64
                x: 310
            }
        }
        
    
}
