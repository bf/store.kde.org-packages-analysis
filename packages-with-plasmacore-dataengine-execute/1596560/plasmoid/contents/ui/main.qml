import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
	anchors.fill: parent
	Plasmoid.constraintHints: PlasmaCore.Types.CanFillArea
	Layout.preferredWidth: 5000
	Layout.fillWidth: true
    Layout.fillHeight: true
	
	
	Plasmoid.fullRepresentation: FullRepresentation {}
	Plasmoid.compactRepresentation: FullRepresentation {}
}
