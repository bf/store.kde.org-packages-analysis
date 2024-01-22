/***************************************************************************
 *   Copyright (C) 2014 by Eike Hein <hein@kde.org>                        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.draganddrop 2.0 as DragDrop

import org.kde.kirigami 2.4 as Kirigami


Kirigami.FormLayout {
    id: configGeneral


    property string cfg_icon: plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: plasmoid.configuration.customButtonImage

    //property alias cfg_appNameFormat: appNameFormat.currentIndex
    //property alias cfg_switchCategoriesOnHover: switchCategoriesOnHover.checked

    //property alias cfg_useExtraRunners: useExtraRunners.checked

    property alias cfg_numberColumns: numberColumns.value
    property alias cfg_numberRows: numberRows.value
    property alias cfg_showFavoritesFirst: showFavoritesFirst.checked


    property alias cfg_labels2lines: labels2lines.checked
    property alias cfg_displayPosition: displayPosition.currentIndex


    RowLayout {
        spacing: PlasmaCore.Units.smallSpacing
        Kirigami.FormData.label: i18n("Icon:")


        Button {
            id: iconButton
            Layout.minimumWidth: previewFrame.width + PlasmaCore.Units.smallSpacing * 2
            Layout.maximumWidth: Layout.minimumWidth
            Layout.minimumHeight: previewFrame.height + PlasmaCore.Units.smallSpacing * 2
            Layout.maximumHeight: Layout.minimumWidth

            DragDrop.DropArea {
                id: dropArea

                property bool containsAcceptableDrag: false

                anchors.fill: parent

                onDragEnter: {
                    // Cannot use string operations (e.g. indexOf()) on "url" basic type.
                    var urlString = event.mimeData.url.toString();

                    // This list is also hardcoded in KIconDialog.
                    var extensions = [".png", ".xpm", ".svg", ".svgz"];
                    containsAcceptableDrag = urlString.indexOf("file:///") === 0 && extensions.some(function (extension) {
                        return urlString.indexOf(extension) === urlString.length - extension.length; // "endsWith"
                    });

                    if (!containsAcceptableDrag) {
                        event.ignore();
                    }
                }
                onDragLeave: containsAcceptableDrag = false

                onDrop: {
                    if (containsAcceptableDrag) {
                        // Strip file:// prefix, we already verified in onDragEnter that we have only local URLs.
                        iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
                    }
                    containsAcceptableDrag = false;
                }
            }

            KQuickAddons.IconDialog {
                id: iconDialog

                function setCustomButtonImage(image) {
                    cfg_customButtonImage = image || cfg_icon || "start-here-kde"
                    cfg_useCustomButtonImage = true;
                }

                onIconNameChanged: setCustomButtonImage(iconName);
            }

            // just to provide some visual feedback, cannot have checked without checkable enabled
            checkable: true
            checked: dropArea.containsAcceptableDrag
            onClicked: {
                checked = Qt.binding(function() { // never actually allow it being checked
                    return iconMenu.status === PlasmaComponents.DialogStatus.Open || dropArea.containsAcceptableDrag;
                })

                iconMenu.open(0, height)
            }

            PlasmaCore.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: plasmoid.location === PlasmaCore.Types.Vertical || plasmoid.location === PlasmaCore.Types.Horizontal
                           ? "widgets/panel-background" : "widgets/background"
                width: PlasmaCore.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                height: PlasmaCore.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                PlasmaCore.IconItem {
                    anchors.centerIn: parent
                    width: PlasmaCore.Units.iconSizes.large
                    height: width
                    source: cfg_useCustomButtonImage ? cfg_customButtonImage : cfg_icon
                }
            }
        }

        // QQC Menu can only be opened at cursor position, not a random one
        PlasmaComponents.ContextMenu {
            id: iconMenu
            visualParent: iconButton

            PlasmaComponents.MenuItem {
                text: i18nc("@item:inmenu Open icon chooser dialog", "Choose...")
                icon: "document-open-folder"
                onClicked: iconDialog.open()
            }
            PlasmaComponents.MenuItem {
                text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                icon: "edit-clear"
                onClicked: {
                    cfg_useCustomButtonImage = false;
                }
            }
        }
    }


    CheckBox {
        id: showFavoritesFirst
        Kirigami.FormData.label: i18n("Show favorites first")
    }

    ComboBox {
        Kirigami.FormData.label: i18n("Menu position")
        id: displayPosition
        model: [
            i18n("Default"),
            i18n("Center"),
            i18n("Center bottom"),
        ]
        onActivated: cfg_displayPosition = currentIndex
    }


    CheckBox {
        id: labels2lines
        text: i18n("Show labels in two lines")
    }

    SpinBox{
        id: numberColumns
        minimumValue: 4
        maximumValue: 10
        Kirigami.FormData.label: i18n("Number of columns")

    }

    SpinBox{
        id: numberRows
        minimumValue: 1
        maximumValue: 10
        Kirigami.FormData.label: i18n("Number of rows")
    }

    RowLayout{

        //Layout.fillWidth: true
        Button {
            text: i18n("Unhide all hidden applications")
            onClicked: {
                plasmoid.configuration.hiddenApplications = [""];
                unhideAllAppsPopup.text = i18n("Unhidden!");
            }
        }
        Label {
            id: unhideAllAppsPopup
        }
    }

}
