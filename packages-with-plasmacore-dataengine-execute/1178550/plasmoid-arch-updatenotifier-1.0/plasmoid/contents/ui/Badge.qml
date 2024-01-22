//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  This file is distributed under the GNU GPL 3.0 License

import QtQuick 2.2
import QtQuick.Controls 1.2

//-----------------------------------------------------------------------------------//
// Description: this control allows you to show a notification similar to those      //
// in most mobile devices. This control anchors automatically to its parent.         //
// The \c text parameter is used to display the notification.                        //
// The control is automatically resized to fit the notification inside a single line.//
// Enjoy!                                                                            //
//-----------------------------------------------------------------------------------//

// Screenshot: http://picpaste.com/pics/BadgeImg.1405294460.png

Rectangle {
    id: badge
    smooth: true

    // Allow the programmer to define the text to display.
    // Note that this control can display both text and numbers.
    property alias text: label.text

    // Create an animation when the opacity changes
    Behavior on opacity {NumberAnimation{}}

    // Setup the anchors so that the badge appears on the bottom right 
    // area of its parent
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    
    // This margin allows us to be "a little outside" of the object in which 
    // we add the badge
    anchors.margins: -parent.width / 5 + device.ratio(1)

    // Set a redish color (exactly the one used in OS X 10.10)
    color: "#ec3e3a"

    // Make the rectangle a circle
    radius: width / 2

    // Setup height of the rectangle (the default is 18 pixels)
    height: 18

    // Make the rectangle and ellipse if the length of the text is bigger than 2 characters
    width: label.text.length > 2 ? label.paintedWidth + height / 2 : height

    // Create a label that will display the number of connected users.
    Label {
        id: label
        color: "#fdfdfdfd"
        font.pixelSize: 9
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        
        // We need to have the same margins as the badge so that the text 
        // appears perfectly centered inside its parent.
        anchors.margins: parent.anchors.margins
    }
}
