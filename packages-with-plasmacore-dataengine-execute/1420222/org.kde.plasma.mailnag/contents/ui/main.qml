import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0
import QtMultimedia 5.4

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    property int updateInterval: 60000 * plasmoid.configuration.updateInterval
    property string client: ""
    property int counts: -1
    property int ind: 0
    property string imgurl: "../images/mail.svg"
    property var notif: []
    onCountsChanged: {
        getMails()
    }

    Component.onCompleted: {
        checkCl()
        checkMail()
        plasmoid.setAction("check", i18n("Check Email"), "view-refresh")
        plasmoid.setAction("markall", i18n("Mark all as read"),
                           "edit-clear-history")
        plasmoid.setAction("client", i18n("Open Email client"),
                           "mail-thread-watch")
    }

    ListModel {
        id: mailModel
        ListElement {
            datetime: ""
            date: ""
            time: ""
            subject: ''
            sender_name: ""
            sender_addr: ""
            account_name: ""
            ids: ""
        }
    }

    PlasmaCore.DataSource {
        id: checkClient
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

    PlasmaCore.DataSource {
        id: count
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

    PlasmaCore.DataSource {
        id: check
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

    PlasmaCore.DataSource {
        id: mark
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

    PlasmaCore.DataSource {
        id: notificationSource
        engine: "notifications"
        connectedSources: "org.freedesktop.Notifications"
    }

    Connections {
        target: checkClient
        onExited: {
            var formattedText = stdout.trim()
            root.client = formattedText
        }
    }

    Connections {
        target: executable
        onExited: {
            var formattedText = stdout.trim()
            if (formattedText != "[Argument: aa{sv} {}]") {
                // I know that is bullshit, it is temporary...
                var lis = formattedText.replace("[Argument: aa{sv} {",
                                                "").replace(
                            /\[Argument: a{sv}/g, "").replace("}]}]",
                                                              "}").split("],  ")
                for (var i = 0; i < lis.length; i++) {
                    lis[i] = lis[i].replace(/\= \[Variant\(int\)|\= \[Variant\(QString\)|\]|\[|"/g,
                                            "").replace(/id/g,
                                                        "ids").replace(/ : /g,
                                                                       "\" : \"").replace(/, /g, "\", \"").replace(/{/, "{\"").replace(/}$/, "\"}")

                    mailModel.append(JSON.parse(lis[i]))
                    var d = new Date(mailModel.get(i).datetime * 1000)
                    var date = (d.getDate() < 10) ? "0" + d.getDate(
                                                        ) : d.getDate()
                    var month = (d.getMonth() < 10) ? "0" + d.getMonth(
                                                          ) : d.getMonth()
                    var formattedDate = date + "." + month + "." + d.getFullYear()
                    var hours = (d.getHours() < 10) ? "0" + d.getHours(
                                                          ) : d.getHours()
                    var minutes = (d.getMinutes() < 10) ? "0" + d.getMinutes(
                                                              ) : d.getMinutes()
                    mailModel.set(i, {
                                      "date": formattedDate
                                  })
                    mailModel.set(i, {
                                      "time": hours + ":" + minutes
                                  })
                }
                var errorText = stderr
                root.notif[0] = mailModel.get(0).sender_addr
                root.notif[1] = mailModel.get(0).subject
            }
        }
    }

    Connections {
        target: count
        onExited: {
            var formattedText = stdout.trim()
            if (formattedText > root.counts && formattedText != 0
                    && plasmoid.configuration.notification == true) {
                notiftimer.start()
            }
            root.counts = formattedText
            root.ind = 0
        }
    }

    Connections {
        target: check
        onExited: {
            getCount()
        }
    }

    Connections {
        target: mark
        onExited: {
            getCount()
        }
    }
    function checkCl() {
        checkClient.exec("xdg-mime query default x-scheme-handler/mailto")
    }

    function action_client() {
        checkClient.exec("gtk-launch " + root.client)
    }

    function action_check() {
        checkMail()
    }

    function getMails() {
        mailModel.clear()
        executable.exec(
                    "qdbus --literal mailnag.MailnagService /mailnag/MailnagService GetMails")
    }

    function getCount() {
        count.exec("qdbus mailnag.MailnagService /mailnag/MailnagService GetMailCount")
    }

    function checkMail() {
        root.ind = 1
        check.exec("qdbus mailnag.MailnagService /mailnag/MailnagService CheckForMails")
        time.restart()
    }

    function markAsRead(ids) {
        mark.exec("qdbus mailnag.MailnagService /mailnag/MailnagService MarkMailAsRead " + ids)
    }
    function action_markall() {
        for (var i = 0; i < mailModel.count; i++) {
            var ids = mailModel.get(i).ids
            markAsRead(ids)
        }
    }

    function createNotification(title, text) {
        var service = notificationSource.serviceForSource("notification")
        var operation = service.operationDescription("createNotification")
        operation.appName = i18n("You have a new mail")
        operation["appIcon"] = "mail-message"
        operation.summary = i18n("From:") + " " + title
        operation["body"] = i18n("Subject:") + " " + text
        operation["timeout"] = 5000
        operation["soundFile"] = Qt.resolvedUrl("../sounds/bell.oga").replace(
                    "file://", "")
        service.startOperationCall(operation)
        if (plasmoid.configuration.sound === true) {
            sfx.source = operation["soundFile"]
            sfx.play()
        }
    }
    property Audio sfx: Audio {}

    Timer {
        id: notiftimer
        running: false
        repeat: false
        interval: 1000
        onTriggered: {
            createNotification(root.notif[0], root.notif[1])
            root.notif = []
        }
    }

    Plasmoid.compactRepresentation: Item {
        id: comp
        width: parent.width
        height: parent.width

        PlasmaCore.SvgItem {
            id: ima
            anchors.fill: parent
            width: parent.width
            height: parent.height
            svg: PlasmaCore.Svg {
                id: svg
                imagePath: Qt.resolvedUrl(root.imgurl)
            }
        }

        Rectangle {
            width: parent.width / 2
            height: parent.height / 2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "transparent"

            PlasmaComponents.Label {
                id: cnt
                Layout.fillWidth: true
                width: parent.width
                height: parent.height
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPointSize: 5
                font.pointSize: 60
                text: root.counts
                font.weight: Font.Bold
                visible: root.counts !== -1 && root.ind == 0
            }
            BusyIndicator {
                running: root.counts == -1 || root.ind == 1
                visible: root.counts == -1 || root.ind == 1
                width: parent.width
                height: parent.height
            }
        }
        MouseArea {
            id: mouseArea
            width: parent.width
            height: parent.width
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {

            }
            onExited: {

            }
            onClicked: {
                if (root.counts > 0) {
                    plasmoid.expanded = !plasmoid.expanded
                }
            }
        }
        PlasmaCore.ToolTipArea {
            id: toolTip
            width: parent.width
            height: parent.height
            anchors.fill: parent
            interactive: true
            mainText: "Mailnag for Plasma"
            subText: root.counts > 0 ? i18n("You have %1 unread emails.",
                                            root.counts) : i18n(
                                           "You have no unread emails.")
        }
    }

    Plasmoid.fullRepresentation: Item {
        id: full
        anchors.fill: parent
        implicitHeight: mailView.childrenRect.height > 50 || root.counts
                        == 1 ? mailView.childrenRect.height : 300 // fix for Ubuntu 18.04
        implicitWidth: mailView.childrenRect.width
        ListView {
            id: mailView
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 300
            contentHeight: childrenRect.height
            clip: true
            spacing: units.gridUnit
            model: mailModel
            anchors.fill: parent
            highlightFollowsCurrentItem: true
            Component.onCompleted: {

            }
            onChildrenChanged: {
                full.implicitHeight = mailView.childrenRect.height > 50
                        || root.counts == 1 ? mailView.childrenRect.height : 300
                full.implicitWidth = mailView.childrenRect.width
            }

            delegate: Item {
                id: tool
                width: mailView.width
                height: row.height
                property int preferredTextWidth: units.gridUnit * 10
                Layout.minimumWidth: childrenRect.width + units.gridUnit
                Layout.minimumHeight: childrenRect.height + units.gridUnit
                Layout.maximumWidth: childrenRect.width + units.gridUnit
                Layout.maximumHeight: childrenRect.height + units.gridUnit
                RowLayout {
                    id: row
                    clip: true
                    width: mailView.width
                    spacing: units.gridUnit

                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop
                        PlasmaComponents.Label {
                            text: model.date
                            id: date
                        }
                        PlasmaComponents.Label {
                            text: model.time
                            Layout.preferredWidth: date.width
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        PlasmaComponents.Label {
                            id: tooltipMaintext
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: i18n("From:") + " " + model.sender_name + " <"
                                  + model.sender_addr + ">"
                            visible: text !== ""
                            horizontalAlignment: Text.AlignLeft
                        }
                        PlasmaComponents.Label {
                            id: tooltipSubtext
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            text: i18n("Subject:") + " " + model.subject
                            opacity: 0.8
                            visible: text !== ""
                            maximumLineCount: 8
                        }
                    }
                }
                MouseArea {
                    id: mouseArea2
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    hoverEnabled: true
                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    width: row.width
                    Button {
                        anchors.rightMargin: units.smallSpacing
                        id: makeread
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        visible: mouseArea2.containsMouse ? true : false
                        tooltip: i18n("Mark as read")
                        iconName: "mail-mark-read"
                        z: 10
                        onClicked: {
                            markAsRead(model.ids)
                        }
                    }
                }

                Rectangle {
                    height: 1
                    width: row.width
                    color: PlasmaCore.ColorScope.textColor
                    anchors.top: row.bottom
                    anchors.topMargin: units.gridUnit / 2
                }
            }
        }
    }
    Timer {
        id: time
        interval: root.updateInterval
        running: true
        repeat: true
        onTriggered: {
            checkMail()
        }
    }
}
