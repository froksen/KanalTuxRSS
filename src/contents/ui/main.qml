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
    property string currentMediafile: currentMediaurl
    property bool bodyMenuhidden: false


    /*Loaders - bliver brugt til at "indlæse" lydafspilleren*/
    Loader {
        id: audioPlayerLoader;
    }

    /* SECTION: BODY - Alt vedr. BODY delen */

    /* BODY layout - Laver det egentlige layout, som bruges senere. Vær OBS på at "en række" altså "ROW" er det vi nok for det meste på dansk kalder
        for en kolonne. Af en eller anden grund er der umiddelbart byttet om på de to betegnelser.*/
    Row {
        id: bodyRow
        parent: mainwindow
        width: parent.width
        height: parent.height - headerRect.height
        anchors.top: headerRect.bottom

        //Selve menuen.
        Rectangle {
            id: bodyMenu
            width: parent.width
            height: parent.height
            color:  "transparent"
            clip: true
        }

        //Indeholder det egentlige indhold. Altså titler, beskrivelser osv.
        Rectangle {
            clip: true
            id: bodyContent
            height: parent.height
            width: bodyMenu.height == 0 ? parent.width : 0
        }
    }

    /* BODY Menu - alt vedr. selve menuen*/
    Rectangle {
       id: rssFeedNotDownloadButton
       parent:  mainwindow
       width: feedModel.progress == 0 ? parent.width : 0
       height: feedModel.progress == 0 ? parent.height : 0
       color: "red"

       //Timeren bliver brugt til at tjekke om der er forbindelse til internettet. Hvis ikke er feedModel.progress == 0, eller ==1.
       Timer {
           interval: 5000; running: true; repeat: feedModel.progress == 0 ? true : false
           onTriggered: {
               rssFeedNotDownloadButtonText.text = "<b>Ingen forbindelse</b> \n\n Forsøger hvert 5. sekund <br><br> Sidst forsøgt: " + Date().toString() + "<br> <br> - Tryk for at tvinge genopfriskning -"
               feedModel.reload()
           }
           }

       //Viser denne tekst hvis der ikke er forbindelse.
       Text {
           id: rssFeedNotDownloadButtonText
           anchors.fill: parent
           text: feedModel.progress == 0 ? "<b>Ingen forbindelse</b> \n\n Forsøger hvert 5. sekund <br><br> Sidst forsøgt: " + Date().toString() + "<br> <br> - Tryk for at tvinge genopfriskning -" : ""
           verticalAlignment: Text.AlignBottom
           horizontalAlignment: Text.AlignHCenter
           color: "white"
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



    //Menuen der indeholder de forskellige episoder.
    ListView {
        id: listviewMenu
        parent: bodyMenu
        height: parent.height
        width: parent.width
        model: feedModel
        delegate: EpisodeDelegate{}
        clip: true
        anchors.left: bodyMenuscrollbar.left
    }


    /* BODY Page*/
    //Flickable delen går at "siden" kan bladres igennem.
    Flickable {
        id: bodyContentFlickable
        parent: bodyContent
        width: parent.width;
        height: parent.height
        contentWidth: parent.width; contentHeight: bodyContentRect.height
        //boundsBehavior: Flickable.StopAtBounds
        onContentYChanged: {
            contentY < 0 ? contentY = 0 : contentY = contentY;
        }

        //Selve siden
        Rectangle {
            id: bodyContentRect
            height: parent.height
            width: parent.width
            //titlen
            Text {
                id: bodyContentTitle
                text: currentTitle
                font.family: "Helvetica"
                font.pointSize: 24
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                width: parent.width

            }
            //URL'en til siden
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
            //"Afspil" knappen
            Text {
                id: bodyContentMedia
                width: parent.width
                text: "<a href=\http://sidensurl.dk><b>Afspil</b></a> "
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
                            }
                            else if(audioPlayerLoader.item.isPaused() == true){
                                audioPlayerLoader.item.playAudio();
                            }
                            else {
                                audioPlayerLoader.item.pauseAudio();
                            }
                        }
                    }
            }
            //Selve beskrivelsen
            Text {
                id: bodyContentDescription
                width: parent.width
                height: parent.height
                text: currentDescription
                font.family: "Helvetica"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                anchors.topMargin: 20
                anchors.top: bodyContentMedia.bottom

            }

        }
}

    /* SECTION: HEADER - Toppen af hovedvinduet, som indeholder banneret m.m. */
    Rectangle {
        parent: mainwindow
        id: headerRect
        height: 130
        width: mainwindow.width
        color: "black"
        //Banneren
        Image {
            id: headerImg
            height: headerRect.height - menuHidebutton.height
            width: parent.width
            clip: true
            source: "ktuxlogoslim.png"
        }
        //Hjemmesidelink
        Text {
            id: headerHomepage
            width: parent.width
            text: "Hjemmeside: " + '<a href="http://www.kanaltux.dk">http://www.kanaltux.dk</a>'
            color: "white"
            horizontalAlignment: Text.AlignRight
            onLinkActivated: Qt.openUrlExternally("http://www.kanaltux.dk")
        }
        //E-mail link
        Text {
            width: parent.width
            color: "white"
            text: "E-Mail: " + '<a href="mailto:redaktion@kanaltux.dk">redaktion@kanaltux.dk</a>'
            onLinkActivated: Qt.openUrlExternally("mailto:redaktion@kanaltux.dk");
            horizontalAlignment: Text.AlignRight
            anchors.top: headerHomepage.bottom
        }
        //Menu-gem-knappen. Den knap der vises når menuen er gemt
        Rectangle {
            clip: true
            id: menuHidebutton
            height: 20
            width: parent.width
            color: bodyMenu.height == 0 ? "steelblue" : "#efefef"
            anchors.left: listviewMenu.right;
            anchors.bottom: parent.bottom


            Text {id: menuHidebottomtext ; anchors.fill: parent; font.weight: Font.DemiBold ; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter ; text: bodyMenu.height == 0 ? " ↓ MENU ↓" : "↑ MENU ↑"; color:  bodyMenu.height == 0 ? "white" : "black"}

            MouseArea {
                anchors.fill: parent
                onPressed: bodyMenu.height == 0 ? bodyMenu.height = bodyRow.height : bodyMenu.height = 0
            }
        }

    }

    /* SECTION: SLIDER - Everything to do with the header */
    Slider {
        id: sliderobject
        parent: headerRect
        width: parent.width
        height: audioPlayerLoader.item.isPlaying() == true ? 10 : 0
        anchors.bottom: menuHidebutton.top
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





    /*XML - Her bliver selve RSS/XML delen læst*/
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
        XmlRole { name: "itunessummary"; query: "itunes:summary/string()" }
        XmlRole { name: "itunesduration"; query: "itunes:duration/string()" }
    }

}
