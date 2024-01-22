import QtQuick 2.1
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {

    focus: true

    PlasmaExtras.Heading {
        id: heading

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: updateIcon.left
        level: 3
        opacity: 0.6
        text: main.subtext
    }

    PlasmaComponents.ToolButton {
        id: updateIcon

        anchors.right: parent.right
        anchors.top: parent.top
        height: units.iconSizes.medium
        iconSource: "package-install"
        tooltip: i18n("Install Updates")
        onClicked: main.action_updateSystem()
    }

    PlasmaExtras.ScrollArea {
        id: scrollView;

        anchors.top: heading.height > updateIcon.height ? heading.bottom : updateIcon.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        ListView {
            id: packageView;

            anchors.rightMargin: units.gridUnit
            clip: true
            model: packageModel;
            currentIndex: -1;
            boundsBehavior: Flickable.StopAtBounds;
            focus: true

            delegate: PackageItem {}

        }
    }
}
