import QtQuick 2.2
import org.kde.kcoreaddons 1.0 as KCoreAddons
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaComponents.ListItem {
  id: packageItem
  enabled: true

  Item {
    id: packageItemBase

    height: packagenNameLabel.height + fromVersionLabel.height + Math.round(units.gridUnit / 2)

    PlasmaComponents.Label {
      id: packagenNameLabel

      height: paintedHeight
      elide: Text.ElideRight
      text: PackageName
      textFormat: Text.PlainText

      anchors {
        bottom: parent.verticalCenter
        left: parent.left
        leftMargin: Math.round(units.gridUnit / 2)
      }

    }
    PlasmaComponents.Label {
      id: fromVersionLabel

      anchors {
        left: parent.left
        leftMargin: Math.round(units.gridUnit / 2)
        top: packagenNameLabel.bottom
      }

      height: paintedHeight
      elide: Text.ElideRight
      font.pointSize: theme.smallestFont.pointSize
      opacity: 0.6
      text: FromVersion

    }
    PlasmaComponents.Label {
      id: toVersionLabel

      anchors {
        left: fromVersionLabel.right
        leftMargin: Math.round(units.gridUnit / 2)
        top: packagenNameLabel.bottom
      }

      height: paintedHeight
      elide: Text.ElideRight
      font.pointSize: theme.smallestFont.pointSize
      opacity: 0.6
      text: ToVersion

    }


  }

}
