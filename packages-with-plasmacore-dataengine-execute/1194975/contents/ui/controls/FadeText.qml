import QtQuick 2.15
import org.kde.plasma.components 3.0 as PComp
import org.kde.plasma.core 2.1 as PlasmaCore
import '../helpers'

PComp.Label {
    id: txt
    property int duration: PlasmaCore.Units.longDuration * 2
    property alias animate: fb.enabled

    FadeBehavior on text {
        id: fb
        fadeDuration: txt.duration
    }

}
