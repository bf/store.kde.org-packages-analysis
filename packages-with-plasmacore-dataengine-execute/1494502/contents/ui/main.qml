// main.qml
import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0


Item {
    
    id: root 
    property string icon: Qt.resolvedUrl("../image/prime-nvidia.svg")
    property string imageMode: Qt.resolvedUrl("../image/nvidia.svg")
    property bool prime: false
    property string gpuActivated  // Needs translate Hybrid ?
    property string bashPath: Qt.resolvedUrl("switch.sh").replace("file://","")
    property string textPopup: i18n("You will now be prompted to enter the superuser password to switch graphics mode. A few seconds after applying the changes you will be asked to restart. Do you wish to continue?")

    
    
    
    Plasmoid.icon: root.icon

//  TODO: Is it necesary Timer? Prime-select tigger?
//     Component.onCompleted: {
//         checkTimer.start()
//     }
    
    Component.onCompleted: {
        check()
    }
    

    PlasmaCore.DataSource {
        
        id: execdata
        engine: "executable"
        connectedSources: []
        onNewData: {
            //var exitCode = data["exit code"]
            //var exitStatus = data["exit status"]
            var stdout = data["stdout"] //importante
            var stderr = data["stderr"]
            exited(sourceName,/* exitCode, exitStatus, */stdout, stderr)
            disconnectSource(sourceName)
        }
        
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        
        signal exited(string cmd, /*int exitCode, int exitStatus, */string stdout, string stderr)
        }
        
    Connections {
        target: execdata
        onExited: {
            var formattedText = stdout.trim()
            var errorText = stderr
//             console.log ("Bug: ",errorText)
//             console.log ("Read cat: ", formattedText)
            if (!formattedText){
                root.prime = false
                root.imageMode = Qt.resolvedUrl("../image/edit-delete-remove.svg")
            } else {
                root.prime = true
                switch(formattedText) {
                    case "off":
                        root.gpuActivated = "Intel";
                        root.icon = Qt.resolvedUrl("../image/prime-intel.svg")
                        root.imageMode = Qt.resolvedUrl("../image/intel.svg")
                        break;
                    case "on":
                        root.gpuActivated = "Nvidia";
                        root.icon = Qt.resolvedUrl("../image/prime-nvidia.svg")
                        root.imageMode = Qt.resolvedUrl("../image/nvidia.svg")
                        break;
                    case "on-demand":
                        root.gpuActivated = "Hybrid";
                        root.icon = Qt.resolvedUrl("../image/prime-hybrid.svg")
                        root.imageMode = Qt.resolvedUrl("../image/hybrid.svg")
                        break;
                }
            }
        }
    }
        
    PlasmaCore.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName) // cmd finished

        function exec(cmd) {
            connectSource(cmd)
            }
        }

    function check(){
        execdata.exec("/usr/bin/cat /etc/prime-discrete")
    }
    
    function swtichMode(to_gpu){
        exec.exec("/usr/bin/bash " + root.bashPath + " " + to_gpu + " \"" + root.textPopup + "\"")
    }
    
    //TODO: Is it possible paint the icon after the text in the PlasmaComponents3.Button?
    //function iconSwitchButton() {
        //if (root.gpuActivated == "Nvidia"){
            //if (plasmoid.configuration.favoriteIntegratedMode == 1) {
                //return (Qt.resolvedUrl("../image/prime-hybrid.svg"))
            //} else if (plasmoid.configuration.favoriteIntegratedMode == 0) {
                //return (Qt.resolvedUrl("../image/prime-intel.svg"))
            //}
        //} else {
            //return (Qt.resolvedUrl("../image/prime-hybrid.svg"))
        //}
    //}
    
    function changeGpu(){
        if (root.prime) {      
            if (root.gpuActivated == "Nvidia"){
                if (plasmoid.configuration.favoriteIntegratedMode == 1) {
                    swtichMode("on-demand")
                } else if (plasmoid.configuration.favoriteIntegratedMode == 0) {
                    swtichMode("intel")
                }
            } else {
            swtichMode("nvidia")
            }
        }
    }
        
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
        Plasmoid.compactRepresentation: PlasmaCore.IconItem {
            source: root.icon
            active: compactMouse.containsMouse

            MouseArea {
                id: compactMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    plasmoid.expanded = !plasmoid.expanded
                }
            }
        }
    Plasmoid.fullRepresentation: Item {
            Layout.preferredWidth: 400 * PlasmaCore.Units.devicePixelRatio
            Layout.preferredHeight: 400 * PlasmaCore.Units.devicePixelRatio
        ColumnLayout {
            //spacing: 20
            anchors.centerIn: parent
            //width: parent.width
            //Layout.preferredHeight:  parent.height

            Image {
                id: mode_image
                source: root.imageMode
                Layout.alignment: Qt.AlignCenter
                //Layout.preferredWidth: 64
                Layout.preferredHeight: 72
            }
            
            PlasmaComponents3.Label {
                Layout.alignment: Qt.AlignCenter
                text: root.prime ? i18n("%1 currently in use", root.gpuActivated) : i18n("Prime is not woriking")
            }
            PlasmaComponents3.Button {
                Layout.topMargin: 40
                icon.name: "view-refresh-symbolic" // Use iconSwitchButton() if icon after text in the Button
                Layout.alignment: Qt.AlignCenter
                text: i18n("Switch")
                onClicked: changeGpu()
                opacity: root.prime ? 1.0 : 0.3
            }
            
        }
    }
    Plasmoid.toolTipMainText: "Prime Select"
    Plasmoid.toolTipSubText: root.prime ? i18n("%1 currently in use", root.gpuActivated) : i18n("Prime is not woriking")
    
    //Timer {
        //id: checkTimer
        //interval: 10000
        //running: false
        //repeat: true
        //triggeredOnStart: true
        //onTriggered: {
            //check()
        //}
    //}

}
