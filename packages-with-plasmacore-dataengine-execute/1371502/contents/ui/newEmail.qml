/*
 *   Copyright 2020 Dave Burbidge <dave@davescomputersystems.com.au>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.kquickcontrolsaddons 2.0

Item {
  id: newEmail

  property string command: plasmoid.configuration.command

  Layout.minimumWidth:  units.gridUnit * 12
  Layout.minimumHeight: units.gridUnit * 12

  Layout.preferredWidth: Layout.minimumWidth
  Layout.preferredHeight: Layout.minimumHeight

  Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

  Component.onCompleted:
  {
    plasmoid.addEventListener('ConfigChanged', configChanged);
  }

  function configChanged()
  {
    root.command = plasmoid.readConfig("command");
  }

  Plasmoid.compactRepresentation: PlasmaCore.IconItem
  {
    source: 'mail-message-new'
    width: units.iconSizes.medium
    height: units.iconSizes.medium
    active: mouseArea.containsMouse

    MouseArea
    {
      id: mouseArea
      anchors.fill: parent
      onClicked: runCommand()
      hoverEnabled: true
    }
  }

  PlasmaCore.DataSource
  {
    id: executable
    engine: "executable"
    connectedSources: []
    onNewData:
    {
      var exitCode = data["exit code"]
      var exitStatus = data["exit status"]
      var stdout = data["stdout"]
      var stderr = data["stderr"]
      exited(sourceName, exitCode, exitStatus, stdout, stderr)
      disconnectSource(sourceName) // cmd finished
    }

    function exec(cmd)
    {
      if(cmd)
      {
        connectSource(cmd)
      }
    }
    signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
  }

  function runCommand()
  {
    executable.exec(command) //("kmail --composer")
  }
}

