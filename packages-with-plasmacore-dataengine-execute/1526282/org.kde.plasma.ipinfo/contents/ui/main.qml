import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    anchors.centerIn: parent
    property string ip
    property string country
    property string code
    property string countryCode
    property string regionName
    property string city
    property string zip
    property string lat
    property string lon
    property string org
    property string query
    property string heading
    property bool wrongIP: false
    Plasmoid.hideOnWindowDeactivate: false
    onIpChanged: {
        getIpInfo(root.ip, false)
    }
    Component.onCompleted: {
        getIP()
    }
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }
    Connections {
        target: executable
        onExited: {
            var ips = stdout.trim()
            root.ip = ips
            getIpInfo(root.ip, false)
        }
    }
    Plasmoid.compactRepresentation: Item {
        PlasmaCore.IconItem {
            id: ic
            source: "network-connect"
            anchors.fill: parent
            Rectangle {
                width: parent.width / 3.5
                height: parent.height / 3.5
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: PlasmaCore.ColorScope.backgroundColor
                PlasmaComponents.Label {
                    id: coic
                    text: root.code
                    height: parent.height
                    width: parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    fontSizeMode: Text.Fit
                    font.pointSize: height
                }
            }
        }

        MouseArea {
            id: mouseArea
            width: parent.width
            height: parent.width
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                plasmoid.expanded = !plasmoid.expanded
            }
        }
    }
    Plasmoid.fullRepresentation: Item {
        Layout.preferredWidth: childrenRect.width * units.devicePixelRatio
        Layout.preferredHeight: childrenRect.height * units.devicePixelRatio
        Layout.fillHeight: true
        Layout.fillWidth: true
        ColumnLayout {
            Layout.fillWidth: true
            RowLayout {
                id: row
                Layout.fillHeight: true
                Layout.fillWidth: true
                PlasmaComponents.TextField {
                    id: input
                    Layout.fillWidth: true
                    validator: RegExpValidator {
                        regExp: /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/
                    }
                    placeholderText: i18n("Search IP Info...")
                    onTextChanged: {
                        if (this.text.length === 0) {
                            getIP()
                            // getIpInfo(root.ip, false)
                        }
                    }
                    onAccepted: {
                        if (input.text.length > 6) {
                            getIpInfo(this.text, true)
                        }
                    }
                    PlasmaCore.IconItem {
                        source: "edit-clear"
                        enabled: input.text.length > 0
                        height: parent.height
                        anchors.right: parent.right
                        anchors.rightMargin: units.smallSpacing
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked: {
                                if (input.text.length > 0) {
                                    input.text = ""
                                    getIP()
                                    //  getIpInfo(root.ip, false)
                                }
                            }
                        }
                    }
                }
                PlasmaComponents.ToolButton {
                    iconSource: "search"
                    tooltip: i18n("Search")
                    flat: true
                    enabled: input.text.length > 6
                    onClicked: {
                        getIpInfo(input.text, true)
                    }
                }
                PlasmaComponents.ToolButton {
                    iconSource: "task-recurring"
                    flat: true
                    tooltip: i18n("Check your IP")
                    onClicked: {
                        getIP()
                        input.text = ""
                        // getIpInfo(root.ip, false)
                    }
                }
            }
            RowLayout {
                PlasmaComponents.Label {
                    id: heading
                    text: root.heading
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            GridLayout {
                id: grid
                Layout.fillHeight: true
                Layout.fillWidth: true
                columns: 2
                columnSpacing: units.largeSpacing * units.devicePixelRatio
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    text: i18n("Country") + ": " + root.country
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: i18n("City") + ": " + root.city
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    text: i18n("Region") + ": " + root.regionName
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: root.zip !== "" ? i18n(
                                                "Zip") + ": " + root.zip : i18n(
                                                "Zip: N/A")
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    text: i18n("Latitude") + ": " + root.lat
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: i18n("Longitude") + ": " + root.lon
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    text: i18n("Provider") + ": " + root.org
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignRight
                    text: i18n("IP") + ": " + root.query
                }
            }
        }
    }

    function getIP() {
        executable.exec("wget -O - -q icanhazip.com")
    }
    function getIpInfo(ip, state) {
        var xmlhttp = new XMLHttpRequest
        var url = "http://ip-api.com/json/" + ip
        xmlhttp.open("GET", url)
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == xmlhttp.DONE) {
                if (xmlhttp.status == 200) {
                    var responce = JSON.parse(xmlhttp.responseText)
                    if (responce.status === "success") {
                        root.country = responce.country
                        if (state === false) {
                            root.code = responce.countryCode
                        }
                        root.countryCode = responce.countryCode
                        root.regionName = responce.regionName
                        root.city = responce.city
                        root.zip = responce.zip
                        root.lat = responce.lat
                        root.lon = responce.lon
                        root.org = responce.isp
                        root.query = responce.query
                        state === false ? root.heading = i18n(
                                              "Info about your IP ") : root.heading = i18n(
                                              "Info about IP ") + root.query
                    } else {
                        root.heading = i18n("Wrong IP address!")
                        root.country = i18n("N/A")
                        root.regionName = i18n("N/A")
                        root.city = i18n("N/A")
                        root.zip = i18n("N/A")
                        root.lat = i18n("N/A")
                        root.lon = i18n("N/A")
                        root.org = i18n("N/A")
                        root.query = responce.query
                    }
                }
            }
        }
        xmlhttp.send()
    }
    PlasmaNM.NetworkStatus {
        id: networkStatus

        onActiveConnectionsChanged: {
            getIP()
            getIpInfo(root.ip, false)
        }
    }
    //    Timer {
    //        id: timer
    //        running: true
    //        repeat: true
    //        interval: 30000
    //        onTriggered: {
    //            getIP()
    //        }
    //    }
}
