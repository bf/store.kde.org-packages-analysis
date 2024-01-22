import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    property alias tileEditorView: tileEditorViewLoader.item
	property alias tileEditorViewLoader: tileEditorViewLoader
	property alias tileGrid: tileGrid

	RowLayout {
		anchors.fill: parent
		spacing: 0

		TileGrid {
			id: tileGrid
			Layout.fillWidth: true
			Layout.fillHeight: true

			cellSize: config.cellSize
			cellMargin: config.cellMargin
			cellPushedMargin: config.cellPushedMargin

			tileModel: config.tileModel.value

			onEditTile: tileEditorViewLoader.open(tile)

			onTileModelChanged: saveTileModel.restart()
			Timer {
				id: saveTileModel
				interval: 2000
				onTriggered: config.tileModel.save()
			}
			Item {
                id: stackViewContainer
                anchors.fill: parent
                
                Loader {
                    id: tileEditorViewLoader
                    source: "TileEditorView.qml"
                    visible: false
                    active: false
                    // asynchronous: true
                    function open(tile) {
                        //config.showSearch = true
                        active = true
                        item.open(tile)
                    }
                }
                
                SearchStackView {
                    id: stackView
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    //initialItem: appsView
                }
            }
		}
		
	}

	MouseArea {
		visible: !plasmoid.configuration.tilesLocked && !(plasmoid.location == PlasmaCore.Types.TopEdge || plasmoid.location == PlasmaCore.Types.RightEdge)
		anchors.top: parent.top
		anchors.right: parent.right
		width: units.largeSpacing
		height: units.largeSpacing
		cursorShape: Qt.WhatsThisCursor

		PlasmaCore.ToolTipArea {
			anchors.fill: parent
			icon: "help-hint"
			mainText: i18n("Resize?")
			subText: i18n("Alt + Right Click to resize the menu.")
		}
	}

	MouseArea {
		visible: !plasmoid.configuration.tilesLocked && !(plasmoid.location == PlasmaCore.Types.BottomEdge || plasmoid.location == PlasmaCore.Types.RightEdge)
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: units.largeSpacing
		height: units.largeSpacing
		cursorShape: Qt.WhatsThisCursor

		PlasmaCore.ToolTipArea {
			anchors.fill: parent
			icon: "help-hint"
			mainText: i18n("Resize?")
			subText: i18n("Alt + Right Click to resize the menu.")
		}
	}

	//onClicked: searchView.searchField.forceActiveFocus()
}