import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
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
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
     Plasmoid.compactRepresentation: Item {
        PlasmaCore.IconItem {
            id: ima
            anchors.fill: parent
            source: "view-catalog"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                openDialog()
            }
        }
        }
     }
     function openDialog() {
         executable.exec("LC_ALL=C knewstuff-dialog")
     }

}
