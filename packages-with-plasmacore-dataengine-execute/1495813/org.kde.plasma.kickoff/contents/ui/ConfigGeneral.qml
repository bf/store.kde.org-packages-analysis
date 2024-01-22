/*
 *  Copyright 2013 David Edmundson <davidedmundson@kde.org>
 *  Copyright (C) 2021 by Mikel Johnson <mikel5764@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.15
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Window 2.2

ColumnLayout {

    property string cfg_icon: plasmoid.configuration.icon
    property alias cfg_switchTabsOnHover: switchTabsOnHoverCheckbox.checked
    property alias cfg_switchCategoriesOnHover: switchCategoriesOnHoverCheckbox.checked
    property int cfg_favoritesDisplay: plasmoid.configuration.favoritesDisplay
    property alias cfg_gridAllowTwoLines: gridAllowTwoLines.checked
    property alias cfg_alphaSort: alphaSort.checked
    property alias cfg_showTopLevelItems: showTopLevelItems.checked
    property var cfg_systemFavorites: String(plasmoid.configuration.systemFavorites)
    property int cfg_primaryActions: plasmoid.configuration.primaryActions
    property alias cfg_bottomHeader: bottomHeader.checked
    property alias cfg_configureButtonAction: configureButtonAction.currentIndex
    property alias cfg_scrollableApps: scrollableApps.checked
    property alias cfg_launcherButtonAction: launcherButtonAction.checked
    property alias cfg_scrollingDown: scrollingDown.currentIndex
    property alias cfg_gridIconSize: gridIconSize.value
    property alias cfg_listIconSize: listIconSize.value
    property alias cfg_resizableSidebar: resizableSidebar.checked

    Kirigami.FormLayout {
        Button {
            id: iconButton

            Kirigami.FormData.label: i18n("Icon:")

            implicitWidth: previewFrame.width + PlasmaCore.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + PlasmaCore.Units.smallSpacing * 2

            KQuickAddons.IconDialog {
                id: iconDialog
                onIconNameChanged: cfg_icon = iconName || "start-here-kde"
            }

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

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
                    source: cfg_icon
                }
            }

            Menu {
                id: iconMenu

                // Appear below the button
                y: +parent.height

                MenuItem {
                    text: i18nc("@item:inmenu Open icon chooser dialog", "Choose...")
                    icon.name: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                MenuItem {
                    text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                    icon.name: "edit-clear"
                    onClicked: cfg_icon = "start-here-kde"
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: switchTabsOnHoverCheckbox
            Kirigami.FormData.label: i18n("General:")
            text: i18n("Switch tabs on hover")
        }

        CheckBox {
            id: switchCategoriesOnHoverCheckbox
            text: i18n("Switch categories on hover")
        }

        CheckBox {
            id: alphaSort
            text: i18n("Always sort applications alphabetically")
        }

        CheckBox {
            id: showTopLevelItems
            text: i18n("Show top level applications")
        }

        Button {
            icon.name: "settings-configure"
            text: i18n("Configure enabled search plugins")
            onPressed: KQuickAddons.KCMShell.openSystemSettings("kcm_plasmasearch")
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RadioButton {
            id: showFavoritesInGrid
            Kirigami.FormData.label: i18n("Show favorites:")
            text: i18n("In a grid")
            ButtonGroup.group: displayGroup
            property int index: 0
            checked: plasmoid.configuration.favoritesDisplay == index
        }

        RadioButton {
            id: showFavoritesInList
            text: i18n("In a list")
            ButtonGroup.group: displayGroup
            property int index: 1
            checked: plasmoid.configuration.favoritesDisplay == index
        }

        CheckBox {
            id: gridAllowTwoLines
            text: i18n("Allow label to have two lines")
            enabled: showFavoritesInGrid.checked
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: bottomHeader
            Kirigami.FormData.label: i18n("Layouts:")
            text: i18n("Header in bottom")
            checked: plasmoid.configuration.bottomHeader          
        }

        CheckBox {
            id: resizableSidebar
            text: i18n("Resizable sidebar")
            checked: plasmoid.configuration.resizableSidebar
        }

        Button {
            id: resetSize
            icon.name: "edit-undo"
            text: i18n("Reset")
            onClicked: {
                plasmoid.configuration.minimumWidth=Screen.width/1.5
                plasmoid.configuration.minimumHeight=Screen.height/1.5
                plasmoid.configuration.gridIconSize=144
                plasmoid.configuration.listIconSize=48
                plasmoid.configuration.resizableSidebar=true
                plasmoid.configuration.bottomHeader=false
                plasmoid.configuration.x=2
                plasmoid.configuration.y=2
                plasmoid.configuration.sidebarWidth=plasmoid.configuration.listIconSize+PlasmaCore.Units.smallSpacing * 12
                resizableSidebar.checked=true

            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        Slider {
            id: gridIconSize
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("Grid icon size:")
            from: 16
            to: 256
            stepSize: 16
            snapMode: Slider.SnapAlways
        }
        Slider {
            id: listIconSize
            Layout.fillWidth: true
            Kirigami.FormData.label: i18n("List icon size:")
            from: 16
            to: 256
            stepSize: 16
            snapMode: Slider.SnapAlways
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RadioButton {
            id: powerActionsButton
            Kirigami.FormData.label: i18n("Primary actions:")
            text: i18n("Power actions")
            ButtonGroup.group: radioGroup
            property string actions: "suspend,hibernate,reboot,shutdown"
            property int index: 0
            checked: plasmoid.configuration.primaryActions == index
        }

        RadioButton {
            id: sessionActionsButton
            text: i18n("Session actions")
            ButtonGroup.group: radioGroup
            property string actions: "lock-screen,logout,save-session,switch-user"
            property int index: 1
            checked: plasmoid.configuration.primaryActions == index
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        ComboBox {
            id: configureButtonAction
            Kirigami.FormData.label: i18n("Configuration button action:")
            Layout.fillWidth: true
            Layout.minimumWidth: Kirigami.Units.gridUnit * 14
            model: [
            i18n("Configure application launcher"),
            i18n("Opens system settings"),
            ]
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        CheckBox {
            id: scrollableApps
            Kirigami.FormData.label: i18n("Enabling:")
            text: i18n("Scrollable applications mode")
            checked: plasmoid.configuration.scrollingApps
        }

        CheckBox {
            id: launcherButtonAction
            text: i18n("Launcher button starts applications")
            checked: plasmoid.configuration.launcherButtonAction
        }


        ComboBox {
            id: scrollingDown
            Kirigami.FormData.label: i18n("Scrolling backward launcher button:")
            Layout.fillWidth: true
            Layout.minimumWidth: Kirigami.Units.gridUnit * 14
            model: [
            i18nc("Part of a sentence: 'Scrolling-down launcher button does nothing'", "Does nothing"),
            i18nc("Part of a sentence: 'Scrolling-down launcher button minimizes active task'", "Minimizes active task"),
            i18nc("Part of a sentence: 'Scrolling-down launcher button closes active task'", "Closes active task"),
            i18nc("Part of a sentence: 'Scrolling-down launcher button Present windows'", "Present windows")
            ]
        }    
    }

    ButtonGroup {
        id: displayGroup
        onCheckedButtonChanged: {
            if (checkedButton) {
                cfg_favoritesDisplay = checkedButton.index
            }
        }
    }

    ButtonGroup {
        id: radioGroup
        onCheckedButtonChanged: {
            if (checkedButton) {
                cfg_primaryActions = checkedButton.index
                cfg_systemFavorites = checkedButton.actions
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
