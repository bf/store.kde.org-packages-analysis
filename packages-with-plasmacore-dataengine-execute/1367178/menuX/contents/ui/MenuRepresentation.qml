/***************************************************************************
 *   Copyright (C) 2013-2015 by Eike Hein <hein@kde.org>                   *
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

import QtQuick 2.4
import QtGraphicalEffects 1.0

import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras


FocusScope {
    id: root

    focus: true

    property bool done: false

    property int iconSize: units.iconSizes.smallMedium
    property int iconSizeSquare: units.iconSizes.medium
    property int tileSide: units.iconSizes.large + theme.mSize(theme.defaultFont).height
                           + (4 * units.smallSpacing)
                           + (2 * Math.max(highlightItemSvg.margins.top + highlightItemSvg.margins.bottom,
                                           highlightItemSvg.margins.left + highlightItemSvg.margins.right))


    property bool searching: (searchField.text != "")

    Layout.minimumWidth:  mainRow.implicitWidth
    Layout.maximumWidth:  mainRow.implicitWidth

    Layout.minimumHeight: tileSide * 5 + headLabelFavorites.implicitHeight * 2 +  units.largeSpacing * 2
    Layout.maximumHeight: tileSide * 5 + headLabelFavorites.implicitHeight * 2 +  units.largeSpacing * 2

    signal appendSearchText(string text)

    function colorWithAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    function reset() {
        mainColumn.visibleGrid = allAppsGrid
        searchField.clear();
        searchField.focus = true
        mainColumn.visibleGrid.tryActivate(0,0);

    }

    function toggle(){
        plasmoid.expanded = !plasmoid.expanded;
    }

    Connections {
        target: plasmoid
        onExpandedChanged: {
            if (expanded) {
                preloadAllAppsTimer.restart();
                globalFavoritesGrid.tryActivate(0,0)
                documentsFavoritesGrid.tryActivate(0,0)
                reset();
            }
        }
    }

    PlasmaExtras.Heading {
        id: dummyHeading
        visible: false
        width: 0
        level: 1
    }

    TextMetrics {
        id: headingMetrics
        font: dummyHeading.font
    }

    PlasmaComponents.Menu {
        id: contextMenu
        PlasmaComponents.MenuItem {
            action: plasmoid.action("configure")
        }
    }

    Timer {
        id: preloadAllAppsTimer
        property bool done: false
        interval: 1000
        repeat: false
        onTriggered: {
            if (done) {
                return;
            }
            for (var i = 0; i < rootModel.count; ++i) {
                var model = rootModel.modelForRow(i);
                if (model.description === "KICKER_ALL_MODEL") {
                    allAppsGrid.model = model;
                    done = true;
                    break;
                }
            }
        }
        function defer() {
            if (!running && !done) {
                restart();
            }
        }
    }


    Row{
        id: mainRow
        spacing: units.smallSpacing * 2
        anchors.fill: parent
        SideBarItem{

        }

        Item{
            width:  3 * tileSide
            height: parent.height

            Item {
                id: mainColumn
                width: parent.width
                height: parent.height - searchField.implicitHeight - units.smallSpacing*2
                anchors {
                    bottom: parent.bottom
                    bottomMargin: units.smallSpacing
                }
                property Item visibleGrid: allAppsGrid

                function tryActivate(row, col) {
                    if (visibleGrid) {
                        visibleGrid.tryActivate(row, col);
                    }
                }

                ItemMultiGridView {
                    id: allAppsGrid
                    anchors.top: parent.top
                    z: (opacity == 1.0) ? 1 : 0
                    width:  parent.width
                    height: parent.height
                    enabled: (opacity == 1.0) ? 1 : 0
                    opacity: searching ? 0 : 1
                    aCellWidth: parent.width - units.largeSpacing
                    aCellHeight: iconSize + units.smallSpacing*2
                    model: rootModel.modelForRow(2);
                    onOpacityChanged: {
                        if (opacity == 1.0) {
                            allAppsGrid.flickableItem.contentY = 0;
                            mainColumn.visibleGrid = allAppsGrid;
                        }
                    }
                    onKeyNavRight: globalFavoritesGrid.tryActivate(0,0)

                }

                ItemMultiGridView {
                    id: runnerGrid
                    anchors.fill: parent
                    z: (opacity == 1.0) ? 1 : 0
                    aCellWidth: parent.width - units.largeSpacing
                    aCellHeight: iconSize + units.smallSpacing * 2

                    enabled: (opacity == 1.0) ? 1 : 0
                    isSquare: false
                    model: runnerModel
                    grabFocus: true
                    opacity: searching ? 1.0 : 0.0
                    onOpacityChanged: {
                        if (opacity == 1.0) {
                            mainColumn.visibleGrid = runnerGrid;
                        }
                    }
                    onKeyNavRight: globalFavoritesGrid.tryActivate(0,0)
                }



                Keys.onPressed: {
                    if (event.key == Qt.Key_Tab) {
                        event.accepted = true;
                        globalFavoritesGrid.tryActivate(0,0)
                    } else if (event.key == Qt.Key_Backspace) {
                        event.accepted = true;
                        if(searching)
                            searchField.backspace();
                        else
                            searchField.focus = true
                    } else if (event.key == Qt.Key_Escape) {
                        event.accepted = true;
                        if(searching){
                            searchField.clear()
                        } else {
                            root.toggle()
                        }
                    } else if (event.text != "") {
                        event.accepted = true;
                        searchField.appendText(event.text);
                    }
                }

            }

            PlasmaComponents3.TextField {
                id: searchField
                anchors.top: parent.top
                anchors.topMargin: units.smallSpacing
                focus: true
                placeholderText: i18n("Type here to search ...")
                width:  parent.width
                onTextChanged: {
                    runnerModel.query = text;

                }
                function clear() {
                    text = "";
                }
                function backspace() {
                    if(searching){
                        text = text.slice(0, -1);
                    }
                    focus = true;
                }
                function appendText(newText) {
                    if (!root.visible) {
                        return;
                    }
                    focus = true;
                    text = text + newText;
                }
                Keys.onPressed: {
                    if (event.key == Qt.Key_Space) {
                        event.accepted = true;
                    } else if (event.key == Qt.Key_Down) {
                        event.accepted = true;
                        mainColumn.visibleGrid.tryActivate(0,0);
                    } else if (event.key == Qt.Key_Tab || event.key == Qt.Key_Up) {
                        event.accepted = true;
                        mainColumn.visibleGrid.tryActivate(0,0);
                    } else if (event.key == Qt.Key_Backspace) {
                        event.accepted = true;
                        if(searching)
                            searchField.backspace();
                        else
                            searchField.focus = true
                    } else if (event.key == Qt.Key_Escape) {
                        event.accepted = true;
                        if(searching){
                            clear()
                        } else {
                            root.toggle()
                        }
                    }
                }
            }

        }

        ColumnLayout{
            height: parent.height
            width: tileSide * 3
            spacing:  units.largeSpacing * 0.5

            PlasmaExtras.Heading {
                id: headLabelFavorites
                color: colorWithAlpha(theme.textColor, 0.8)
                level: 4
                text: i18n("Favorites") + " (" + globalFavoritesGrid.count +")"
                Layout.leftMargin: units.smallSpacing
            }

            ItemGridView {
                id: globalFavoritesGrid
                width:  tileSide * 3
                height: tileSide * 3
                cellWidth:   tileSide
                cellHeight:  tileSide
                iconSize:  root.iconSizeSquare
                square: true
                model: globalFavorites
                dropEnabled: true
                usesPlasmaTheme: false
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                onKeyNavDown: documentsFavoritesGrid.tryActivate(0,0)
                onKeyNavLeft: mainColumn.visibleGrid.tryActivate(0,0)
                onCurrentIndexChanged: {
                    preloadAllAppsTimer.defer();
                }
                Keys.onPressed: {

                    if (event.key == Qt.Key_Tab) {
                        event.accepted = true;
                        documentsFavoritesGrid.tryActivate(0,0)
                    } else if (event.key == Qt.Key_Backspace) {
                        event.accepted = true;
                        if(searching)
                            searchField.backspace();
                        else
                            searchField.focus = true
                    } else if (event.key == Qt.Key_Escape) {
                        event.accepted = true;
                        if(searching){
                            searchField.clear()
                        } else {
                            root.toggle()
                        }
                    } else if (event.text != "") {
                        event.accepted = true;
                        searchField.appendText(event.text);
                    }
                }

            }

            PlasmaExtras.Heading {
                id: headLabelDocuments
                color: colorWithAlpha(theme.textColor, 0.8)
                level: 4
                text: i18n("Recent") + " (" + documentsFavoritesGrid.count +")"
                Layout.leftMargin: units.smallSpacing

            }


            ItemGridView {
                id: documentsFavoritesGrid
                width:  tileSide * 3
                height: (root.iconSize + 2*units.smallSpacing) * 6
                cellWidth:   parent.width
                cellHeight:  root.iconSize + 2*units.smallSpacing
                iconSize:  root.iconSize
                square: false
                model:  rootModel.modelForRow(1)
                dropEnabled: true
                usesPlasmaTheme: false
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

                //Rectangle{ anchors.fill: parent; color: colorWithAlpha(theme.textColor,0.05);}

                onKeyNavUp: globalFavoritesGrid.tryActivate(0,0);
                onKeyNavLeft: mainColumn.visibleGrid.tryActivate(0,0)

                onCurrentIndexChanged: {
                    preloadAllAppsTimer.defer();
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Tab) {
                        event.accepted = true;
                        mainColumn.visibleGrid.tryActivate(0,0)
                    }  else if (event.key == Qt.Key_Backspace) {
                        event.accepted = true;
                        if(searching)
                            searchField.backspace();
                        else
                            searchField.focus = true
                    } else if (event.key == Qt.Key_Escape) {
                        event.accepted = true;
                        if(searching){
                            searchField.clear()
                        } else {
                            root.toggle()
                        }
                    } else if (event.text != "") {
                        event.accepted = true;
                        searchField.appendText(event.text);
                    }

                }
            }
            Item{
                Layout.fillHeight: true
            }

        }
    }
    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            plasmoid.expanded = false;
                        }
                    }

    Component.onCompleted: {
        kicker.reset.connect(reset);
        windowSystem.hidden.connect(reset);
    }
}
