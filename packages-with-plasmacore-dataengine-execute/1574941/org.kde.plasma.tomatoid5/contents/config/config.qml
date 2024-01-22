import QtQuick 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "settings-configure"
        source: "config/configGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Time")
        icon: "player-time"
        source: "config/configTimer.qml"
    }
    ConfigCategory {
        name: i18n("Notification")
        icon: "notifications"
        source: "config/configNotification.qml"
    }
    ConfigCategory {
        name: i18n("Actions")
        icon: "new-command-alarm"
        source: "config/configAction.qml"
    }
}
