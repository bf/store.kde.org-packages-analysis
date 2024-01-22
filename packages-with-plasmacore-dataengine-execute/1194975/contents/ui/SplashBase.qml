import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.12

import 'helpers/utils.js' as Utils
import 'controls'
import 'helpers'

Item {
    id: root

    property Window background
    property int defaultFadeInDuration: 1500
    property int defaultFadeOutDuration: 1500

    // Splash specific
    property bool showTrackSplash: false
    property bool fullScreenSplash: false
    property bool animateSplash: false
    property int splashDuration: 5000

    // SS specific
    property bool useCoverArt: false
    property bool useMultiScreen: false
    property bool animateSS: false
    property bool transparentSS: false
    property bool screenSaverMode: false

    onUseMultiScreenChanged:
        if (screenSaverMode && background) background.setDim()

    onUseCoverArtChanged:
        if (screenSaverMode && background) background.setImage()

    onAnimateSSChanged:
        if (screenSaverMode && background) background.resetFlags()

    onTransparentSSChanged:
        if (screenSaverMode && background) background.resetFlags()

    // track item list, indexed to mcws.zonemodel
    readonly property BaseListModel panelModel: BaseListModel {}

    // return a new track panel model item
    function newItem(zone, zonendx, filekey, flags) {
        return Object.assign(
                  { key: zonendx
                  , filekey: (filekey === undefined ? zone.filekey : filekey)
                  , title: '%1 [%2]'
                        .arg(zone.zonename)
                        .arg(mcws.serverInfo.friendlyname)
                  , info1: zone.name
                  , info2: zone.artist
                  , info3: zone.album
                  , thumbsize: thumbSize
                  , fadeInDuration: defaultFadeInDuration
                  , fadeOutDuration: defaultFadeOutDuration
                  }
                  , flags)
    }

    // Add new panel model item
    function addItem(zonendx, filekey, flags) {
        // Find the ndx for the panel
        // index is info.key
        let zone = mcws.zoneModel.get(zonendx)
        let info = newItem(zone, zonendx, filekey, flags)

        let ndx = panelModel.findIndex(s => s.screensaver && s.key === info.key)
        if (ndx !== -1) {
            // panel found
            background.updatePanel(ndx, info)
            background.setImage(zone.state !== PlayerState.Stopped
                               ? info.filekey
                               : undefined)
        } else {
            // create panel if not found
            panelModel.append(info)
        }
    }

    function init() {
        if (!background)
            background = windowComp.createObject(root)
    }

    signal done()

    Component {
        id: windowComp

        Window {
            id: win

            color: 'transparent'
            flags: Qt.FramelessWindowHint | Qt.BypassWindowManagerHint

            // set background image
            function setImage(filekey) {
                if (!useCoverArt) {
                    ti.sourceKey = '-1'
                    return
                }

                if (filekey !== undefined && filekey.length > 0) {
                    ti.sourceKey = filekey
                } else {
                    // Null filekey sent so find a playing zone
                    // If no zones playing, choose a random zone
                    let ndx = mcws.zonesByState(PlayerState.Playing).length === 0
                         ? Math.floor(Math.random() * mcws.zoneModel.count)
                         : mcws.getPlayingZoneIndex()
                    ti.sourceKey = mcws.zoneModel.get(ndx).filekey
                }
            }

            // update every panel flags
            function resetFlags() {
                for(let i=0, len=panels.count; i<len; ++i)
                    panels.itemAt(i).reset({ animate: animateSS
                                          , transparent: transparentSS
                                          })
            }

            // tell every panel to finish
            function stopAll() {
                for(let i=0, len=panels.count; i<len; ++i)
                    panels.itemAt(i).stop()
            }

            // queue update for a panel
            function updatePanel(ndx, info) {
                panels.itemAt(ndx).setDataPending(info)
            }

            // Some reason, multi screen, can't get the right screen
            // so get it manually, assuming the biggest is "primary"
            function setDim() {
                let maxW = 0, scr
                for (let i=0, len=Qt.application.screens.length; i<len; i++) {
                    const s = Qt.application.screens[i]
                    if (s.width >= maxW) {
                        maxW = s.width
                        scr = s
                    }
                }

                height = screenSaverMode && useMultiScreen
                        ? scr.desktopAvailableHeight
                        : scr.height
                width = screenSaverMode && useMultiScreen
                       ? scr.desktopAvailableWidth
                       : scr.width

                logger.log('Screen %3, %1x%2'.arg(width).arg(height).arg(scr.name))
            }

            // Background cover art
            TrackImage {
                id: ti
                thumbnail: false
                duration: 700
                imageUtils: mcws.imageUtils
                anchors.centerIn: parent
                width: Math.round(parent.height*.8)
                height: Math.round(parent.height*.8)
                opacity: showTrackSplash & !fullScreenSplash ? 0 : 0.25
            }

            Repeater {
                id: panels
                model: panelModel

                onItemRemoved: {
                    if (showTrackSplash && panelModel.count === 0) {
                        background.destroy(100)
                    }
                }

                SplashDelegate {
                    availableArea: Qt.size(win.width, win.height)

                    dataSetter: data => panelModel.set(index, data)

                    // splashMode
                    // track spashers remove themselves from the model
                    onSplashDone: panelModel.remove(index)
                }
            }

            // SS menu
            Loader {
                active: screenSaverMode

                Menu {
                    id: ssMenu
                    // keep a var so we can react on click
                    // after the menu disappears
                    property bool on: false

                    MenuItem {
                        text: 'Use Cover Art Background'
                        checkable: true
                        checked: useCoverArt
                        icon.name: 'emblem-music-symbolic'
                        onTriggered: useCoverArt = !useCoverArt
                    }
                    MenuItem {
                        text: 'Animate Panels'
                        checkable: true
                        checked: animateSS
                        icon.name: 'system-restart-panel'
                        onTriggered: animateSS = !animateSS
                    }
                    MenuItem {
                        text: 'Transparent Panels'
                        checkable: true
                        checked: transparentSS
                        icon.name: 'package-available'
                        onTriggered: transparentSS = !transparentSS
                    }
                    MenuItem {
                        text: 'Use Multiple Screens'
                        checkable: true
                        checked: useMultiScreen
                        icon.name: 'wine'
                        onTriggered: useMultiScreen = !useMultiScreen
                    }
                    MenuSeparator {}
                    MenuItem {
                        text: 'Stop Screensaver'
                        icon.name: 'stop'
                        onTriggered: screenSaverMode = false
                    }
                }
            }

            MouseAreaEx {
                acceptedButtons: Qt.RightButton | Qt.LeftButton

                focus: true
                Keys.onPressed: screenSaverMode = false

                onClicked: {
                    if (showTrackSplash) {
                        panelModel.clear()
                        return
                    }

                    if (mouse.button === Qt.LeftButton) {
                        if (ssMenu.on) {
                            ssMenu.on = false
                        }
                        else {
                            screenSaverMode = false
                        }
                        return
                    }

                    if (mouse.button === Qt.RightButton) {
                        ssMenu.popup()
                        ssMenu.on = true
                    }
                }
            }

            Component.onCompleted: {
                setDim()
                visible = true
            }

            Component.onDestruction: { background = null; done() }
        }
    }

}
