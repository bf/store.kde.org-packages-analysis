/*
 *    Copyright (C) 2011  Martin Gräßlin <mgraesslin@kde.org>
 *    Copyright (C) 2012  Gregor Taetzner <gregor@freenet.de>
 *    Copyright (C) 2012  Marco Martin <mart@kde.org>
 *    Copyright (C) 2013  David Edmundson <davidedmundson@kde.org>
 *    Copyright (C) 2015  Eike Hein <hein@kde.org>
 *    Copyright (C) 2021 by Mikel Johnson <mikel5764@gmail.com>
 * 
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 * 
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 * 
 *    You should have received a copy of the GNU General Public License along
 *    with this program; if not, write to the Free Software Foundation, Inc.,
 *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0 as PlasmaPlasmoid
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.taskmanager 0.1 as TaskManager
import org.kde.plasma.plasmoid 2.0
import org.kde.draganddrop 2.0 as DnD
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

Item {
    id: kickoff

    readonly property bool inPanel: (plasmoid.location === PlasmaCore.Types.TopEdge
    || plasmoid.location === PlasmaCore.Types.RightEdge
    || plasmoid.location === PlasmaCore.Types.BottomEdge
    || plasmoid.location === PlasmaCore.Types.LeftEdge)
    readonly property bool vertical: (plasmoid.formFactor === PlasmaCore.Types.Vertical)

    property int kickoffWidth:plasmoid.configuration.minimumWidth<500?Screen.width/1.5:plasmoid.configuration.minimumWidth
    property int kickoffHeight:plasmoid.configuration.minimumHeight<500?Screen.height/1.5:plasmoid.configuration.minimumHeight

    PlasmaPlasmoid.Plasmoid.icon: plasmoid.configuration.icon

    Plasmoid.preferredRepresentation:Plasmoid.fullRepresentation
    PlasmaPlasmoid.Plasmoid.fullRepresentation: MouseArea {
        id: compactRoot

        Layout.minimumWidth: {
            if (!inPanel) {
                return PlasmaCore.Units.iconSizeHints.panel;
            }

            if (vertical) {
                return -1;
            } else {
                return Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.height) * buttonIcon.aspectRatio;
            }
        }

        Layout.minimumHeight: {
            if (!inPanel) {
                return PlasmaCore.Units.iconSizeHints.panel;
            }

            if (vertical) {
                return Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.width) * buttonIcon.aspectRatio;
            } else {
                return -1;
            }
        }

        Layout.maximumWidth: {
            if (!inPanel) {
                return -1;
            }

            if (vertical) {
                return PlasmaCore.Units.iconSizeHints.panel;
            } else {
                return Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.height) * buttonIcon.aspectRatio;
            }
        }

        Layout.maximumHeight: {
            if (!inPanel) {
                return -1;
            }

            if (vertical) {
                return Math.min(PlasmaCore.Units.iconSizeHints.panel, parent.width) * buttonIcon.aspectRatio;
            } else {
                return PlasmaCore.Units.iconSizeHints.panel;
            }
        }

        hoverEnabled: true
        onClicked: {//dialog.visible=!dialog.visible
            dialog.visible&plasmoid.configuration.launcherButtonAction?fullRepresentation.keyEnterFunction():dialog.visible=!dialog.visible

        }

        PlasmaPlasmoid.Plasmoid.onActivated:{
            dialog.visible=!dialog.visible;
            dialog.requestActivate()
        }

        //property bool inPanel
        PlasmaCore.Dialog {
            id:dialog
            hideOnWindowDeactivate:true
            visualParent:plasmoid.configuration.x==0 || plasmoid.configuration.y==0?compactRoot:null
            location:plasmoid.location

            x:{if(!(plasmoid.configuration.x==0 || plasmoid.configuration.y==0)){switch (plasmoid.configuration.x) {
                case 1:return 0;
                case 2:return Screen.width/2 - kickoffWidth/2;
                case 3:return Screen.width- kickoffWidth;
            }
            }else{return undefined}}
            y:{if(!(plasmoid.configuration.x==0 || plasmoid.configuration.y==0)){switch (plasmoid.configuration.y) {
                case 1:return 0;
                case 2:return Screen.height/2 - kickoffHeight/2;
                case 3:return Screen.height- kickoffHeight;
            }
            }else{return undefined}}


            mainItem: Item {
                width :kickoffWidth
                height:kickoffHeight
                FullRepresentation {
                    id: fullRepresentation
                    anchors.fill: parent
                }        
            }
        }


        TaskManager.TasksModel {
            id: tasksModel

        }

        PlasmaCore.DataSource {
            id: executable
            engine: "executable"
            connectedSources: []
            onNewData: disconnectSource(sourceName)
            
            function exec(cmd) {
                executable.connectSource(cmd)
            }
        }

        onWheel: {
            var direction =plasmoid.location==PlasmaCore.Types.TopEdge?wheel.angleDelta.y < 0:wheel.angleDelta.y > 0

            if (!dialog.visible)  {
                if (direction) {
                        dialog.visible=true

                } else {
                    if (plasmoid.configuration.scrollingDown === 3)  {
                        executable.exec('qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "ExposeAll"')
                    }
                    if (plasmoid.configuration.scrollingDown === 2)  {
                        tasksModel.requestClose(tasksModel.activeTask);
                    }
                    if (plasmoid.configuration.scrollingDown === 1)  {
                        tasksModel.requestToggleMinimized(tasksModel.activeTask);
                    }
                }
            }else{
                wheel.angleDelta.y > 0?fullRepresentation.keyUpFunction():fullRepresentation.keyDownFunction()
            }
        }


        DropArea {
            id: compactDragArea
            anchors.fill: parent
        }

        Timer {
            id: expandOnDragTimer
            // this is an interaction and not an animation, so we want it as a constant
            interval: 250
            running: compactDragArea.containsDrag
            onTriggered: plasmoid.visible = true
        }

        PlasmaCore.IconItem {
            id: buttonIcon

            readonly property double aspectRatio: (vertical ? implicitHeight / implicitWidth
            : implicitWidth / implicitHeight)

            anchors.fill: parent
            source: plasmoid.icon
            active: parent.containsMouse || compactDragArea.containsDrag
            smooth: true
            roundToIconSize: aspectRatio === 1
        }

        PlasmaCore.ToolTipArea {
            id: root
            anchors.fill: parent

            //icon: plasmoid.icon
            mainText: plasmoid.toolTipMainText
            subText: plasmoid.toolTipSubText
            location: plasmoid.location
            active: !dialog.visible
        }

        PlasmaCore.FrameSvgItem {
            id: expandedItem
            anchors.fill: parent
            imagePath: "widgets/tabbar"
            visible: fromCurrentTheme && opacity > 0
            prefix: {
                var prefix;
                switch (plasmoid.location) {
                    case PlasmaCore.Types.LeftEdge:
                        prefix = "west-active-tab";
                        break;
                    case PlasmaCore.Types.TopEdge:
                        prefix = "north-active-tab";
                        break;
                    case PlasmaCore.Types.RightEdge:
                        prefix = "east-active-tab";
                        break;
                    default:
                        prefix = "south-active-tab";
                }
                if (!hasElementPrefix(prefix)) {
                    prefix = "active-tab";
                }
                return prefix;
            }
            opacity: dialog.visible ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: PlasmaCore.Units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }


    }

    property Item dragSource: null

    Kicker.ProcessRunner {
        id: processRunner;
    }





    function action_menuedit() {
        processRunner.runMenuEditor();
    }

    Component.onCompleted: {

        if (plasmoid.hasOwnProperty("activationTogglesExpanded")) {
            plasmoid.activationTogglesExpanded = true
        }
        if (plasmoid.immutability !== PlasmaCore.Types.SystemImmutable) {
            plasmoid.setAction("menuedit", i18n("Edit Applications..."), "kmenuedit");
        }
    }
} // root
