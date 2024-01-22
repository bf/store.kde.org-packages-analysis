

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
import QtQuick 2.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Layouts 1.1

Item {
    property string stopButtonImage: "media-playback-stop"
    property string playButtonImage: "media-playback-start"
    property string pauseButtonImage: "media-playback-pause"

    property string timeString: Qt.formatTime(new Date(0, 0, 0, 0, 0,
                                                       seconds), "mm:ss")

    property bool running: tomatoid.timer.running
    property int seconds
    property int totalSeconds
    property int iconSize: 22

    signal stopPressed
    signal playPressed
    signal pausePressed
    onTimeStringChanged: {
        progressBar.value = seconds / totalSeconds
    }

    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        id: buttons
        spacing: 3

        //   visible: inPomodoro || inBreak
        PlasmaComponents.ToolButton {
            id: playPauseButton

            //width: iconSize
            //height: iconSize
            iconSource: running ? pauseButtonImage : playButtonImage

            onClicked: {
                if (running) {
                    pausePressed()
                } else {
                    playPressed()
                }

                running = !running
            }
        }

        PlasmaComponents.ToolButton {
            id: stopButton
            iconSource: stopButtonImage

            //             width: iconSize
            //             height: iconSize
            onClicked: {
                stopPressed()
            }
        }
    }

    PlasmaComponents.ProgressBar {
        //: Qt.AlignVCenter
        height: parent.height
        anchors.topMargin: 8
        id: progressBar
        minimumValue: 0
        maximumValue: 1
        value: seconds / totalSeconds

        anchors {
            margins: 4
            left: {
                if (buttons.visible)
                    return buttons.right
                else
                    return parent.left
            }
            right: parent.right
            bottom: parent.bottom
            top: parent.top
        }
    }

    Rectangle {
        id: timerRect
        radius: units.smallSpacing
        implicitWidth: textMetrics.boundingRect.width + units.smallSpacing * 2
        height: textMetrics.boundingRect.height + units.smallSpacing * 2
        color: PlasmaCore.ColorScope.backgroundColor
        border.width: 1
        border.color: PlasmaCore.ColorScope.disabledTextColor
        anchors {
            verticalCenter: progressBar.verticalCenter
            horizontalCenter: progressBar.horizontalCenter
        }
        TextMetrics {
            id: textMetrics
            text: "88:88"
        }

        PlasmaComponents.Label {
            id: counter
            text: timeString
            font.pointSize: 10
            color: PlasmaCore.ColorScope.textColor
            anchors {
                verticalCenter: timerRect.verticalCenter
                left: parent.left
                leftMargin: units.smallSpacing
                right: parent.right
                rightMargin: units.smallSpacing
            }
        }
    }
}
