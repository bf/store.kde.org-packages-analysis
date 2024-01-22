
import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
  id: itemIcon
  PlasmaCore.IconItem {
      id: itemIconImage
      anchors.fill: parent
      anchors.margins: units.smallSpacing
      source: "package-new"
  }
  
  Badge {
    id: packageBadge
    visible: packageModel.count > 0
    text: packageModel.count
  }

  MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton
      onClicked: {
          if (mouse.button == Qt.MiddleButton) {
              main.action_updateSystem()
          } else {
              plasmoid.expanded = !plasmoid.expanded
          }
      }
  }

}
