/*
    SPDX-FileCopyrightText: 2020 Vadim Kalinnikov <moose@ylsoftware.com>
    SPDX-License-Identifier: LGPL-2.1
*/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    property string valueUsed: ''
    property string valueTotal: ''
    property real valueOpacity: 0
    property string yandexDiskDirectory: ''

    Plasmoid.switchHeight: 100
    Plasmoid.switchWidth: 400
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.compactRepresentation: RowLayout {
        anchors.fill: parent
        Image {
            id: compactLogo
            //Layout.alignment: Qt.AlignLeft
            fillMode: Image.PreserveAspectFit
            Layout.fillHeight: true
            //Layout.fillWidth: true
            //width: rootCompact.height
            //height: rootCompact.height
            source: "../images/yandexdisk-small.svg"
            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true;
                cursorShape: Qt.PointingHandCursor;
                onClicked: (mouse)=> {
                    if (yandexDiskDirectory != "") {
                        Qt.openUrlExternally(yandexDiskDirectory)
                    }
                }
            }
        }
        PlasmaComponents.ProgressBar {
            //Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Layout.leftMargin: 0
            Layout.rightMargin: 0
            minimumValue: 0
            maximumValue: 100
            value: valueOpacity
        }
    }

    Plasmoid.fullRepresentation: GridLayout {
        anchors.fill: parent
        rows: 4
        columns: 2
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignCenter
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.row: 0
            Layout.column: 0
            text: i18n('Yandex.Disk usage')
        }
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignLeft
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: true
            text: valueTotal
        }
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignLeft
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.row: 2
            Layout.column: 0
            Layout.fillWidth: true
            text: valueUsed
        }
        Image {
            Layout.alignment: Qt.AlignRight
            Layout.columnSpan: 1
            Layout.rowSpan: 2
            Layout.row: 1
            Layout.column: 1
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignRight
            /*
            verticalAlignment: Image.AlignVCenter
            */
            Layout.fillHeight: true
            Layout.fillWidth: true
            source: "../images/yandexdisk.svg"
            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true;
                cursorShape: Qt.PointingHandCursor;
                onClicked: (mouse)=> {
                    if (yandexDiskDirectory != "") {
                        Qt.openUrlExternally(yandexDiskDirectory)
                    }
                }
            }
        }
        PlasmaComponents.ProgressBar {
            Layout.alignment: Qt.AlignLeft
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.row: 3
            Layout.column: 0
            Layout.fillWidth: true
            minimumValue: 0
            maximumValue: 100
            value: valueOpacity
        }
    }

    PlasmaCore.DataSource {
        id: ydStatus
        engine: "executable"
        interval: Plasmoid.configuration.UpdateInterval*60000
        connectedSources: [
            (
                '/bin/sh -c "env LANG=C yandex-disk %1 status"'
            ).arg(Plasmoid.configuration.AdditionalParams)
        ]
        onNewData: {
            var stdout = data["stdout"]
            //console.debug(stdout)
            try {
                var raw_used = stdout.match(/Used: ([0-9]+(?:\.[0-9]+)?) ([KMGT]B)/)
                var raw_total = stdout.match(/Total: ([0-9]+(?:\.[0-9]+)?) ([KMGT]B)/)
                var raw_dir = stdout.match(/Path to Yandex.Disk directory: '(.+)'/)
                console.log(raw_dir)
                
                var yd_used = i18n("Data not fetched")
                var yd_total = i18n("Data not fetched")
                if (raw_used.length == 3 && raw_total.length == 3) {
                    yd_used = i18n("Used: %L1 %L2").arg(raw_used[1]).arg(raw_used[2])
                    yd_total = i18n("Total: %L1 %L2").arg(raw_total[1]).arg(raw_total[2])
                }
                //console.log(yd_used)
                //console.log(yd_total)
                
                if (raw_dir.length == 2) {
                    yandexDiskDirectory = raw_dir[1]
                }
                
                valueUsed = yd_used
                valueTotal = yd_total
                
                var yd_used_num = formatSrcNum(raw_used[1], raw_used[2])
                var yd_total_num = formatSrcNum(raw_total[1], raw_total[2])
                valueOpacity = yd_used_num * 100 / yd_total_num
                //console.log(valueOpacity)
            }
            catch(error) {
                console.log("Problem with data from yandex-disk service!")
            }
        }
        
        function formatSrcNum(n, k) {
            if (k == "TB") {
                n = n*1024*1024*1024*1024
            }
            else if (k == "GB") {
                n = n*1024*1024*1024
            }
            else if (k == "MB") {
                n = n*1024*1024
            }
            else if (k == "KB") {
                n = n*1024
            }
            
            return n;
        }
    }
}
