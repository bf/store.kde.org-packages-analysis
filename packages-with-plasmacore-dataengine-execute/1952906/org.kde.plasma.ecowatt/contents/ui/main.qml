import QtQuick 2.4
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root
    width: PlasmaCore.Units.gridUnit * 10
    height: PlasmaCore.Units.gridUnit * 4
    Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    property string label
    property string thecolor
    property string theicon
    property string title: plasmoid.configuration.title
    property string url: plasmoid.configuration.geturl
    property string selector: plasmoid.configuration.getselector
    property bool kdeNotification: plasmoid.configuration.kdeNotification
    property string normalIcon: plasmoid.configuration.getIconNormal
    property string alertIcon: plasmoid.configuration.getIconAlert
    property string unfoundIcon: plasmoid.configuration.getIconUnfound
    property string threatIcon: plasmoid.configuration.getIconThreat
    property string normalColor: plasmoid.configuration.getColorNormal
    property string alertColor: plasmoid.configuration.getColorAlert
    property string unfoundColor: plasmoid.configuration.getColorUnfound
    property string threatColor: plasmoid.configuration.getColorThreat
    property string alertTitle: plasmoid.configuration.getTitleAlert
    property string alertMsg: plasmoid.configuration.getMsgAlert
    property string threatTitle: plasmoid.configuration.getTitleThreat
    property string threatMsg: plasmoid.configuration.getMsgThreat
    property string errorTitle: plasmoid.configuration.getTitleError
    property string errorMsg: plasmoid.configuration.getMsgError
    property string regexpSearchNormal: plasmoid.configuration.getRegexpSearchNormal
    property string regexpSearchAlert: plasmoid.configuration.getRegexpSearchAlert
    property string regexpSearchThreat: plasmoid.configuration.getRegexpSearchThreat
    
    Component.onCompleted: {
        getData()
    }
    Connections {
        target: plasmoid.configuration
        onGeturlChanged: {
            getData()
        }
        onGetselectorChanged: {
            getData()
        }
        onGetintervalChanged: {
            timer.restart()
        }
    }
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd)
        {
            if (cmd)
            {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    Connections {
        target: executable
        onExited: {
            var responseText = stdout.trim()
            root.label = responseText

            if (responseText == 'normal') {
                root.thecolor = root.normalColor
                root.theicon = plasmoid.file("", root.normalIcon)
            } else if (responseText == 'alert') {
                root.thecolor = root.alertColor
                root.theicon = plasmoid.file("", root.alertIcon)
                if (kdeNotification) {
                    notify(root.alertTitle, root.alertMsg)
                }
            } else if (responseText == 'threat') {
                root.thecolor = root.threatColor
                root.theicon = plasmoid.file("", root.threatIcon)
                if (kdeNotification) {
                    notify(root.threatTitle, root.threatMsg)
                }
            } else if (responseText == 'error') {
                root.thecolor = root.threatColor
                root.theicon = plasmoid.file("", root.threatIcon)
                if (kdeNotification) {
                    notify(root.errorTitle, root.errorMsg)
                }
            } else {
                root.thecolor = root.unfoundColor
                root.theicon = plasmoid.file("", root.unfoundIcon)
            }
        }
    }
    Plasmoid.compactRepresentation: Label{ }
    function getData()
    {
        var cmd = "python3  " + Qt.resolvedUrl("script.py").substring(7) + " " + root.url + " '" + root.selector + "'" + " '" + root.regexpSearchNormal + "'" + " '" + root.regexpSearchAlert + "'" + " '" + root.regexpSearchThreat + "'"
        //console.log("cmd: " + cmd)
        executable.exec(cmd)
    }
    PlasmaCore.DataSource {
        id: notification
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd)
        {
            if (cmd)
            {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    function notify(title, msg) {
        msg = '<span color=\\"#' + root.thecolor + '\\">' + msg +'</span>'
        var cmd = 'zenity --error --title="' + title + '" --window-icon=package-upgrade --height=150 --width=250 --text "' + msg + '"'
        console.log("cmd: " + cmd)
        notification.exec(cmd)
    }
    Timer {
        id: timer
        running: true
        repeat: true
        interval: plasmoid.configuration.getinterval * 60000
        onTriggered: {
            getData()
        }
    }
}
