import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "config/configGeneral.qml"
    }
    ConfigCategory {
         name: i18n("Levels")
         icon: "adjustlevels"
         source: "config/configLevels.qml"
    }
    ConfigCategory {
         name: i18n("Error")
         icon: "error"
         source: "config/configError.qml"
    }
}
