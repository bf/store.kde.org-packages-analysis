import QtQuick 2.7
import QtQuick 2.15 as QtQuick214
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore





Item {
	anchors.fill: parent
	Layout.fillWidth: true
	Layout.fillHeight: true
	Layout.preferredWidth: 5000
	Plasmoid.constraintHints: PlasmaCore.Types.CanFillArea
	
	property int refreshInterval : 1000 * plasmoid.configuration.feedRefreshInterval
	property int flickInterval : plasmoid.configuration.scrollSpeed
	property int flickWidth : plasmoid.configuration.scrollWidth
	property int flickDirection : -1
	property bool flickEnabled : true
	
	property color  feedTitleFontColor : plasmoid.configuration.feedTitleFontColor
	property int    feedTitleFontSize : plasmoid.configuration.feedTitleFontSize
	property string feedTitleFontFamily : plasmoid.configuration.feedTitleFontFamily
	property bool   feedTitleFontBold: plasmoid.configuration.feedTitleFontBold
	property bool   feedTitleFontItalic: plasmoid.configuration.feedTitleFontItalic
	
	property color feedLinkFontColor : plasmoid.configuration.feedLinkFontColor
	property int   feedLinkFontSize : plasmoid.configuration.feedLinkFontSize
	property bool  feedLinkVisible : plasmoid.configuration.feedLinkVisible
	property bool  feedLinkFontBold : plasmoid.configuration.feedLinkFontBold
	property bool  feedLinkFontItalic : plasmoid.configuration.feedLinkFontItalic
	property string feedLinkFontFamily : plasmoid.configuration.feedLinkFontFamily
	
	property color feedDateFontColor : plasmoid.configuration.feedDateFontColor
	property int   feedDateFontSize : plasmoid.configuration.feedDateFontSize
	property bool  feedDateVisible : plasmoid.configuration.feedDateVisible
	property bool  feedDateFontBold : plasmoid.configuration.feedDateFontBold
	property bool  feedDateFontItalic : plasmoid.configuration.feedDateFontItalic
	property string feedDateFontFamily : plasmoid.configuration.feedDateFontFamily
	
	property color feedDescFontColor : plasmoid.configuration.feedDescFontColor
	property int   feedDescFontSize : plasmoid.configuration.feedDescFontSize
	property bool  feedDescVisible : plasmoid.configuration.feedDescVisible
	property bool  feedDescFontBold : plasmoid.configuration.feedDescFontBold
	property bool  feedDescFontItalic : plasmoid.configuration.feedDescFontItalic
	property bool  feedDescClip : plasmoid.configuration.feedDescClip
	property bool  feedDescWordWrap : plasmoid.configuration.feedDescWordWrap
	property string feedDescFontFamily : plasmoid.configuration.feedDescFontFamily
	
	property color  channelTitleFontColor : plasmoid.configuration.channelTitleFontColor
	property int    channelTitleFontSize : plasmoid.configuration.channelTitleFontSize
	property string channelTitleFontFamily : plasmoid.configuration.channelTitleFontFamily
	property bool   channelTitleFontBold: plasmoid.configuration.channelTitleFontBold
	property bool   channelTitleFontItalic: plasmoid.configuration.channelTitleFontItalic
	property bool   channelTitleVisible: plasmoid.configuration.channelTitleVisible
	
	property int   feedPadding : plasmoid.configuration.feedPadding
	
	property int   channelThumbnailSize : 50
	property bool  channelThumbnailsVisible : true
	property bool  channelThumbnailsRound : true
	
	property int flickMarginTop :   plasmoid.configuration.flickMarginTop
	property int flickMarginBottom :   plasmoid.configuration.flickMarginBottom
	property int flickMarginLeft :   plasmoid.configuration.flickMarginLeft
	property int flickMarginRight :   plasmoid.configuration.flickMarginRight
	
	property bool  separatorVisible : plasmoid.configuration.separatorVisible
	property color separatorColor : plasmoid.configuration.separatorColor
	property int   separatorWidth : plasmoid.configuration.separatorWidth
	
	property variant urls: plasmoid.configuration.urlList.split('\n').filter(validUrl).map(urlFix)
	property string  browsercmd: plasmoid.configuration.browser
	
	function stripString (str) {
		str = str.trim();
		var regex = /(<img.*?>)/gi;
		str = str.replace(regex, "");
		regex = /&#228;/gi;
		str = str.replace(regex, "ä");
		regex = /&#246;/gi;
		str = str.replace(regex, "ö");
		regex = /&#252;/gi;
		str = str.replace(regex, "ü");
		regex = /&#196;/gi;
		str = str.replace(regex, "Ä");
		regex = /&#214;/gi;
		str = str.replace(regex, "Ö");
		regex = /&#220;/gi;
		str = str.replace(regex, "Ü");
		regex = /&#223;/gi;
		str = str.replace(regex, "ß");
		
		return str;
	}
	function validUrl(loc) {
		// FIXME
		return loc != "";
	}
	
	function urlFix(loc) {
		// FIXME
		return loc;
	}
	
	
	
	Timer {
		id: flickTimer
		interval: flickInterval
		running: flickEnabled
		repeat:true
		onTriggered: {
			rssFlickable.flick(flickWidth*flickDirection,0)
			//console.debug("flick from "+rssFlickable.contentX+" by "+(flickWidth*flickDirection) +" end:"+rssFlickable.atXEnd )
			if( (rssFlickable.atXEnd && flickDirection<=0) || (rssFlickable.atXBeginning && flickDirection>0) ){
				flickDirection = flickDirection * -1
				console.log("flipping flick direction")
			}
			
		}
	}
	
	
	PlasmaCore.DataSource {
        id: command
        engine: "executable"
        connectedSources: []
        onNewData: {
                var stdout = data["stdout"]
                exited(sourceName, stdout)
                disconnectSource(sourceName) // cmd finished
        }
        
        function exec(cmd) {
			console.log("executing : ",cmd)
                connectSource(cmd)
        }
        signal exited(string sourceName, string stdout)

    }
	
	Flickable{
		id: rssFlickable
		clip: true
		anchors {
			left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom;
			leftMargin: flickMarginLeft ; rightMargin: flickMarginRight; topMargin: flickMarginTop; bottomMargin: flickMarginBottom
		}
		interactive: true
		flickableDirection: Flickable.HorizontalFlick
		contentHeight: contentColumn.height
		contentWidth: contentColumn.width
		Row {
			id: contentColumn
			
			Repeater {
				id: rssRepeater
				model: urls
				
				delegate : Row{
					property string thisUrl : urls[index].trim()
					
					XmlListModel {
						id: xmlChannelModel
						source: thisUrl
						query: "/rss/channel[1]"
						XmlRole { name: "channelTitle"; query: "title/string()" }
						XmlRole { name: "channelLink"; query: "link/string()" }
						XmlRole { name: "channelDesc"; query: "description/string()" }
						onSourceChanged: {
							reload()
							console.log("reloaded channelModel for "+thisUrl)
						}
					}
					
					XmlListModel {
						id: xmlModel
						source: thisUrl
						query: "/rss/channel/item"
						//namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
						
						XmlRole { name: "title"; query: "title/string()" }
						XmlRole { name: "pubDate"; query: "pubDate/string()" }
						XmlRole { name: "description"; query: "description/string()" }
						XmlRole { name: "link"; query: "link/string()"; isKey:true}
						
						//XmlRole { name: "thumbnail"; query: "media:thumbnail/@url/string()" }
						
						//onStatusChanged: busyIndicator.visible = true // This indicates that we started loading new entries
						//onStatusChanged: busyIndicator.visible = count
						onStatusChanged: {
							if (status==XmlListModel.Ready) {
								busyIndicator.visible=false
								console.log("xmlModel.status changed: Ready : "+thisUrl)
							}
							else if (status==XmlListModel.Loading) {
								busyIndicator.visible=true
								errorInfo.visible=false
								console.log("xmlModel.status changed: Loading : "+thisUrl)
							}
							else if (status==XmlListModel.Error) {
								busyIndicator.visible=false
								busyIndicator.visible=true
								console.log("xmlModel.status changed: Error : "+thisUrl)
								console.error(errorString())
							}
						}
					}
					
					Timer {
						id: refreshTimer
						interval: refreshInterval
						running: true
						repeat:true
						onTriggered: {
							console.log("reloading rss feed from "+thisUrl)
							xmlModel.reload()
							xmlChannelModel.reload()
						}
						
					}
				
					
					Repeater {
						id: channelRepeater
						model: xmlChannelModel
						delegate:  Repeater {
							id: contentRepeater
							model: xmlModel
							delegate: Column {
								spacing: feedPadding
								property int channelIndex: index
								Row {
									Column {
										id: feedColumn
										width: ((!feedDescVisible || feedDescWordWrap || feedDescClip) ? titleText.width : Math.max(descText.width,titleText.width))
										Row{ //first Line (channelTitle+feedDate)
											spacing:10
											//height: channelTitleText.height>dateText.height?channelTitleText.height:dateText.height
											Text{
												id: channelTitleText
												text: channelTitle.trim()
												color: channelTitleFontColor
												visible: channelTitleVisible
												font.bold: channelTitleFontBold
												font.italic: channelTitleFontItalic
												font.pixelSize: channelTitleFontSize
												font.family: channelTitleFontFamily
												anchors.verticalCenter: parent.verticalCenter 
												MouseArea {
													id: channelTitleMouseArea
													anchors.fill: parent
													hoverEnabled: true
													onEntered: flickEnabled=false
													onExited:flickEnabled=true
													//onClicked: Qt.openUrlExternally(link)
													onClicked: command.exec("'"+browsercmd+"' '"+link+"'")
												}
											}
											Text {
												id: dateText
												text: pubDate
												color: feedDateFontColor
												visible: feedDateVisible
												font.bold:feedDateFontBold
												font.italic: feedDateFontItalic
												font.family: feedDateFontFamily
												font.pixelSize: feedDateFontSize
												anchors.verticalCenter: parent.verticalCenter 
												//font.underline: feedLinkMouseArea.containsMouse || feedTitleMouseArea.containsMouse || feedDescMouseArea.containsMouse || feedDateMouseArea.containsMouse
												MouseArea {
													id: feedDateMouseArea
													anchors.fill: parent
													hoverEnabled: true
													onEntered: flickEnabled=false
													onExited:flickEnabled=true
													//onClicked: Qt.openUrlExternally(link)
													onClicked: command.exec("'"+browsercmd+"' '"+link+"'")
												}
											}
										}
										Text { 
											id:titleText
											text : title.trim()
											color: feedTitleFontColor
											font.bold: feedTitleFontBold
											font.italic: feedTitleFontItalic
											font.family: feedTitleFontFamily
											font.pixelSize : feedTitleFontSize
											font.underline: feedLinkMouseArea.containsMouse || feedTitleMouseArea.containsMouse || feedDescMouseArea.containsMouse || feedDateMouseArea.containsMouse
											MouseArea {
												id: feedTitleMouseArea
												anchors.fill: parent
												hoverEnabled: true
												onEntered: flickEnabled=false
												onExited:flickEnabled=true
												//onClicked: Qt.openUrlExternally(link)
												onClicked: command.exec("'"+browsercmd+"' '"+link+"'")
											}
										}
										Text {
											id: urlText
											text: link
											color: feedLinkFontColor
											visible: feedLinkVisible
											width: titleText.width
											clip: true
											font.family: feedLinkFontFamily
											font.bold: feedLinkFontBold
											font.italic: feedLinkFontItalic
											//font.underline: feedLinkMouseArea.containsMouse || feedTitleMouseArea.containsMouse || feedDescMouseArea.containsMouse || feedDateMouseArea.containsMouse
											font.pixelSize: feedLinkFontSize
											MouseArea {
												id: feedLinkMouseArea
												anchors.fill: parent
												hoverEnabled: true
												onEntered: flickEnabled=false
												onExited:flickEnabled=true
												//onClicked: Qt.openUrlExternally(link)
												onClicked: command.exec("'"+browsercmd+"' '"+link+"'")
											}
										}
										Text {
											id: descText
											text : stripString(description).trim()
											visible: feedDescVisible
											wrapMode : feedDescWordWrap ? Text.WordWrap: Text.NoWrap
											width: feedDescWordWrap || feedDescClip ? titleText.width : contentWidth
											color: feedDescFontColor
											clip: feedDescClip
											font.bold: feedDescFontBold
											font.italic: feedDescFontItalic
											font.family: feedDescFontFamily
											font.pixelSize : feedDescFontSize
											//font.underline: feedLinkMouseArea.containsMouse || feedTitleMouseArea.containsMouse || feedDescMouseArea.containsMouse || feedDateMouseArea.containsMouse
											MouseArea {
												id: feedDescMouseArea
												anchors.fill: parent
												hoverEnabled: true
												onEntered:flickEnabled=false
												onExited:flickEnabled=true
												//onClicked: Qt.openUrlExternally(link)
												onClicked: command.exec("'"+browsercmd+"' '"+link+"'")
											}
										}
									}
									Rectangle{
										id: spacerRect0
										width: feedPadding
										height: 10
										color: "transparent"
									}
									Column{
										visible: separatorVisible
										Row{
											Rectangle{
												id: seperatorRect
												width: separatorWidth
												height: rssFlickable.height
												color: separatorColor
											}
											Rectangle{
												id: spacerRect1
												width: feedPadding
												height: 10
												color: "transparent"
											}
										}
									}
								}
							}
						} // end of xmlModel Repeater
					}
				}
			}
		}
	}
	
	BusyIndicator {
		id: busyIndicator
		visible: false
		anchors.centerIn: parent
	}
	
	Text {
		id: errorInfo
		text: "hu! some error occured"
		anchors.centerIn: parent
		anchors.fill: parent
		clip: true
		color: "red"
		font.bold: true
		font.pixelSize: 20
	}
	
	
	QtQuick214.WheelHandler {
		//property: "rotation"
		onWheel: (event)=> {
			console.log("rotation", event.angleDelta.y, "scaled", rotation, "@", point.position, "=>", parent.rotation)
			rssFlickable.flick(event.angleDelta.y*10,0)
			if (event.angleDelta.y >=0){
				flickDirection=1
			}else{
				flickDirection=-1
			}
		}
	}
}

