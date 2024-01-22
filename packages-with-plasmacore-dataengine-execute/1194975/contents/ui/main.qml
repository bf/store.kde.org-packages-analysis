import QtQuick 2.15
import QtQuick.Layouts 1.13
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0

import 'helpers'

Item {
    id: plasmoidRoot

    property int panelViewSize: {
        if (!Plasmoid.configuration.useZoneCount)
            return Math.round(PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).width
                    * Plasmoid.configuration.trayViewSize)
        else {
            return Math.round(PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).width
                    * Math.max(2, mcws.zoneModel.count-1)
                    * PlasmaCore.Units.gridUnit)
        }
    }
    property bool vertical:         Plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool panelZoneView:    Plasmoid.configuration.advancedTrayView & !vertical

    property bool abbrevTrackView:  Plasmoid.configuration.abbrevTrackView
    property bool autoShuffle:      Plasmoid.configuration.autoShuffle
    property bool autoConnect:      Plasmoid.configuration.autoConnect

    property int thumbSize:         Plasmoid.configuration.thumbSize

    // Use these signals to communicate to/from compact view and full view
    signal zoneSelected(int zonendx)
    signal tryConnection()
    signal hostModelChanged(int index)

    Component {
        id: advComp
        CompactView {
            property int lastZone: -1

            onZoneClicked: {
                // if connected, keep the popup open
                // when clicked a different zone
                if (mcws.isConnected) {
                    /*emit*/ zoneSelected(zonendx)
                    if (!Plasmoid.expanded) {
                        lastZone = zonendx
                        Plasmoid.expanded = true
                    }
                    else {
                        if (lastZone === zonendx)
                            Plasmoid.expanded = false
                        else
                            lastZone = zonendx
                    }
                    return
                }

                // not connected
                if (!Plasmoid.expanded) {
                    /*emit*/ tryConnection()
                    Plasmoid.expanded = true
                }
                else if (Plasmoid.hideOnWindowDeactivate)
                    Plasmoid.expanded = false
            }
        }
    }
    Component {
        id: iconComp
        PlasmaCore.IconItem {
            source: "multimedia-player"

            Component.onCompleted: Plasmoid.toolTipSubText = 'Click to Connect'

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (Plasmoid.expanded & !Plasmoid.hideOnWindowDeactivate)
                        return

                    Plasmoid.expanded = !Plasmoid.expanded

                    if (Plasmoid.expanded & !mcws.isConnected) {
                        /*emit*/ tryConnection()
                    }
                }
            }
        }
    }

    Plasmoid.switchWidth: PlasmaCore.Units.gridUnit * 25
    Plasmoid.switchHeight: PlasmaCore.Units.gridUnit * 25

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
                                 | PlasmaCore.Types.ConfigurableBackground

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.compactRepresentation: Loader {

        Layout.preferredWidth: mcws.isConnected
                                ? panelZoneView ? panelViewSize : PlasmaCore.Units.iconSizeHints.panel
                                : -1

        sourceComponent: mcws.isConnected
                        ? panelZoneView ? advComp : iconComp
                        : iconComp
    }

    Plasmoid.fullRepresentation: FullView {
        Layout.preferredWidth: PlasmaCore.Units.gridUnit * 50
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 25

        readonly property var appletInterface: Plasmoid.self

        Layout.minimumWidth: implicitWidth
        Layout.maximumWidth: PlasmaCore.Units.gridUnit * 80
        Layout.minimumHeight: implicitHeight
        Layout.maximumHeight: PlasmaCore.Units.gridUnit * 60

        // For some reason, attached property Plasmoid.action(..)
        // does not work in an Item below root
        onRequestConfig: Plasmoid.action('configure').trigger()
    }

    Plasmoid.toolTipMainText: {
        mcws.isConnected
                ? qsTr('Connected to [%1]'.arg(mcws.serverInfo.friendlyname))
                : Plasmoid.title
    }

    SingleShot { id: event }

    Connections {
        target: Plasmoid.configuration

        onShowTrackSplashChanged: {
            if (Plasmoid.configuration.showTrackSplash) {
                splasher = tsComp.createObject(plasmoidRoot, {showTrackSplash: true})
                logger.log('TrackSplash Enabled')
            }
            else {
                splasher.destroy()
                splasher = null
                logger.log('TrackSplash Disabled')
            }
        }

        onUseZoneCountChanged: mcws.reset()

        onTrayViewSizeChanged: if (!Plasmoid.configuration.useZoneCount) mcws.reset()

        onAllowDebugChanged: {
            if (Plasmoid.configuration.allowDebug)
                action_logger()
            else
                logger.close()
        }
    }

    McwsHostModel {
        id: hostModel

        configString: Plasmoid.configuration.hostConfig

        onLoadError: logger.log('HOSTCFG LOAD ERR', msg)

        // (count)
        onLoadFinish: {
            // model with no rows means config is not set up
            if (count === 0) {
                mcws.closeConnection()
            } else if (autoConnect || mcws.isConnected) {
                // If the connected host is not in the list, reset connection to first in list
                // Also, this is essentially the auto-connect at plasmoid load (see Component.completed)
                // because at load time, mcws.host is null (mcws is not connected)
                let ndx = hostModel.findIndex(item => item.host === mcws.host)
                if (ndx === -1) {  // not in model, so set to first
                    mcws.hostConfig = Object.assign({}, hostModel.get(0))
                    ndx = 0
                } else { // current connection is in model
                    // check if zones changed, reset connection if true
                    if (hostModel.get(ndx).zones !== mcws.hostConfig.zones) {
                        mcws.hostConfig = Object.assign({}, hostModel.get(ndx))
                        mcws.reset()
                    }
                }
                hostModelChanged(ndx)
            }
        }

    }

    McwsConnection {
        id: mcws

        videoFullScreen:    Plasmoid.configuration.forceDisplayView
        highQualityThumbs:  Plasmoid.configuration.highQualityThumbs

        pollerInterval: Plasmoid.expanded
                        ? Plasmoid.configuration.updateInterval/100 * 1000
                        : 10000

        defaultFields: Plasmoid.configuration.defaultFields
    }

    // Screen saver and track splasher
    // screensaver options are per-plasmoid-session
    // track splash options are in config/playback
    Component {
        id: tsComp

        SplashBase {
            fullScreenSplash : Plasmoid.configuration.fullscreenTrackSplash
            animateSplash    : Plasmoid.configuration.animateTrackSplash
            splashDuration   : Plasmoid.configuration.splashDuration * 10

            Connections {
                target: mcws

                // (zonendx, filekey)
                // Only splash the track when it changes, when the
                onTrackKeyChanged: {
                    // need to wait for state here, buffering etc.
                    event.queueCall(2000, () => {
                        let zone = mcws.zoneModel.get(zonendx)
                        // Only show playing, legit tracks
                        if (zone.state !== PlayerState.Playing || filekey === '-1')
                            return

                        init()
                        panelModel.append(newItem(zone, zonendx, filekey,
                                         { splashmode: true
                                         , screensaver: false
                                         , animate: animateSplash
                                         , fullscreen: fullScreenSplash
                                         , transparent: false
                                         , duration: splashDuration
                                         }))
                    })
                }
            }

        }
    }

    Component {
        id: ssComp

        SplashBase {
            useCoverArt    : Plasmoid.configuration.useCoverArtBackground
            animateSS      : Plasmoid.configuration.animatePanels
            transparentSS  : Plasmoid.configuration.transparentPanels
            useMultiScreen : Plasmoid.configuration.useMultiScreen

            onScreenSaverModeChanged: {
                if (screenSaverMode) {
                    init()

                    mcws.zoneModel.forEach((zone, ndx) => addItem(ndx, zone.filekey,
                                                                  { animate: animateSS
                                                                      , fullscreen: false
                                                                      , screensaver: true
                                                                      , splashmode: false
                                                                      , transparent: transparentSS
                                                                    }))
                    background.setImage()
                }
                else {
                    background.stopAll()
                    event.queueCall(defaultFadeOutDuration, () => {
                        panelModel.clear()
                        background.destroy()
                    })
                }
            }

            Connections {
                target: mcws

                // (zonendx, filekey)
                // Only splash the track when it changes, when the
                // screenSaver mode is not enabled and when it's playing
                onTrackKeyChanged: {
                    event.queueCall(1000, addItem, zonendx, filekey,
                                    { animate: animateSS
                                        , fullscreen: false
                                        , screensaver: true
                                        , splashmode: false
                                        , transparent: transparentSS
                                      })
                }

                onConnectionStart: screenSaverMode = false
                onConnectionStopped: screenSaverMode = false
            }

            onDone: { splasher.destroy(); splasher = null; logger.log('SS DONE') }
        }
    }

    property var splasher

    // Auto-connect Watcher
    Timer {
        interval: 10000; repeat: true

        running: !mcws.isConnected && autoConnect

        onRunningChanged: {
            logger.log(running ? 'WATCHER RUNNING' : 'WATCHER STOPPED')
        }

        onTriggered: {
            if (hostModel.count > 0) {
                logger.log('WATCHER TRYING CONNECTION')
                /*emit*/ tryConnection()
            } else {
                logger.log('WATCHER LOADING HOSTMODEL')
                hostModel.load()
            }
        }

    }

    // Debug/Logging connections
    Connections {
        target: mcws
        enabled: Plasmoid.configuration.allowDebug & logger.enabled

        onDebugLogger: logger.log(title, msg, obj)

        onConnectionStart: {
            logger.warn('ConnectionStart', host, mcws.hostConfig)
        }
        onConnectionStopped: {
            logger.warn('ConnectionStopped')
        }
        onConnectionReady: {
            logger.warn('ConnectionReady', '(%1)'.arg(zonendx) + host, mcws.hostConfig)
        }
        onConnectionError: {
            logger.warn('ConnectionError', msg, cmd)
        }
        onCommandError: {
            logger.warn('CommandError:', msg, cmd)
        }
        onTrackKeyChanged: {
            logger.log(mcws.zoneModel.get(zonendx).zonename + ':  TrackKeyChanged'
                       , filekey.toString())
        }
        onPnPositionChanged: {
            logger.log(mcws.zoneModel.get(zonendx).zonename + ':  PnPositionChanged'
                       , pos.toString())
        }
        onPnChangeCtrChanged: {
            logger.log(mcws.zoneModel.get(zonendx).zonename + ':  PnChangeCtrChanged'
                       , ctr.toString())
        }
        onPnStateChanged: {
            logger.log(mcws.zoneModel.get(zonendx).zonename + ':  PnStateChanged'
                       , 'State: ' + playerState.toString())
        }
    }
    // Logger for "simple" debug items
    Logger {
        id: logger
        winTitle: 'MCWS Logger'
    }

    function action_kde() {
        KCMShell.open(["kscreen", "kcm_pulseaudio", "powerdevilprofilesconfig"])
    }

    function action_reset() {
        mcws.reset()
    }

    function action_close() {
        mcws.closeConnection()
        Plasmoid.expanded = false
    }

    function action_logger() {
        logger.init()
    }

    function action_screensaver() {
        if (splasher && splasher.screenSaverMode) {
            splasher.screenSaverMode = false
        } else {
            splasher = ssComp.createObject(plasmoidRoot, {screenSaverMode: true})
        }
    }

    Plasmoid.onContextualActionsAboutToShow: {
        Plasmoid.action('reset').visible =
            Plasmoid.action('close').visible = mcws.isConnected

        const a = Plasmoid.action('screensaver')
        if (mcws.isConnected && (!splasher || splasher.screenSaverMode)) {
            a.visible = true
            a.text = (splasher && splasher.screenSaverMode ? 'Stop' : 'Start') + ' Screensaver'
        } else {
            a.visible = false
        }

        Plasmoid.action('logger').visible = Plasmoid.configuration.allowDebug
    }

    Component.onCompleted: {
        if (KCMShell.authorize("powerdevilprofilesconfig.desktop").length > 0)
            Plasmoid.setAction("kde", i18n("Configure Plasma5..."), "kde");

        Plasmoid.setAction("logger", i18n("Logger Window"), "debug-step-into")
        if (Plasmoid.configuration.allowDebug) {
            action_logger()
        }
        Plasmoid.setActionSeparator('1')
        Plasmoid.setAction("screensaver", '', "preferences-desktop-screensaver-symbolic")
        Plasmoid.setAction("reset", i18n("Refresh View"), "view-refresh");
        Plasmoid.setAction("close", i18n("Close Connection"), "network-disconnected");
        Plasmoid.setActionSeparator('2')
    }
}
