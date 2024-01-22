import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.0
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    
    id: root
    property string icon: Qt.resolvedUrl("nvidia.svg")
    property bool stat: false
    property string version: "0.0"
    
    Connections {
        target: plasmoid.configuration
    }
    
    Component.onCompleted: {
        checkTimer.start()
    }
    
    PlasmaCore.DataSource {
        
        id: execcheck
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
    
    PlasmaCore.DataSource {
        
        id: sendnotify
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
    
    PlasmaCore.DataSource {
        
        id: checkversion
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
    
    PlasmaCore.DataSource {
        
        id: switchcard
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
    
    function check(){
    
        execcheck.exec(plasmoid.configuration.prime)
        
    }
    
    function sendNotify(logo, title, msg){
        
        sendnotify.exec("notify-send -i ~/.local/share/plasma/plasmoids/org.kde.plasma.videocard/contents/ui/"+logo+" '"+title+"' '" + msg + "'")
    
    }
    
    function switchCard(){
    
        if(root.stat) {
            switchcard.exec("kdesu prime-select intel");
        } else {
            switchcard.exec("kdesu prime-select nvidia");
        }
        
    }
    
    function nvidiaSettings(){
    
        executable.exec("nvidia-settings")
        
    }
    
    function checkVersion(){
    
        checkversion.exec("nvidia-settings -v")
        
    }
    
    Connections {
        target: switchcard
        onExited: {
            //check();
            if(exitCode == 0){
                if(root.stat == false){
                    sendNotify('nvidia.svg', plasmoid.configuration.nvidia, ' You have selected the ' + plasmoid.configuration.nvidia + ' as the main video card of the system. You must log out to this take effect.')
                } else {
                    sendNotify('intel.svg', plasmoid.configuration.intel, ' You have selected the ' + plasmoid.configuration.intel + ' as the main video card of the system. You must log out to this take effect.')
                }
            }
        }
    }
    
    Connections {
        target: execcheck
        onExited: {
            var formattedText = stdout.trim()
            var errorText = stderr
            if (formattedText == "Driver configured: nvidia") {
                root.icon = Qt.resolvedUrl("nvidia.svg")
                root.stat = true
            } else {
                root.icon = Qt.resolvedUrl("intel.svg")
                root.stat = false
            }
        }
    }
    
    Connections {
        target: checkversion
        onExited: {
            var formattedText = stdout.trim()
            var first = formattedText.search(/version/i)
            var last = formattedText.search(/The/i)
            var version = formattedText.substring(first, last)
            var errorText = stderr
            root.version = version.trim()
        }
    }
    
	
	Item {
        id: tool

        property int preferredTextWidth: units.gridUnit * 20
        Layout.minimumWidth: childrenRect.width + units.gridUnit
        Layout.minimumHeight: childrenRect.height + units.gridUnit
        Layout.maximumWidth: childrenRect.width + units.gridUnit
        Layout.maximumHeight: childrenRect.height + units.gridUnit

        RowLayout {

            anchors {
                left: parent.left
                top: parent.top
                margins: units.gridUnit / 2
            }

            spacing: units.largeSpacing
            Image {
                id: tooltipImage
                source: root.icon
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
            }

            ColumnLayout {
                PlasmaExtras.Heading {
                    id: tooltipMaintext
                    level: 3
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    text: i18n("Prime Render Status")
                    visible: text != ""
                }
                PlasmaComponents.Label {
                    id: tooltipSubtext
                    Layout.fillWidth: true
                    height: undefined
                    wrapMode: Text.WordWrap
                    text: root.stat ? plasmoid.configuration.nvidia + i18n(" currently in use") : plasmoid.configuration.intel + i18n(" currently in use")
                    opacity: root.stat ? 1 : 0.8
                    visible: text != ""
                    maximumLineCount: 8
                }
                PlasmaComponents.Label {
                    id: version
                    Layout.fillWidth: true
                    height: undefined
                    wrapMode: Text.WordWrap
                    text: "Driver " + root.version
                    opacity: .5
                    visible: root.stat
                    maximumLineCount: 8
                }
                PlasmaComponents.ToolButton {
                    iconSource: "view-refresh-symbolic"
                    text: i18n("Switch video card")
                    onClicked: switchCard()
                }
                PlasmaComponents.ToolButton {
                    iconSource: Qt.resolvedUrl("nvdock.png")
                    text: i18n("NVIDIA Settings")
                    onClicked: nvidiaSettings()
                    visible: root.stat
                }
            }
        }
    }
    
    Plasmoid.compactRepresentation: Item {
        PlasmaCore.IconItem {
            id: ima
            width: plasmoid.configuration.size
            height: plasmoid.configuration.size
            anchors.centerIn: parent
            //anchors.topMargin: 6
            //anchors.bottomMargin: 6
            source: root.icon
            //opacity: root.stat ? 1 : 0.7
            //ColorOverlay {
              //  anchors.fill: ima
             //   source: ima
             //   visible: root.stat ? false : true
             //   color: PlasmaCore.ColorScope.textColor
             //   antialiasing: true
             //   opacity: root.stat ? 1 : 0.7
            //}
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
        }
        PlasmaCore.ToolTipArea {
            id: toolTip
            width: parent.width
            height: parent.height
            anchors.fill: parent
            mainItem: tool
            interactive: true
        }

    }
    
    Plasmoid.fullRepresentation: Item {}
    
    Timer {
        id: checkTimer
        interval: plasmoid.configuration.delay * 1000
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            check()
            checkVersion()
        }
    }
    
}
