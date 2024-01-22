import QtQuick 2.1
import QtQuick.Layouts 1.0
//import QtQuick.ListModel 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponent



Item {
  id: main
  property string subtext: i18n("Packages")
  property string title: Plasmoid.title
  Plasmoid.configurationRequired: true
  Plasmoid.toolTipSubText: subtext
  //Plasmoid.icon: packageModel.count > 0 ? "package-new" : "package-available"
  Plasmoid.icon: "package-new"
  Plasmoid.compactRepresentation: CompactRepresentation {}
  Plasmoid.fullRepresentation: FullRepresentation {}
  Plasmoid.switchWidth: units.gridUnit * 8
  Plasmoid.switchHeight: units.gridUnit * 8

  ListModel { id: packageModel
     /*
    ListElement {
      PackageName: "PackageName"
      FromVersion: "FromVersion"
      ToVersion: "ToVersion"
    }

    */
   }


  PlasmaCore.DataSource {
    id: "executable"
    engine: "executable"
    connectedSources: []
    //property string sourceName: ""
    onNewData: {
      var exitCode = data["exit code"]
      var exitStatus = data["exit status"]
      var stdout = data["stdout"]
      var stderr = data["stderr"]
      exited(sourceName, exitCode, exitStatus, stdout, stderr)
      disconnectSource(sourceName)
      //connectedSources.pop()
    }
    function exec(cmd) {

        //console.log("exec " + cmd)
        //sourceName = cmd
        //connectedSources.push(cmd)
        connectSource(cmd)

    }
    signal exited(string sourceName, int exitCode, int exitStatus, string stdout, string stderr )
  }

  Item {
    id: config
        //minium wait time is 15 min = 15000 * 60
    property int interval: Math.max(900000, plasmoid.configuration.pollinterval * 1000 * 60)
    //allow another package manager besides pacman (e.g. pacaur or packer)
    property string updateChecker: plasmoid.configuration.updatechecker || "checkupdates"
    property string updateChecker_aur: plasmoid.configuration.updatechecker_aur
    property string updateCommand: plasmoid.configuration.installationcommand || "pacman -Syu"

  }
  property string outputText: ''
  Connections {
    target: executable
    onExited: {
      //console.log ("onExited " + executable.sourceName)
      //console.log ("onExited " + config.updateChecker)
      //console.log( executable.sourceName === config.updateChecker)
      //console.log("onExited " + executable.sourceName)
      //console.log("exitCode: " + exitCode)
      //console.log("exitStatus: " + exitStatus)
      //console.log("stdout: " + stdout)
      //console.log("stderr: " + stderr)
      if ( sourceName === config.updateChecker ) {
         //console.log ("Updating model")

         var packagelines = stdout.split("\n")
         if ( packagelines.length > packageModel.count ) {
           //new Packages

         }
         packageModel.clear()
         for ( var i = 0; i < packagelines.length; i++) {
           var packagedetails = packagelines[i].split(" ")
           //console.log ("Appending Package: " + packagedetails[0])
           if ( packagelines[i].trim() != "") {
             packageModel.append( { PackageName: packagedetails[0],
                   FromVersion: packagedetails[1],
                   ToVersion: packagedetails[3],
                 })
           }
         }

      } else if (sourceName === config.updateChecker_aur) {
        //do not clear the packageModel
        //console.log("Updating aur model")
        var packagelines = stdout.split("\n")
        var pregex = /^\S+\s+\S+\s+(\S+)\s+(\S+)\s+\S+\s+(\S+)/;
        for ( var i = 0; i < packagelines.length; i++) {
          var packageline = packagelines[i];


          var parameters = pregex.exec(packageline);

          if ( parameters != null) {
            //console.log ("Appending Package: " + packagedetails[0])
            //console.log("package name " + parameters[1])
            packageModel.append( { PackageName: parameters[1],
                  FromVersion: parameters[2],
                  ToVersion: parameters[3]})
          }
        }
        timer.restart()
      }


    }
  }
  Timer {
    id: timer
    interval: config.interval
    running: true
    repeat: false
    onTriggered: {
      executable.exec(config.updateChecker)
      if (config.updateChecker_aur != null) {
        executable.exec(config.updateChecker_aur)
      }
    }

  }

  function action_updateSystem() {
     timer.stop()
     //executable.exec('konsole -e ' + config.updateCommand)
     executable.exec('konsole -e "' + plasmoid.configuration.installationcommand + '"')
     //clear the model in preparation for next run -- since updating software
     packageModel.clear()
     timer.start()
  }
  Component.onCompleted: {
    //console.log("onCompleted")
    plasmoid.status = PlasmaCore.Types.PassiveStatus
    plasmoid.setAction("action_updateSystem", i18n("Update System"), "package-install")
    //console.log("checkupdates " + plasmoid.configuration.updatechecker)
    executable.exec(plasmoid.configuration.updatechecker)
    executable.exec(plasmoid.configuration.updatechecker_aur)
    timer.start()
  }
}
