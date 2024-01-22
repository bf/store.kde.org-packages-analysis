

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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

import "../code/logic.js" as Logic

RowLayout {
    id: topBar
    Layout.fillWidth: true
    width: parent.width
    property string icon

    //property int spacing: 3
    property alias query: taskField

    PlasmaComponents3.Label {
        text: {
            if (tomatoid.inPomodoro)
                return i18n("Running pomodoro #") + (tomatoid.completedPomodoros + 1)
            else if (tomatoid.inBreak)
                return i18n("Break time!")

            return ""
        }

        visible: tomatoid.inPomodoro || tomatoid.inBreak
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Tab:
        {
            if (taskField.focus)
                estimatedPomosField.focus = true
            else
                taskField.focus = true
            event.accepted = true
            break
        }
        }
    }

    RowLayout {
        id: addTaskRow
        visible: !tomatoid.inPomodoro && !tomatoid.inBreak
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft


        /*anchors.left: topBar.left
        anchors.right: topBar.right*/
        //        PlasmaCore.ToolTipArea {
        //            id: estimatedPomosToolTip
        //            //target: estimatedPomosField
        //            subText: i18n("The estimation of pomodoros necessary to complete this task")
        //        }
        PlasmaComponents3.Label {
            text: i18n("Est.")
        }
        PlasmaComponents3.SpinBox {
            id: estimatedPomosField
            Layout.fillWidth: false
            // placeholderText: i18n("Est.")
            height: addTaskButton.height
            width: 50
            from: 1
            to: 99

            //            validator: IntValidator {
            //                bottom: 1
            //                top: 99
            //            }
            Keys.onReturnPressed: {
                add()
            }
        }

        PlasmaComponents3.TextField {
            id: taskField
            Layout.fillWidth: true
            placeholderText: i18n("Task Name")
            height: addTaskButton.height

            // 			anchors.leftMargin: topBar.spacing
            // 			anchors.rightMargin: topBar.spacing
            // 			anchors.left: estimatedPomosField.right
            // 			anchors.right: addTaskButton.left
            Keys.onReturnPressed: {
                add()
            }
        }

        PlasmaComponents3.Button {
            id: addTaskButton
            icon.name: "list-add"
            enabled: taskField.text != "" && estimatedPomosField.value > 0

            //anchors.right: addTaskRow.right
            onClicked: {
                add()
                taskField.forceActiveFocus()
            }
        }
    }

    function add() {
        if (taskField.text != "") {
            Logic.newTask(
                        taskField.text,
                        estimatedPomosField.value == "" ? 0 : parseInt(
                                                              estimatedPomosField.value))
            taskField.text = ""
            estimatedPomosField.value = 1
        }
    }
}
