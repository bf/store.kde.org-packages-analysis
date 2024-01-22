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
    property string title: plasmoid.configuration.title
    property string url: plasmoid.configuration.geturl
    property string selector: plasmoid.configuration.getselector
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
            var formattedText = stdout.trim()
            root.label = formattedText
        }
    }
    Plasmoid.compactRepresentation: Label{ }
    function getData()
    {
        var cmd = "python3  " + Qt.resolvedUrl("script.py").substring(7) + " " + root.url + " '" + root.selector + "'"
        executable.exec(cmd)
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
