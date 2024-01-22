import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground | PlasmaCore.Types.ConfigurableBackground
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        onNewData: {
                var stdout = data["stdout"]
                exited(sourceName, stdout)
                disconnectSource(sourceName) // cmd finished
        }
        
        function exec(cmd) {
                connectSource(cmd)
        }
        signal exited(string sourceName, string stdout)

    }
    function action_open() {
        executable.exec("$(xdg-open "+plasmoid.configuration.url_text+")");
    }
    function update_cm() {
        if(plasmoid.configuration.use_local_file_enabled) {
            Plasmoid.setAction("open", "Open file in text editor", "document-edit");
        } else if(plasmoid.configuration.url_text.replace(/\s+/g, '') == "") {
            Plasmoid.removeAction("open");
        } else {
            Plasmoid.setAction("open", "Open URL in browser", "internet-services");
        }
    }
    Plasmoid.fullRepresentation: Item {
        id: container
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                var xhr = new XMLHttpRequest;
                xhr.open("GET", plasmoid.configuration.url_text);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == XMLHttpRequest.DONE) {
                        var response = xhr.responseText;
                        switch(response) {
                            case '':
                                label.text = "Invalid URL. Right-click settings to set URL";
                                break;
                            default:
                                label.text = plasmoid.configuration.show_as_one_line ? response.replace(/\n/g, " ") + " " : response + " ";
                                // to force a reload
                                label.text = label.text.trim();
                                break;
                        }
                        update_cm();
                    }
                };
                xhr.send();
            }
        }
        PlasmaComponents.Label {
            id: label
            anchors.fill: parent
            text: "Click to refresh"
            textFormat: plasmoid.configuration.text_type == 0 ? Text.PlainText : Text.MarkdownText
            verticalAlignment: Text.AlignTop
            font.pointSize: plasmoid.configuration.font_size
        }
    }
    Component.onCompleted: {
        update_cm();
    }
}
