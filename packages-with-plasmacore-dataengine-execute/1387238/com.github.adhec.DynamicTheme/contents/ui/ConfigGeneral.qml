import QtQuick 2.5
import QtQuick.Controls 2.2 as QtControls
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import QtQuick.Dialogs 1.2



Item {

    id: root
    anchors.fill: parent
    property variant listThemes;
    property string selectTheme: ""
    property int selectIdx: -1
    property var cfg_listThemes: plasmoid.configuration.listThemes
    property var cfg_listWallpaper: plasmoid.configuration.listWallpaper
    property var cfg_listCommand: plasmoid.configuration.listCommand
    property var cfg_listHours: plasmoid.configuration.listHours
    property alias cfg_triggeredOnStart: triggeredOnStart.checked

    ListModel {
        id: myModel
    }

    ListModel {
        id: listOptions
    }

    function updateView(){
        listOptions.clear()
        var t_theme = ""
        var t_wall = ""
        var t_comm = ""
        for (var i = 0; i < cfg_listThemes.length; i++){
            t_theme = cfg_listThemes[i] ? cfg_listThemes[i] : ""
            t_wall =  cfg_listWallpaper[i] ?  cfg_listWallpaper[i] : ""
            t_comm =  cfg_listCommand[i] ?  cfg_listCommand[i] : ""
            listOptions.append({name: t_theme, wallpaper: t_wall, comm: t_comm})
        }
        listAll.currentIndex = -1
        gridOptions.currentIndex = -1
        selectTheme = ""
        selectIdx = -1
    }
    function changeTheme(idx,val){
        cfg_listThemes[idx] = val
        cfg_listThemes = cfg_listThemes
        //@todo detect apply changes
        plasmoid.configuration.running  = false
        plasmoid.configuration.lastTheme = ""
    }
    function changeWallpaper(idx,val){
        cfg_listWallpaper[idx] = val
        cfg_listWallpaper = cfg_listWallpaper
        //@todo detect apply changes
        plasmoid.configuration.running  = false
        plasmoid.configuration.lastTheme = ""
    }
    function changeCommand(idx,val){
        cfg_listCommand[idx] = val
        cfg_listCommand = cfg_listCommand
        //@todo detect apply changes
        plasmoid.configuration.running  = false
        plasmoid.configuration.lastTheme = ""
    }

    RowLayout{
        id: mainColumn
        anchors.fill: parent
        width: units.gridUnit * 50
        spacing: units.largeSpacing
        ColumnLayout{

            RowLayout{
                spacing: units.smallSpacing
                QtControls.CheckBox{
                    id: triggeredOnStart
                    text:  "Triggered on start"
                }

            }

            id: leftSide
            Layout.alignment: Qt.AlignTop
            Row{
                spacing: units.largeSpacing
                Item{   width: units.gridUnit *  8 ; height: 32; QtControls.Label {  text: qsTr(""); anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter; }  }
                Item{   width: units.gridUnit * 10 ; height: 32; QtControls.Label {  text: qsTr("Global theme"); anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter; }  }
                Item{   width: units.gridUnit * 10 ; height: 32; QtControls.Label {  text: qsTr("Wallpaper"); anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter; }  }
                Item{   width: units.gridUnit * 10 ; height: 32; QtControls.Label {  text: qsTr("Command"); anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter; }  }

            }

            ListView {
                id: gridOptions
                Layout.preferredHeight: listOptions.count * (units.gridUnit *2+units.smallSpacing)
                Layout.preferredWidth:  parent.width
                spacing: units.smallSpacing
                focus: true
                highlight: Rectangle { color: theme.highlightColor ; radius: 2; opacity: 0.5}
                highlightMoveDuration: 0
                highlightMoveVelocity: 1
                delegate:  Rectangle {
                    id: itemOption
                    width: units.gridUnit * 38 + units.largeSpacing * 3
                    height: units.gridUnit * 2
                    color: "transparent"
                    property alias text: iTheme.text
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            gridOptions.currentIndex = index
                            root.selectIdx = index
                        }
                    }
                    RowLayout{
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.left: parent.left;
                        spacing: units.largeSpacing

                        Rectangle{
                            color: index > 1 && index < 6 ?  "transparent"  :  theme.highlightColor;
                            opacity: index > 1 && index < 6 ?  1  :  0.7;
                            width: units.gridUnit * 8 ;
                            height: 32;
                            QtControls.Label {  text: cfg_listHours[index]; anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter; }  }

                        Row{
                            Layout.preferredWidth: units.gridUnit * 10
                            QtControls.TextField { id: iTheme ; width: parent.width; text: name; anchors.verticalCenter: parent.verticalCenter;
                                onFocusChanged: {if(focus === true) { root.selectIdx = index; gridOptions.currentIndex = index; focus = true;}}
                                onTextEdited: { changeTheme(index,text)}
                            }
                        }
                        Row{
                            Layout.preferredWidth: units.gridUnit * 10
                            QtControls.TextField { width: parent.width * 0.9 ; text: wallpaper;anchors.verticalCenter: parent.verticalCenter;
                                onFocusChanged: {if(focus === true) {root.selectIdx = index; gridOptions.currentIndex = index; focus = true;}}
                                onTextEdited: { changeWallpaper(index,text)} }
                            PlasmaComponents.Button{
                                iconSource: "document-open-folder"
                                onClicked: { root.selectIdx = index; fileDialog.open()}
                                anchors.verticalCenter: parent.verticalCenter;
                            }
                        }
                        Row{
                            Layout.preferredWidth: units.gridUnit * 10
                            QtControls.TextField { width: parent.width ; text: comm;anchors.verticalCenter: parent.verticalCenter;
                                onFocusChanged: {if(focus === true) {root.selectIdx = index; gridOptions.currentIndex = index; focus = true;}}
                                onTextEdited: { changeCommand(index,text)}}
                        }


                    }
                }
            }
        }

        PlasmaComponents.Button{
            id: buttonIcon
            iconSource: "go-previous"
            anchors.verticalCenter: leftSide.verticalCenter
            onClicked: {
                if(root.selectIdx !== -1 && root.selectTheme !== ""){
                    gridOptions.currentItem.text = root.selectTheme
                    changeTheme(root.selectIdx,root.selectTheme)
                }
            }
        }

        ColumnLayout{
            Layout.preferredWidth: units.gridUnit * 12
            Layout.preferredHeight: leftSide.height
            Layout.alignment: Qt.AlignTop
            Item{
                width: units.gridUnit *  8 ; height: 32;
                QtControls.Label {
                    text: qsTr("List Themes"); anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter;
                }
            }
            QtControls.ScrollView {
                id: themesView
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: units.gridUnit * 12
                Layout.preferredHeight: leftSide.height

                GridView {
                    id: listAll
                    model: myModel
                    cellWidth: units.gridUnit * 10
                    cellHeight: 30
                    focus: true
                    delegate:  Item {
                        width: units.gridUnit * 9
                        height: 30
                        QtControls.Label {
                            id: lb;
                            anchors.verticalCenter: parent.verticalCenter;
                            anchors.leftMargin: units.gridUnit
                            text: name
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                listAll.currentIndex = index
                                root.selectTheme = name
                            }
                        }
                    }
                    highlight: Rectangle { color: theme.highlightColor ; radius: 2; opacity: 0.5}
                    highlightMoveDuration: 0

                }
            }
        }
        Item{
            Layout.fillWidth: true
        }
    }

    FileDialog {
        id: fileDialog
        selectMultiple : false
        title: "Open image"
        nameFilters: [ "Image files (*.jpg *.jpeg *.png *.svg)", "All files (*)" ]
        onAccepted: {
            changeWallpaper(root.selectIdx,fileDialog.fileUrls[0])
            updateView()
        }
    }


    Connections {
        target: executable
        onExited: {
            listThemes = stdout.split('\n')
            for (var i = 0; i < listThemes.length; i++){
                myModel.append({name: listThemes[i]})
            }
            updateView()
            listAll.currentIndex = -1
            gridOptions.model = listOptions
            gridOptions.currentIndex = 0
            root.selectIdx = 0
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
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    Component.onCompleted: {
        executable.exec("lookandfeeltool -l")
    }
}
