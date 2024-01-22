import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.0
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrols 2.0 as KQuickControls
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

    property string icon: Qt.resolvedUrl("ms.svg")
    property string model: plasmoid.configuration.model
    property bool mode: plasmoid.configuration.mode
    property string color: plasmoid.configuration.color
                           !== "" ? plasmoid.configuration.color : PlasmaCore.ColorScope.textColor
    property string iconColor: plasmoid.configuration.icon ? plasmoid.configuration.color : PlasmaCore.ColorScope.textColor
    readonly property color recentColor: plasmoid.configuration.history[0]
                                         || "#00000000"
    readonly property string defaultFormat: plasmoid.configuration.defaultFormat
    property string preset: plasmoid.configuration.preset
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.backgroundHints: "NoBackground"

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

    function changeColor() {
        var command = !plasmoid.configuration.mode ? root.color.substring(
                                                         1) : plasmoid.configuration.preset
        var mod = plasmoid.configuration.mode ? "p" : "s"
        // console.log(command)
        executable.exec(
                    "msi-perkeyrgb --model " + root.model + " -" + mod + " " + command)
    }

    function addColorToHistory(color) {
        var history = plasmoid.configuration.history
        history.unshift(color.toString())

        plasmoid.configuration.history = history.slice(0, 8)
    }

    Connections {
        target: executable
        onExited: {
            if (plasmoid.configuration.history.indexOf(root.color) == -1)
                addColorToHistory(root.color)
        }
    }

    Plasmoid.compactRepresentation: Item {
        PlasmaCore.IconItem {
            id: ima
            anchors.fill: parent
            source: root.icon
            antialiasing: true
            visible: !plasmoid.configuration.icon
        }
        ColorOverlay {
            anchors.fill: ima
            source: ima
            color: iconColor
            antialiasing: true
            visible: !root.mode && plasmoid.configuration.icon
        }
        LinearGradient {
            anchors.fill: ima
            source: ima
            visible: root.mode && plasmoid.configuration.icon
            start: Qt.point(ima.width, 0)
            end: Qt.point(0, ima.height)
            gradient: Gradient {
                GradientStop {
                    position: 0.000
                    color: Qt.rgba(1, 0, 0, 1)
                }
                GradientStop {
                    position: 0.167
                    color: Qt.rgba(1, 1, 0, 1)
                }
                GradientStop {
                    position: 0.333
                    color: Qt.rgba(0, 1, 0, 1)
                }
                GradientStop {
                    position: 0.500
                    color: Qt.rgba(0, 1, 1, 1)
                }
                GradientStop {
                    position: 0.667
                    color: Qt.rgba(0, 0, 1, 1)
                }
                GradientStop {
                    position: 0.833
                    color: Qt.rgba(1, 0, 1, 1)
                }
                GradientStop {
                    position: 1.000
                    color: Qt.rgba(1, 0, 0, 1)
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                plasmoid.expanded = !plasmoid.expanded
            }
        }
    }

    Plasmoid.fullRepresentation: ColumnLayout {
        RowLayout {
            PlasmaComponents3.Label {
                text: i18n("Mode:")
            }
            PlasmaComponents3.ComboBox {
                Layout.fillWidth: true
                id: modeCombo
                model: ["Color", "Preset"]
                currentIndex: plasmoid.configuration.mode ? 1 : 0
                onActivated: {
                    plasmoid.configuration.mode = currentIndex == 0 ? false : true
                }
            }
            KQuickControls.ColorButton {
                visible: !plasmoid.configuration.mode
                height: modeCombo.height
                Layout.fillHeight: true
                id: colorButton
                color: plasmoid.configuration.color
                showAlphaChannel: false
                onColorChanged: {
                    if (plasmoid.configuration.color != color) {
                        plasmoid.configuration.color = color
                        changeColor()
                    }
                }
            }
        }
        GridView {
            id: fullRoot
            visible: !plasmoid.configuration.mode
            readonly property int columns: 2

            Layout.minimumWidth: columns * PlasmaCore.Units.gridUnit * 7
            Layout.minimumHeight: Layout.minimumWidth
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            cellWidth: Math.floor(fullRoot.width / fullRoot.columns)
            cellHeight: cellWidth / 2
            boundsBehavior: Flickable.StopAtBounds
            model: plasmoid.configuration.history
            highlight: PlasmaComponents.Highlight {}
            highlightMoveDuration: 0

            Connections {
                target: plasmoid
                function onExpandedChanged() {
                    if (plasmoid.expanded) {
                        fullRoot.forceActiveFocus()
                    }
                }
            }
            Rectangle {
                id: dragImageDummy
                border {
                    color: PlasmaCore.Theme.textColor
                    width: Math.round(PlasmaCore.Units.devicePixelRatio)
                }
                radius: width
                width: PlasmaCore.Units.iconSizes.large
                height: PlasmaCore.Units.iconSizes.large
                visible: false
            }

            delegate: MouseArea {
                id: delegateMouse

                readonly property color currentColor: modelData

                width: fullRoot.cellWidth
                height: fullRoot.cellHeight

                drag.target: rect
                Drag.dragType: Drag.Automatic
                Drag.active: delegateMouse.drag.active
                Drag.mimeData: {
                    "application/x-color": rect.color,
                    "text/plain": colorLabel.text
                }

                hoverEnabled: true
                onContainsMouseChanged: {
                    if (containsMouse) {
                        fullRoot.currentIndex = index
                    } else {
                        fullRoot.currentIndex = -1
                    }
                }
                onClicked: {
                    plasmoid.configuration.color = rect.color
                    changeColor()
                }
                Rectangle {
                    id: rect

                    anchors {
                        fill: parent
                        margins: PlasmaCore.Units.smallSpacing
                    }

                    color: delegateMouse.currentColor

                    border {
                        color: PlasmaCore.Theme.textColor
                        width: Math.round(PlasmaCore.Units.devicePixelRatio)
                    }

                    Rectangle {
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            right: parent.right
                            margins: rect.border.width
                        }
                        height: colorLabel.contentHeight + 2 * PlasmaCore.Units.smallSpacing
                        color: PlasmaCore.Theme.backgroundColor
                        opacity: 0.8

                        PlasmaComponents3.Label {
                            id: colorLabel
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideLeft
                            fontSizeMode: Text.HorizontalFit
                            minimumPointSize: PlasmaCore.Theme.smallestFont.pointSize
                            text: delegateMouse.currentColor
                        }
                    }
                }
            }
        }
        ColumnLayout {
            Layout.fillHeight: true
            Repeater {
                model: ["aqua", "chakra", "default", "disco", "drain", "freeway", "rainbow split", "roulette"]
                delegate: PlasmaComponents3.RadioButton {
                    visible: plasmoid.configuration.mode
                    text: modelData
                    font.capitalization: Font.Capitalize
                    checked: plasmoid.configuration.preset == modelData
                    onCheckedChanged: {
                        if (checked) {
                            plasmoid.configuration.preset = modelData
                            changeColor()
                        }
                    }
                }
            }
        }
    }
}
