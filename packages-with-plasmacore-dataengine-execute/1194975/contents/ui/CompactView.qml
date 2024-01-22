import QtQuick 2.15
import QtQuick.Layouts 1.13
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import 'controls'
import 'helpers'

ListView {
    id: root
    clip: true
    orientation: ListView.Horizontal

    readonly property bool rightJustify: Plasmoid.configuration.rightJustify
    layoutDirection: rightJustify
                     ? Qt.RightToLeft
                     : Qt.LeftToRight

    Component.onCompleted: {
        // At plasmoid start, if connected, we will have already missed connection signals
        // as the Loader is dynamic, so reset explicitly on create...
        if (mcws.isConnected) {
            reset(mcws.getPlayingZoneIndex())
        }
        // ...and wait before enabling the signals from mcws
        event.queueCall(500, () => conn.enabled = true)
    }

    readonly property bool imageIndicator: Plasmoid.configuration.useImageIndicator
    readonly property bool scrollText:     Plasmoid.configuration.scrollTrack

    property int pointSize: Math.floor(height * 0.25)
    property int indHeight: Math.round(height * .8)
    property int itemWidth: Math.round(parent.width / Math.max(mcws.zoneModel.count, 2))

    function reset(zonendx) {
        event.queueCall(() => {
            root.model = mcws.zoneModel
            root.currentIndex = zonendx
        })
    }

    function zoneWheeled(up) {
        // if plasmoid showing or only one zone, don't scroll
        if (!Plasmoid.expanded || root.count === 1) return

        // scrolling up is down when justify right
        if (rightJustify) up = !up

        // at end
        if (currentIndex === root.count-1) {
            currentIndex = up ? 0 : currentIndex-1
        // at beginning
        } else if (currentIndex === 0) {
            currentIndex = up ? 1 : root.count-1
        } else {
            currentIndex = up ? currentIndex+1 : currentIndex-1
        }
        zoneClicked(currentIndex)
    }

    signal zoneClicked(int zonendx)

    Connections {
        id: conn
        target: mcws
        enabled: false
        onConnectionStart: root.model = ''
        onConnectionReady: reset(zonendx)
    }

    component TrackLabel: Marquee {
        align: rightJustify ? Text.AlignRight : Text.AlignLeft
        Layout.alignment: rightJustify ? Qt.AlignRight : Qt.AlignLeft
        elide: Text.ElideRight
        implicitWidth: tt.width

        onTextChanged: {
            // wait the default fade duration
            event.queueCall(fadeDuration, () => {
                if (scrollText && playingnowtracks > 0)
                    restart()
            })
        }

        MouseAreaEx {
            onClicked: root.zoneClicked(index)
        }
    }

    delegate: RowLayout {
        height: root.height
        width: itemWidth
        spacing: PlasmaCore.Units.smallSpacing

        function zoneHovered(hovered) {
            if (!hovered) {
                Plasmoid.toolTipSubText = qsTr('%1 Playback Zone(s)'.arg(mcws.zoneModel.count))
            } else {
                Plasmoid.toolTipSubText =
                        zonename + (model.state !== PlayerState.Stopped
                           ? ' (%1)'.arg(positiondisplay.replace(/ /g, ''))
                           : '')
            }
        }

        // spacer
        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: PlasmaCore.Theme.disabledTextColor
            opacity: !rightJustify && index > 0
        }

        // playback indicator
        Item {
            implicitHeight: indHeight
            implicitWidth: indHeight
            Layout.alignment: Qt.AlignVCenter
            visible: playingnowtracks > 0

            Component {
                id: iconComp
                PlasmaCore.IconItem {
                    anchors.fill: parent
                    source: 'media-playback-start'
                }
            }

            Component {
                id: imgComp

                ShadowImage {
                    anchors.fill: parent
                    sourceKey: filekey
                    imageUtils: mcws.imageUtils
                    thumbnail: true
                    shadow.size: PlasmaCore.Units.smallSpacing
                }
            }

            Loader {
                anchors.fill: parent
                active: playingnowtracks > 0
                        && model.state !== PlayerState.Stopped
                sourceComponent: imageIndicator ? imgComp : iconComp

                FadeBehavior on active {}
            }

            MouseAreaEx {
                onClicked: root.zoneClicked(index)

                onContainsMouseChanged: zoneHovered(containsMouse)

                onWheel: {
                    root.zoneWheeled(wheel.angleDelta.y > 0)
                }
            }
        }

        // track text
        Item {
            id: tt
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                spacing: 0

                TextMetrics {
                    id: tm1
                    text: playingnowtracks > 0
                          ? name : '<empty playlist>'
                    font.pointSize: pointSize
                    elide: Text.ElideRight
                }

                TextMetrics {
                    id: tm2
                    text: playingnowtracks > 0
                          ? artist : zonename
                    font.pointSize: Math.floor(pointSize * .85)
                    elide: Text.ElideRight
                }

                // track
                TrackLabel {
                    id: t1
                    text: tm1.text
                    fontSize: tm1.font.pointSize
                }

                // artist
                TrackLabel {
                    id: t2
                    text: tm2.text
                    fontSize: tm2.font.pointSize
                }

            }

            MouseAreaEx {
                id: ma
                onClicked: root.zoneClicked(index)

                onContainsMouseChanged: {
                    zoneHovered(ma.containsMouse)
                    if (playingnowtracks > 0)
                        controlsTimer.start()
                }

                onWheel: {
                    root.zoneWheeled(wheel.angleDelta.y > 0)
                }

                Timer {
                    id: controlsTimer
                    interval: PlasmaCore.Units.veryLongDuration * 2
                    onTriggered: {
                        if (ma.containsMouse) {
                            if (!Plasmoid.expanded)
                                controls.opacity = .85
                        } else {
                            controls.opacity = 0
                        }

                        stop()
                    }
                }

                // control box
                Rectangle {
                    id: controls
                    radius: 6
                    implicitHeight: zc.height
                    implicitWidth: zc.width + PlasmaCore.Units.largeSpacing
                    anchors.left: ma.left

                    color: PlasmaCore.ColorScope.backgroundColor
                    opacity: 0
                    visible: opacity > 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: PlasmaCore.Units.longDuration
                        }
                    }

                    // zone controls
                    RowLayout {
                        id: zc
                        spacing: 0
                        anchors.centerIn: parent

                        PrevButton {}
                        PlayPauseButton {
                            icon.width: PlasmaCore.Units.iconSizes.medium
                            icon.height: PlasmaCore.Units.iconSizes.medium
                        }
                        StopButton {
                            visible: Plasmoid.configuration.showStopButton
                        }
                        NextButton {}

                    }

                }
            }

        }

        // spacer
        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: PlasmaCore.Theme.disabledTextColor
            opacity: rightJustify && index > 0
        }

    }

}


