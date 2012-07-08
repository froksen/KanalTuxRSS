// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt 4.7
import "mediaplayer"
import "delegate"


Rectangle {
    id: mainwindow
    width: 200
    height: 400
    color: "transparent"

    /*Properties*/
    property string currentDescription: "Description"
    property string currentTitle: ""
    property string currentMediaurl: "MediaURL"
    property string currentPageurl: "CurrentPageurl"
    property string currentMediafile: currentMediaurl //"/home/froksen/Downloads/unreal_dm_-_Falling.mp3"
    property bool bodyMenuhidden: false


    /*Loaders*/
    Loader {
        id: audioPlayerLoader;
    }

    /* MAIN - This is the mainRow that devides the mainwindow into two rows */
    Column {
        id: mainRow
        width: mainwindow.width
        height: mainwindow.height


        Rectangle {
            id: mainHeaderrect;
            width: mainRow.width
            color: "transparent"
            clip: true
            //height: 200
        }
      Rectangle {
            id: mainBodyrect;
            //width: mainRow.width
            //anchors.fill: parent
            //clip: true
            color: "transparent"
            //anchors.fill: parent
            //height: mainRow.height-mainHeaderrect.height
        }
   }




    /* SECTION: BODY - Everything to do with the BODY */

    /* BODY layout - Creates the body layout */
    Row {
        //parent: mainBodyrect
        id: bodyRow
        parent: mainwindow
        width: parent.width
        height: parent.height
        anchors.top: mainHeaderrectangle.bottom


        Rectangle {
            id: bodyMenu
            //lagt 20 til bredden da det fixer problemet med at menuen bliver forkort.
            width: parent.width + 20
            height: parent.height
            color:  "transparent" //"#efefef"
            clip: true
        }

        Rectangle {
            clip: true
            id: bodyContent
            height: parent.height
            //anchors.fill: parent.width
            width:  mainHeaderrect.width - bodyMenu.width
           // color: "blue"
        }
    }

    /* BODY Menu*/

    Rectangle {
       id: rssFeedNotDownloadButton
       parent:  mainwindow
       width: feedModel.progress == 0 ? parent.width : 0
       height: feedModel.progress == 0 ? parent.height : 0
       color: "red"

       Timer {
           interval: 5000; running: true; repeat: feedModel.progress == 0 ? true : false
           onTriggered: {
               rssFeedNotDownloadButtonText.text = "<b>Ingen forbindelse</b> \n\n Forsøger hvert 5. sekund <br><br> Sidst forsøgt: " + Date().toString() + "<br> <br> - Tryk for at tvinge genopfriskning -"
               feedModel.reload()
           }
           }

       Text {
           id: rssFeedNotDownloadButtonText
           anchors.fill: parent
           text: feedModel.progress == 0 ? "<b>Ingen forbindelse</b> \n\n Forsøger hvert 5. sekund <br><br> Sidst forsøgt: " + Date().toString() + "<br> <br> - Tryk for at tvinge genopfriskning -" : ""
           verticalAlignment: Text.AlignBottom
           horizontalAlignment: Text.AlignHCenter
           color: "white"
           //font.weight: Font.DemiBold
           font.pointSize: 12
           wrapMode: Text.WordWrap
       }
       Binding {
                target:   rssFeedNotDownloadButtonText
                property: "text"
                value: ""
                when: feedModel.progress == 1
       }

       MouseArea {
           parent: rssFeedNotDownloadButton
           anchors.fill: parent
           onPressed:  {
               feedModel.reload()
               console.log("Reloading")
           }
       }

    }



    ListView {
        id: listviewMenu
        parent: bodyMenu
        height: parent.height
        width: currentTitle == "" ? parent.width - menuHidebutton.width*2 : parent.width - menuHidebutton.width
        //width: bodyMenu.width == menuHidebutton.width ? 0 : parent.width - menuHidebutton.width
        model: feedModel
        delegate: EpisodeDelegate{}
        clip: true
        anchors.left: bodyMenuscrollbar.left

    }

    Rectangle {
        clip: true
        id: menuHidebutton
        parent: bodyMenu
        height: parent.height
        width: 20
        color: bodyMenu.width == menuHidebutton.width ? "steelblue" : "#efefef"
        anchors.left: listviewMenu.right;


        Text {id: menuHidebottomtext; anchors.fill: parent; font.weight: Font.DemiBold ; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter ; text: bodyMenu.width == menuHidebutton.width ? "<\nM\nE\nN\nU\n<" : ">\nL\nU\nK\n>"; color: bodyMenu.width == menuHidebutton.width ? "white" : "black"}
//        Text {anchors.fill: parent ; verticalAlignment: Text.AlignVCenter; font.weight: Font.DemiBold ; text: menuHidebottomtext.text ; horizontalAlignment: Text.AlignHCenter; color: menuHidebottomtext.color }
//        Text {anchors.fill: parent ; verticalAlignment: Text.AlignBottom; font.weight: Font.DemiBold ; text: menuHidebottomtext.text ; horizontalAlignment: Text.AlignHCenter; color: menuHidebottomtext.color }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                if(!currentTitle == ""){
                    if(bodyMenu.width == menuHidebutton.width) {
                    bodyMenu.width = mainwindow.width
                    //bodyContent.width = 0
                    }
                    else {
                        bodyMenu.width = menuHidebutton.width
                        //bodyContent.width = mainwindow.width
                    }
                 }
            }
        }
    }

    /* BODY Page*/
    Flickable {
        parent: bodyContent
        id: bodyPageflickable
        width: parent.width; height: bodyMenu.height
        //contentWidth: bodyContentDescription.width
        //contentHeight: bodyContentDescription.height
        contentHeight: mainBodyrect.height
        contentWidth: bodyPageflickable.width
        //anchors.fill: parent
        flickDeceleration: Flickable.VerticalFlick
        clip: true

        onContentYChanged: {
            if(contentY< bodyContentDescription.height-100){
                contentY = contentY
                if(contentY<0)
                {
                   contentY = 0
                }

            }
         }


    Rectangle {
        height:parent.height
        width: parent.width -20
        //color: "blue"
        id: bodyTextRectangle



        Text {
            id: bodyContentTitle
            width: parent.width
            text: currentTitle
            font.family: "Helvetica"
            font.pointSize: 24
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            id: bodyContentPageurl
            width: parent.width
            text: "<a href=\http://sidensurl.dk><b>Artiklens side</b></a> "
            onLinkActivated: Qt.openUrlExternally(currentPageurl)
            font.family: "Helvetica"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            anchors.top: bodyContentTitle.bottom
        }
        Text {
            id: bodyContentDownloadButton
            width: parent.width
            //text: "DOWNLOAD"
            anchors.top: bodyContentMedia.bottom
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //Sætter adressen til mediet
                    fileDownloader.setDownloadurl = currentMediaurl;

                    //Tjekker om filen findes
                    fileDownloader.checkfile

                    //Sætter downloadningen igang
                    fileDownloader.downloadFile();
                }
            }
        }

        Text {
            id: bodyContentMedia
            width: parent.width
            //MIDLERTIDIGT!
            text: "<a href=\http://sidensurl.dk><b>Afspil</b></a> "
            //MIDLERTIDIGT!
            onLinkActivated: Qt.openUrlExternally(currentPageurl)
            font.family: "Helvetica"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            anchors.top: bodyContentPageurl.bottom
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        audioPlayerLoader.source = "mediaplayer/audioPlayer.qml";
                        audioPlayerLoader.item.setMediasource(currentMediafile);

                        if(!audioPlayerLoader.item.isPlaying() == true)
                        {
                            audioPlayerLoader.item.playAudio();
                           // parent.text = "<a href=\http://sidensurl.dk><b>Pause</b></a> "
                        }
                        else if(audioPlayerLoader.item.isPaused() == true){
                            audioPlayerLoader.item.playAudio();
                         //   parent.text = "<a href=\http://sidensurl.dk><b>Pause</b></a> "
                        }
                        else {
                            audioPlayerLoader.item.pauseAudio();
    //                        parent.text = "<a href=\http://sidensurl.dk><b>Genoptag afspiling</b></a> "
                        }
                        //audioPlayerLoader.item.playAudio();

                    }
                }
        }
        Text {
            id: bodyContentDescription
            width: headerImg.width - 20
            //height:
            text: currentDescription
            font.family: "Helvetica"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            anchors.topMargin: 20
            anchors.top: bodyContentMedia.bottom
            MouseArea {
                anchors.fill: parent
                onPressed: bodyMenu.width = menuHidebutton.width
            }

        }
        MouseArea {
            anchors.fill: parent
            onPressed: bodyMenu.width = menuHidebutton.width
        }
    }
}

    /* SECTION: HEADER - Everything to do with the header */
    Rectangle {
        parent: mainwindow
        id: mainHeaderrectangle
        //parent: mainHeaderrect
        height: 100
        width: mainwindow.width // + menuHidebutton.width
        color: "black"

        Image {
            id: headerImg
            anchors.fill: parent
            clip: true
            //height: parent.height-10
            source: "ktuxlogoslim.png"
        }
        Text {
            id: headerHomepage
            width: parent.width
            text: "Hjemmeside: " + '<a href="http://www.kanaltux.dk">http://www.kanaltux.dk</a>'
            color: "white"
            horizontalAlignment: Text.AlignRight
            onLinkActivated: Qt.openUrlExternally("http://www.kanaltux.dk")
        }
        Text {
            width: parent.width
            color: "white"
            text: "E-Mail: " + '<a href="mailto:redaktion@kanaltux.dk">redaktion@kanaltux.dk</a>'
            onLinkActivated: Qt.openUrlExternally("mailto:redaktion@kanaltux.dk");
            horizontalAlignment: Text.AlignRight
            anchors.top: headerHomepage.bottom
        }

    }

    /* SECTION: SLIDER - Everything to do with the header */
    Slider {
        id: sliderobject
        parent: mainHeaderrectangle
        width: mainHeaderrectangle.width
        height: audioPlayerLoader.item.isPlaying() == true ? 10 : 0
        anchors.bottom: parent.bottom
        currentProgress: 50
        MouseArea {
            anchors.fill: parent
            onPressed: {
                sliderobject.currentProgress = mouseX
                audioPlayerLoader.item.setPos(mouseX*audioPlayerLoader.item.getMaximum()/parent.width)
            }
        }
    }
    Binding {
        target: sliderobject
        property: "currentProgress"
        value: audioPlayerLoader.item.getPos();
        when: audioPlayerLoader.item.isPlaying();
    }
    Binding {
        target: sliderobject
        property: "currentMaximum"
        value: audioPlayerLoader.item.getMaximum();
    }





    /*XML*/
    XmlListModel{
        id: feedModel
        source: {"http://feeds.feedburner.com/Kanaltuxmp3?format=xml"}
        query: "/rss/channel/item"

        namespaceDeclarations: "declare namespace media = 'http://search.yahoo.com/mrss/'; declare namespace itunes = 'http://www.itunes.com/dtds/podcast-1.0.dtd'; "

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "media"; query: "media:content/@url/string()" }
        //XmlRole { name: "media"; query: "media:link/@url/string()" }
        XmlRole { name: "itunessummary"; query: "itunes:summary/string()" }
        XmlRole { name: "itunesduration"; query: "itunes:duration/string()" }
    }


    //SLET
//    MouseArea {
//        anchors.fill: parent
//        onClicked: {

//            audioPlayerLoader.source = "mediaplayer/audioPlayer.qml";
//            audioPlayerLoader.item.setMediasource("/home/froksen/.kanaltux/KanaltuxPodcastS01E07.mp3");
//            audioPlayerLoader.item.playAudio();
//        }
//    }
}
