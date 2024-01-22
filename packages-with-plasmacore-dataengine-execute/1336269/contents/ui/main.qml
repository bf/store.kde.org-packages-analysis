import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 2.0 as QtControls
Item {
    

    
  	PlasmaCore.DataSource {
        id: executable
        property int lastline: 1		
		engine: "executable"
		connectedSources: []
		onNewData: {
            var lines = data["stdout"].split(/\r?\n/);
            var i;
            var linenumber;
            for (i = 0; i <= lines.length - 1; i++) {               
                linenumber = parseInt(lines[i].substring(0,7).trim());
                if(linenumber > executable.lastline) {
                    executable.lastline = linenumber;   
                    output.text = output.text + lines[i].substring(7) + '\n';
                    scrollbar.increase();
                } 
            }
            disconnectSource("cat -n " + plasmoid.configuration.filename + " | tail")
		}
	}
    
   
   Flickable {
    id: flickable
    anchors.fill: parent

    QtControls.TextArea.flickable: QtControls.TextArea {
        id: output
        text: ""
        wrapMode: QtControls.TextArea.Wrap
    }

    QtControls.ScrollBar.vertical: QtControls.ScrollBar { 
        id: scrollbar
        stepSize: 2
    }
}
    
   
        
	Timer {
		id: timer
		interval: 10000
		running: true
		repeat: true
		onTriggered: {
            if(plasmoid.configuration.filename.length && !executable.connectedSources.length) {            
                executable.connectSource("cat -n " + plasmoid.configuration.filename + " | tail")
            }
		}

		Component.onCompleted: {
			triggered()
		}
	}        
        
    Component.onCompleted: {
        output.text = ''
        if(plasmoid.configuration.filename.length) {
            executable.connectSource("cat -n " + plasmoid.configuration.filename + " | tail")
        }        
    }        
    
}
