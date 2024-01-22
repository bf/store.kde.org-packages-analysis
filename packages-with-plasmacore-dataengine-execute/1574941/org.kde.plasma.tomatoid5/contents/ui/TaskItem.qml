

/*
 *   Copyright 2013 Arthur Taborda <arthur.hvt@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: taskItem

    property bool done
    property int donePomodoros
    property int estimatedPomodoros
    property string identity
    property string name
    property bool editMode
    property bool active

    property string startIconImage: "media-playback-start"
    property string removeIconImage: "window-close"
    property string completeIconImage: "media-seek-forward"
    property string undoIconImage: "media-seek-backward"

    property int iconSize: 22
    property int margin: 0

    property bool timerRunning: tomatoid.timerActive

    onTimerRunningChanged: {
        if (timerRunning)
            editMode = false
    }

    signal rename(string name)
    signal entered(int index)
    signal taskDone
    signal removed
    signal started
    signal exited

    height: 32
    anchors.leftMargin: margin
    anchors.rightMargin: margin
    width: parent ? parent.width : 0

    function doRename() {
        if (!timerRunning && !done)
            editMode = true

        nameEdit.forceActiveFocus()
    }

    // FIXME
    //PlasmaCore.Theme { id: theme }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            taskItem.entered(index)
        }

        onExited: {
            taskItem.exited(index)
        }

        onDoubleClicked: {
            doRename()
        }

        Item {
            id: row
            width: parent.width
            height: parent.height

            Text {
                text: {
                    var t = "( " + donePomodoros
                    if (estimatedPomodoros > 0)
                        t += "/" + estimatedPomodoros
                    t += " ) " + name
                    return t
                }
                anchors.left: parent.left
                anchors.right: toolBar.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                visible: !editMode
                color: theme.textColor
            }

            PlasmaComponents.TextField {
                id: nameEdit
                text: name
                visible: editMode
                anchors.left: parent.left
                anchors.right: toolBar.left
                anchors.leftMargin: 4
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter

                Keys.onReturnPressed: {
                    if (nameEdit.text != "") {
                        name = nameEdit.text
                        editMode = false
                        rename(name)
                    }
                }
            }

            Row {
                id: toolBar
                spacing: 5
                visible: !timerRunning
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter

                PlasmaComponents.ToolButton {
                    id: completeButton
                    tooltip: done ? i18n("Move to tasks") : i18n("Move to done")
                    iconSource: done ? undoIconImage : completeIconImage /* {
                                                                                    if(!done) return completeIconImage
                                                                                                                                                                                                                        else return undoIconImage
                                                                                                                                                                                                                                                                                                                                                                                                                                                    }*/


                    /*width: iconSize
                    height: iconSize*/
                    enabled: !timerRunning
                    opacity: active * 1

                    onClicked: taskDone()
                }

                PlasmaComponents.ToolButton {
                    id: removeButton
                    tooltip: i18n("Remove")
                    iconSource: removeIconImage


                    /*width: iconSize
                    height: iconSize*/
                    opacity: active * 1

                    onClicked: removed()
                }

                PlasmaComponents.ToolButton {
                    id: startButton
                    tooltip: i18n("Start")
                    visible: !done
                    iconSource: startIconImage
                    opacity: active * 1

                    /*height: iconSize*/
                    onClicked: started()
                }
            }
        }
    }
}
