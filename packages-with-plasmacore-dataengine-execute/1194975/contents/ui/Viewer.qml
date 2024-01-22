import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

ListView {
    id: list

    property bool useHighlight: true
    readonly property var modelItem: !model || currentIndex === -1
                            ? undefined
                            : model.get(currentIndex)

    Component {
        id: hl
        Rectangle {
                width: list.width
                color: PlasmaCore.Theme.highlightColor
                radius: 5
                y: list.currentItem ? list.currentItem.y : -1
                Behavior on y {
                    SpringAnimation {
                        spring: 2.5
                        damping: 0.3
                    }
                }
            }
    }

    spacing: 6
    clip: true
    highlightMoveDuration: 1
    highlight: useHighlight ? hl : null
}
