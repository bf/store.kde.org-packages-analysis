import QtQuick 2.15
import org.kde.kirigami 2.15 as Kirigami

Kirigami.Separator {
    property string text: ''
    property bool isSection: true

    Kirigami.FormData.isSection: isSection
    Kirigami.FormData.label: text
}
