import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    
    property alias cfg_speed: speed.value;

    GridLayout {
        Layout.fillWidth: true;
        columns: 2;
        rows: 4;
        Image{
            Layout.column:2
            Layout.row: 1
            id:body;
            source: "../../images/snail_14.svg";
            rotation:0;
        }
      
      Text {
            Layout.row: 1
            Layout.column:1
            text: i18n('<p><b>
                          <a href=\"http://konstantinz.byethost32.com/snail_desktop.htm\">Desktop Snail 1.0</a>
                        </b></p>
                       <p>Real live snail crawl on you desktop.</p>
                       <p><a href=\"mailto:konstantinz@bk.ru\">Konstantin Zemogleadchuk</a></p>
                       ');
            Layout.alignment: Qt.AlignLeft;
            onLinkActivated: Qt.openUrlExternally(link)
            }
        

       Label {
            Layout.row: 2
            Layout.column:1
            text: i18n('<b>Snail speed:</b>');
            //Layout.alignment: Qt.AlignLeft;
        }
       Slider {
           Layout.row: 3
           Layout.column:1
           id: speed;
           maximumValue: 50.0;
           stepSize: 1.0;
           
        }
        

    }
    
}
