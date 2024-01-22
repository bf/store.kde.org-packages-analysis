import QtQuick 2.12
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import Qt.labs.platform 1.1 as Labs
import Qt.labs.folderlistmodel 2.15

Item {
    id: root
    width: 300
    height: 300
    property string folder: Labs.StandardPaths.writableLocation(
                                Labs.StandardPaths.PicturesLocation)
    property int quality: plasmoid.configuration.quality
    property bool exif: plasmoid.configuration.exif
    property string postfix: plasmoid.configuration.postfix
    property string answer
    property int count: -1
    property int doneCount: 0
    property int skipCount: 0
    property int errorCount: 0
    property int totalSave: 0
    property bool isValid: false
    property bool isProcess: false
    property bool statistic: false
    Plasmoid.hideOnWindowDeactivate: false
    Component.onCompleted: {
        fileModel.clear()
    }
    ListModel {
        id: fileModel
        ListElement {
            name: ""
            path: ""
            valid: false
            status: ""
            dest: ""
            src_size: 0
            dest_size: 0
            percent: 0
        }
    }
    FolderListModel {
        id: sizeModel
        folder: root.folder
    }

    Plasmoid.compactRepresentation: Item {
        id: compRoot
        PlasmaCore.IconItem {
            id: ima
            source: "viewimage"
            width: parent.height
            height: parent.height
            anchors.centerIn: parent
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
        width: parent.width
        ColumnLayout {
            width: parent.width
            height: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true
            RowLayout {
                Layout.fillWidth: true
                PlasmaComponents.Button {
                    id: button
                    enabled: !root.isProcess
                    icon.name: "insert-image"
                    text: "Select image(s)"
                    onClicked: {
                        fileDialog.open()
                    }
                }
                Item {
                    Layout.fillWidth: true
                }

                PlasmaComponents.Button {
                    id: clear
                    enabled: fileModel.count > 0
                    icon.name: root.isProcess ? "dialog-cancel" : "edit-clear-all"
                    text: root.isProcess ? i18n("Cancel") : i18n("Clear")
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        if (root.isProcess) {
                            root.isProcess = false
                        } else {
                            fileModel.clear()
                            root.statistic = false
                            root.count = 0
                            root.doneCount = 0
                            root.skipCount = 0
                            root.errorCount = 0
                            root.totalSave = 0
                            root.isProcess = false
                        }
                    }
                }
            }

            ListView {
                id: list
                model: fileModel
                width: parent.width
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                spacing: 1
                delegate: Rectangle {
                    color: "transparent"
                    width: parent ? parent.width : 0
                    height: removebutton.paintedHeight
                    Rectangle {
                        anchors.fill: parent
                        color: !model.valid
                               || model.status == "error" ? PlasmaCore.ColorScope.negativeTextColor : model.status == "done" ? PlasmaCore.ColorScope.positiveTextColor : model.status == "already" ? PlasmaCore.ColorScope.highlightColor : "transparent"
                        opacity: 0.3
                        radius: units.smallSpacing
                        z: 0
                    }
                    PlasmaComponents.Label {
                        id: ind
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: units.smallSpacing
                        verticalAlignment: Text.AlignVCenter
                        text: model.index + 1
                        color: PlasmaCore.ColorScope.textColor
                    }
                    PlasmaComponents.Label {
                        id: label
                        anchors.left: ind.right
                        anchors.leftMargin: units.smallSpacing
                        anchors.right: removebutton.left
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        text: model.name
                        color: PlasmaCore.ColorScope.textColor
                        elide: Text.ElideRight
                        clip: true
                        PlasmaCore.ToolTipArea {
                            mainText: model.status == "already" ? i18n("Skipped") : model.status == "done" ? i18n("Done") : model.status == "error" ? i18n("Error") : ""
                            subText: !model.valid ? "File must be below 5MB" : model.status == "already" ? i18n("Image is already optimized") : model.status == "done" ? i18n("Saved") + " " + formatBytes(model.src_size - model.dest_size) : model.status == "error" ? "Error with upload" : ""
                            anchors.fill: parent
                            interactive: true
                            icon: model.status
                                  == "already" ? "dialog-information" : model.status
                                                 == "done" ? "dialog-positive" : "dialog-error"
                        }
                    }
                    PlasmaComponents.BusyIndicator {
                        id: status
                        height: removebutton.height
                        width: height
                        anchors.verticalCenter: parent.verticalCenter
                        visible: model.status == "busy"
                                 || model.status == "wait"
                        anchors.right: parent.right
                        anchors.rightMargin: units.smallSpacing
                    }
                    PlasmaCore.IconItem {
                        id: removebutton
                        height: units.iconSizes.smallMedium
                        width: height

                        rotation: 0
                        source: model.status == "ready"
                                || model.status == "error" ? "final_activity" : model.status == "done" ? "games-solve" : model.status == "wait" ? "clock" : model.status == "already" ? "help-contextual" : "license"
                        anchors.right: parent.right
                        anchors.rightMargin: units.smallSpacing
                        MouseArea {
                            visible: model.status == "ready"
                                     || model.status == "error"
                                     && model.valid == false
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                fileModel.remove(model.index)
                            }
                        }

                        RotationAnimation {
                            duration: 1000
                            target: removebutton
                            loops: Animation.Infinite
                            from: 360
                            to: 0
                            running: model.status == "busy"
                            direction: RotationAnimation.Counterclockwise
                            onRunningChanged: {
                                removebutton.rotation = 0
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: qua
                Layout.alignment: Qt.AlignBottom
                width: parent.width

                PlasmaComponents.Label {
                    visible: !root.statistic
                    text: i18n("Quality")
                }

                PlasmaComponents.SpinBox {
                    visible: !root.statistic
                    editable: true
                    enabled: checkModel() && fileModel.count > 0
                    id: quality
                    from: 0
                    to: 100
                    value: root.quality
                    stepSize: 1
                    inputMethodHints: Qt.ImhDigitsOnly
                    textFromValue: function (value) {
                        return value + "%"
                    }
                    valueFromText: function (text) {
                        return parseInt(text)
                    }

                    onValueModified: {
                        root.quality = quality.value
                    }
                }
                Item {
                    Layout.fillWidth: true
                    visible: !root.statistic
                }
                PlasmaComponents.Switch {
                    visible: !root.statistic
                    enabled: checkModel() && fileModel.count > 0
                    id: exif
                    checked: root.exif
                    text: i18n("Keep exif")
                    onCheckedChanged: {
                        root.exif = exif.checked
                    }
                }
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    visible: root.statistic
                    text: !root.isProcess
                          && root.statistic ? i18n("Job is done!") : i18n(
                                                  "Processing %1/%2 images",
                                                  root.count + 1,
                                                  fileModel.count)
                }
            }
            PlasmaComponents.Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                visible: root.statistic
                text: i18n("%1 done, %2 skipped, %3 errors", root.doneCount,
                           root.skipCount, root.errorCount)
            }
            RowLayout {
                Layout.alignment: Qt.AlignBottom
                width: parent.width
                Item {
                    Layout.fillWidth: true
                }

                PlasmaComponents.Button {
                    id: compress
                    visible: !root.statistic
                    icon.name: "upload-media"
                    enabled: checkModel() && fileModel.count > 0
                    Layout.alignment: Qt.AlignHCenter
                    text: i18n("Start compression")
                    onClicked: {
                        compressImage()
                    }
                }
                PlasmaComponents.Label {
                    visible: root.statistic
                    text: i18n("You totally saved ") + formatBytes(
                              root.totalSave)
                }
                Item {
                    Layout.fillWidth: true
                }
            }

            Labs.FileDialog {
                id: fileDialog
                title: i18n("Select image(s)")
                nameFilters: ["Images(*.png *.jpg *.jpeg *.gif *.bmp *.tif *.tiff)"]
                fileMode: Labs.FileDialog.OpenFiles
                folder: Labs.StandardPaths.writableLocation(
                            Labs.StandardPaths.PicturesLocation)
                onFolderChanged: {
                    root.folder = folder
                }

                onAccepted: {
                    root.count = 0
                    root.doneCount = 0
                    root.skipCount = 0
                    root.errorCount = 0
                    root.totalSave = 0
                    root.isProcess = false
                    root.statistic = false
                    getFiles()
                }
                function getFiles() {
                    fileModel.clear()
                    for (var i = 0; i < fileDialog.files.length; i++) {
                        var name = fileDialog.files[i].split("/")
                        name = name[name.length - 1]
                        fileModel.set([i], {
                                          "name": name,
                                          "path": fileDialog.files[i],
                                          "status": "ready"
                                      })
                    }
                    for (var i = 0; i < fileModel.count; i++) {
                        if (sizeModel.indexOf(fileModel.get(i).path) !== -1) {
                            if (sizeModel.get(sizeModel.indexOf(
                                                  fileModel.get(i).path),
                                              "fileSize") < 5242880) {
                                fileModel.set([i], {
                                                  "valid": true
                                              })
                            } else {
                                fileModel.set([i], {
                                                  "valid": false
                                              })
                                fileModel.set([i], {
                                                  "status": "error"
                                              })
                            }
                        }
                    }
                    checkModel()
                }
            }
        }
    }
    PlasmaCore.DataSource {
        id: upload
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
        target: upload
        onExited: {
            try {
                var out = JSON.parse(stdout)
                fileModel.setProperty(root.count, "dest", out.dest)
                fileModel.setProperty(root.count, "src_size", out.src_size)
                fileModel.setProperty(root.count, "dest_size", out.dest_size)
                fileModel.setProperty(root.count, "percent", out.percent)
                if (fileModel.get(root.count).percent == 0) {
                    fileModel.setProperty(root.count, "status", "already")
                    root.skipCount = root.skipCount + 1
                    if (root.count < fileModel.count - 1 && root.isProcess) {
                        root.count = root.count + 1
                        compressImage(root.count)
                    } else {
                        root.isProcess = false
                    }
                } else {

                    var link = fileModel.get(root.count).dest
                    fileModel.setProperty(root.count, "status", "busy")
                    downloadReady(link)
                }
            } catch (error) {
                fileModel.setProperty(root.count, "status", "error")
                root.errorCount = root.errorCount + 1
                if (root.count < fileModel.count - 1 && root.isProcess) {
                    root.count = root.count + 1
                    compressImage(root.count)
                } else {
                    root.isProcess = false
                }
            }
        }
    }

    PlasmaCore.DataSource {
        id: download
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
        target: download
        onExited: {
            var sourceFile = cmd.split("/")
            sourceFile = sourceFile[sourceFile.length - 1]
            fileModel.setProperty(root.count, "status", "done")
            root.totalSave = root.totalSave + (fileModel.get(
                                                   root.count).src_size - fileModel.get(
                                                   root.count).dest_size)
            root.doneCount = root.doneCount + 1
            if (root.count < fileModel.count - 1 && root.isProcess) {
                root.count = root.count + 1
                compressImage(root.count)
            } else {
                root.isProcess = false
            }
        }
    }
    function compressImage(step) {
        root.isProcess = true
        root.statistic = true
        upload.exec("curl -k -F 'files=@" + fileModel.get(step).path.substring(
                        7) + "' 'https://api.resmush.it/ws.php?qlty=" + quality
                    + "&exif=" + exif + "'")
        fileModel.setProperty(step, "status", "wait")
    }
    function checkModel() {
        var j = 0
        for (var i = 0; i < fileModel.count; i++) {
            if (fileModel.get(i).valid == false) {
                j = j + 1
            }
        }
        if (j > 0) {
            return false
        } else {
            return true
        }
    }
    function downloadReady(link) {
        var name = link.split("/")
        name = name[name.length - 1]
        name = name.replace(/(\.[\w\d_-]+)$/i, root.postfix + '$1')
        download.exec("curl -s -o " + root.folder.substring(
                          7) + name + " " + link)
    }
    function countReady() {
        var j = 0
        for (var i = 0; i < fileModel.count; i++) {
            if (fileModel.get(i).status == "done") {
                j = j + 1
            }
            return j
        }
    }

    function formatBytes(a, b) {
        if (0 == a)
            return "0 Bytes"
        var c = 1024, d = b
                      || 2, e = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"], f = Math.floor(Math.log(a) / Math.log(c))
        return parseFloat((a / Math.pow(c, f)).toFixed(d)) + " " + e[f]
    }
}
