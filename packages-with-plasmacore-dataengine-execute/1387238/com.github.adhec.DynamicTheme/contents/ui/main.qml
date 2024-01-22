/*
    Copyright (C) 2011  Martin Gräßlin <mgraesslin@kde.org>
    Copyright (C) 2012  Gregor Taetzner <gregor@freenet.de>
    Copyright (C) 2012  Marco Martin <mart@kde.org>
    Copyright (C) 2013  David Edmundson <davidedmundson@kde.org>
    Copyright (C) 2015  Eike Hein <hein@kde.org>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

import QtGraphicalEffects 1.0

Item {
    id: base
    readonly property bool inPanel: (plasmoid.location === PlasmaCore.Types.TopEdge
                                     || plasmoid.location === PlasmaCore.Types.RightEdge
                                     || plasmoid.location === PlasmaCore.Types.BottomEdge
                                     || plasmoid.location === PlasmaCore.Types.LeftEdge)
    readonly property bool vertical: (plasmoid.formFactor === PlasmaCore.Types.Vertical)

    Plasmoid.switchWidth:  units.gridUnit * 15
    Plasmoid.switchHeight: units.gridUnit * 30

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

    //PlasmaCore.DataSource {
    //    id: timeSource
    //    engine: "time"
    //    connectedSources: ["Local"]
    //    interval: 1000
    //}

    Plasmoid.compactRepresentation: Rectangle{


        function triggerFunction(){
            //var hh = parseInt(Qt.formatTime(timeSource.data["Local"]["DateTime"],"hh"))
            var hh = parseInt(Qt.formatTime(new Date(),"hh"))            
            var index = Math.floor(hh/3) 
            
            if(plasmoid.configuration.listThemes[index] !== plasmoid.configuration.lastTheme || plasmoid.configuration.listThemes[index] === ""){

                var str_command = ""
                var preand = ""
                if(plasmoid.configuration.listWallpaper[index] !== "" && typeof plasmoid.configuration.listWallpaper[index] !== "undefined"){
                    str_command = str_command + "qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = \"org.kde.image\";d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");d.writeConfig(\"Image\", \""+plasmoid.configuration.listWallpaper[index]+"\")}'; kwriteconfig5 --file ~/.config/kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image \""+plasmoid.configuration.listWallpaper[index]+"\""
                    preand = " ; "
                }
                if(plasmoid.configuration.listCommand[index] !== "" && typeof plasmoid.configuration.listCommand[index] !== "undefined"){
                    str_command = str_command + preand
                    str_command =  str_command + plasmoid.configuration.listCommand[index]
                    preand = " ; "
                }
                if(plasmoid.configuration.listThemes[index] !== "" && typeof plasmoid.configuration.listThemes[index] !== "undefined"){
                    str_command = str_command + preand
                    str_command = str_command + "lookandfeeltool --apply " + plasmoid.configuration.listThemes[index]
                }
                //console.log(str_command)
                plasmoid.configuration.lastTheme = plasmoid.configuration.listThemes[index]
                executable.exec(str_command)
            }



        }
        Timer {
        	// @todo time from settings 
            interval: 300000// 1000*60*5; // 5 minutes
            running: plasmoid.configuration.running;
            repeat: true;
            triggeredOnStart: true
            onTriggered: triggerFunction()
        }

        Layout.preferredHeight: 24
        Layout.preferredWidth: 24
        anchors.margins: 0
        Layout.maximumWidth: {
            // @force minimal size
            if (vertical) {
                return 24//units.iconSizeHints.panel;
            } else {
                return 24// TODO: fix from settings
            }
        }

        Layout.maximumHeight: {
            if (vertical) {
                return 24//Math.min(units.iconSizeHints.panel, parent.width) * 1//buttonIcon.aspectRatio;
            } else {
                return 24//units.iconSizeHints.panel;
            }
        }
        color: "transparent"
        Image{
            id: buttonIcon
            x: Math.round(parent.width/2) - 12
            y: Math.round(parent.height/2) - 12
            height: 22
            width:  22
            fillMode: Image.PreserveAspectFit
            source: plasmoid.configuration.running  ? Qt.resolvedUrl("icons/logo.svg") : Qt.resolvedUrl("icons/logooff.svg")
            smooth: true
            visible: false
        }

        ColorOverlay {
            anchors.fill: buttonIcon
            source:       buttonIcon
            color: theme.textColor
        }

        MouseArea {
            id: playArea
            anchors.fill: parent
            onClicked: {
                if( plasmoid.configuration.running ){
                    plasmoid.configuration.running  = false
                    plasmoid.configuration.lastTheme = ""
                }else{
                    plasmoid.configuration.running  = true
                }
            }
        }
    }

    Component.onCompleted: {
        if (plasmoid.hasOwnProperty("activationTogglesExpanded")) {
            plasmoid.activationTogglesExpanded = true
            plasmoid.configuration.lastTheme = ""
            plasmoid.configuration.running = plasmoid.configuration.triggeredOnStart || false
            plasmoid.configuration.triggeredOnStart = plasmoid.configuration.running
        }
    }
} // root
