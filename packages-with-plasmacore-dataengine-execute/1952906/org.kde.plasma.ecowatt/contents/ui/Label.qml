import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as Components
Item {
    id: main
    states: [
        State {
            name: "verticalPanel"
            when: plasmoid.formFactor === PlasmaCore.Types.Vertical
            PropertyChanges {
                target: main
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.maximumHeight: contentItem.height
                Layout.minimumHeight: Layout.maximumHeight
            }
            PropertyChanges {
                target: contentItem
                height: labelsGrid.height
                width: main.width
            }
            PropertyChanges {
                target: labelsGrid
                rows: 2
            }
            PropertyChanges {
                target: dataLabel
                height: Math.min(sizehelper.contentHeight, dataLabel.contentHeight)
                width: main.width
                font.pixelSize: Math.min(dataLabel.height, 3 * PlasmaCore.Theme.defaultFont.pixelSize)
                fontSizeMode: Text.HorizontalFit
            }

            PropertyChanges {
                target: titleLabel
                height: Math.max(0.7 * dataLabel.height, minimumPixelSize)
                width: main.width
                fontSizeMode: Text.Fit
                minimumPixelSize: dataLabel.minimumPixelSize
                elide: Text.ElideRight
            }
            PropertyChanges {
                target: sizehelper
                width: main.width
                fontSizeMode: Text.HorizontalFit
                font.pixelSize: 3 * PlasmaCore.Theme.defaultFont.pixelSize
            }
        },
        State {
            name: "other"
            when: plasmoid.formFactor !== PlasmaCore.Types.Vertical
            PropertyChanges {
                target: main
                Layout.fillHeight: false
                Layout.fillWidth: false
                Layout.minimumWidth: PlasmaCore.Units.gridUnit * 3
                Layout.minimumHeight: PlasmaCore.Units.gridUnit * 3
            }
            PropertyChanges {
                target: contentItem
                height: main.height
                width: main.width
            }
            PropertyChanges {
                target: labelsGrid
                rows: 2
            }
            PropertyChanges {
                target: dataLabel
                height: sizehelper.height
                width: main.width
                fontSizeMode: Text.Fit
            }
            PropertyChanges {
                target: titleLabel
                height: 0.7 * dataLabel.height
                width: main.width
                fontSizeMode: Text.Fit
                minimumPixelSize: 1
            }
            PropertyChanges {
                target: sizehelper
                height: 0.59 * main.height
                width: main.width
                fontSizeMode: Text.Fit
                font.pixelSize: 1024
            }
        }
    ]
    Item {
        id: contentItem
        anchors.verticalCenter: main.verticalCenter
        Grid {
            id: labelsGrid
            rows: 1
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter
            flow: Grid.TopToBottom
            columnSpacing: PlasmaCore.Units.smallSpacing
            Components.Label {
                id: titleLabel
                text: '<font color="#' + root.thecolor + '">' + root.title + '</font>'
                font.weight: dataLabel.font.weight
                font.italic: dataLabel.font.italic
                font.pixelSize: 1024
                font.pointSize: -1
                minimumPixelSize: 1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: text.length > 0
            }
            /* label showed
            Components.Label {
                id: dataLabel
                font {
                    family: PlasmaCore.Theme.defaultFont.family
                    weight: PlasmaCore.Theme.defaultFont.weight
                    pixelSize: 1024
                    pointSize: -1
                }
                text: root.label
                minimumPixelSize: 1
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            */
            /* button showed */
            Components.Button {
                id: dataLabel
                icon.name: root.theicon
                onClicked: Qt.openUrlExternally(root.url)
                //visible: root.label == 'ko'
                flat: true
            }
        }
    }
    Components.Label {
        id: sizehelper
        font.family: dataLabel.font.family
        font.weight: dataLabel.font.weight
        font.italic: dataLabel.font.italic
        minimumPixelSize: 1
        visible: false
    }
    FontMetrics {
        id: timeMetrics
        font.family: dataLabel.font.family
        font.weight: dataLabel.font.weight
    }
}
