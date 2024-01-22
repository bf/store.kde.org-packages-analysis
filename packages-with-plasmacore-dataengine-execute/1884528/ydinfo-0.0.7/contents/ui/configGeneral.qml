/*
    SPDX-FileCopyrightText: 2020 Vadim Kalinnikov <moose@ylsoftware.com>
    SPDX-License-Identifier: LGPL-2.1
*/

import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
	id: page
	width: childrenRect.width
	height: childrenRect.height
	implicitWidth: mainColumn.implicitWidth
	implicitHeight: pageColumn.implicitHeight
	
	property alias cfg_AdditionalParams: cfgAdditionalParams.text
	property alias cfg_UpdateInterval: cfgUpdateInterval.value
	
	GridLayout {
		id: pageColumn
		anchors.fill: parent
		rows: 3
		columns: 2
		QtControls.Label {
			text: i18n("Additional params for \"yandex-disk status\" command:")
            Layout.row: 0
            Layout.column: 0
            Layout.alignment: Qt.AlignLeft
		}
		QtControls.TextField {
			id: cfgAdditionalParams
            Layout.row: 0
            Layout.column: 1
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
		}
		QtControls.Label {
			text: i18n("Update info every ... minutes:")
            Layout.row: 1
            Layout.column: 0
            Layout.alignment: Qt.AlignLeft
		}
		QtControls.SpinBox {
			id: cfgUpdateInterval
            Layout.row: 1
            Layout.column: 1
            Layout.alignment: Qt.AlignLeft
            minimumValue: 1
            maximumValue: 10
		}
		Row {
			Layout.row: 2
			Layout.column: 0
			Layout.columnSpan: 2
			Layout.alignment: Qt.AlignLeft
			Layout.fillHeight: true
		}
	}
}
