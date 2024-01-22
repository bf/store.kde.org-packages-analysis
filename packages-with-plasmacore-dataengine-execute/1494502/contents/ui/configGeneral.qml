import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
  
    property int cfg_favoriteIntegratedMode: plasmoid.configuration.favoriteIntegratedMode


        RadioButton {
            id: favoriteIntel
            Kirigami.FormData.label: i18n("Use integrated mode:")
            text: i18n("Intel only")
            ButtonGroup.group: displayGroup
            property int index: 0
            checked: plasmoid.configuration.favoriteIntegratedMode == index
        }

        RadioButton {
            id: favoriteHybrid
            text: i18n("Hybrid")
            ButtonGroup.group: displayGroup
            property int index: 1
            checked: plasmoid.configuration.favoriteIntegratedMode == index
        }

        ButtonGroup {
            id: displayGroup
            onCheckedButtonChanged: {
                if (checkedButton) {
                    cfg_favoriteIntegratedMode = checkedButton.index
                }
            }
        }
}
 
