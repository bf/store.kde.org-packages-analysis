/*
    Copyright 2016 Konstantin Zemoglyadchuk

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of
    the License or (at your option) version 3 or any later version
    accepted by the membership of KDE e.V. (or its successor approved
    by the membership of KDE e.V.), which shall act as a proxy
    defined in Section 14 of version 3 of the license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.2
import QtQuick.Window 2.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../scripts/animation.js" as SnailAnimation


Item{
    id:root
    
    Plasmoid.title: "Desktop snail";
    Plasmoid.backgroundHints: "NoBackground";

     
    Image{
        id:icon;
        visible:false
        source: "../images/icon.svg";
        rotation:0;
        x:0;
        y:0;
        width:50;
        height:50;
        MouseArea {
            anchors.fill: parent
            onClicked: { body.x = 0; 
                         body.y = 0; 
                         shell.x = 0;
                         shell.y = 0;

                         icon.visible = false

                
            }
        }
    }

    Item{
        id:snail;
    
        Image{
            id:body;
            source: "../images/snail_1.svg";
            rotation:0;
        }

    Image{
        id:turn_around;
        source: "../images/snail_13.svg";
        rotation:0;
        visible:false;
    }

    Image{
        id:shell;
        source: "../images/shell_1.svg";
        rotation:30;
    }

    MouseArea {
        anchors.fill: body;
            
            onClicked: {
                SnailAnimation.switchBehavior('hide_into_the_shell')
                icon.visible = true
          
            }
            onDoubleClicked: {
               SnailAnimation.switchBehavior('crawl')
               icon.visible = false
            }
            
            
        } 

    }
  
    
    Timer {
    id: crawl_animation;
    interval: 200;
    repeat: true;
    running: true;
        onTriggered:{
            SnailAnimation.animate();
            SnailAnimation.move();
        }
    }

    Timer {
        id: turn_around_animation;
        interval: 200;
        repeat: true;
        running: false;
        onTriggered:{
            SnailAnimation.turnAround();
        }
    }
    
    Timer {
        id: shellWiggle;
        interval: 2500;
        repeat: true;
        running: true;
        onTriggered:{
            SnailAnimation.shellWiggle();
        }
    }

    Timer {
        id: getDirection
        interval: Math.random()*5000
        repeat: true
        running: true
        onTriggered:{
            SnailAnimation.definrBorders();
            getDirection.interval = (Math.random() * (60 - 10) + 10)*1000;
            
        }
    }
    
    Timer {
        id: hiding_animation;
        interval: 200;
        repeat: true;
        running: false;
        onTriggered:{
            SnailAnimation.hideIntoTheShell();
        }
    }
    PlasmaCore.DataSource {
        id: cursorPositionSource;
        engine: "mouse";
        connectedSources: ["Position"];
        
    }
    
    PlasmaCore.DataSource {
        id: executeSource
        property string xrnd: "no"
        property int availableWidth: 0
        engine: "executable"
        connectedSources: ["xrandr -q | grep '\*'"]
        
            onNewData: {
           
                var trimmedStdout = data.stdout.trim();
                xrnd = trimmedStdout;
                var sta = executeSource.xrnd;
                var stb= sta.replace("x"," ");
                var myScreenResolution = stb.split(' ');
                plasmoid.configuration.availableWidth = myScreenResolution[0];
                plasmoid.configuration.availableHeight = myScreenResolution[1];
             
          }
        
    }

    Component.onCompleted: {
        
       if(plasmoid.configuration.first_start > 0){
      //Если плазмоид запускается впервые (в конфиге стоит значение 1)
           //Узнаем из dataEngane позицию курсора который в этот момент должен находится над плазмоидом
            var cursorPos = cursorPositionSource.data["Position"]["Position"]; 
            plasmoid.configuration.xCursorPos = cursorPos.x;
            plasmoid.configuration.yCursorPos = cursorPos.y;
            plasmoid.configuration.first_start = 0;
       }
       
       print("cursor = " + plasmoid.configuration.xCursorPos + "; " + plasmoid.configuration.yCursorPos);
       SnailAnimation.initialize();
    
    }
    
}
