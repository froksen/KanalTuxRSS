// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: delegate
    width: delegate.ListView.view.width
    height: 50

    property bool listtitlemousearea_clicked: true

    Rectangle {
        width: delegate.width
        height: parent.height
        color: delegate.ListView.isCurrentItem ? "steelblue" : "#efefef"

        Text {
            id: texttitle
            text: name
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            height: parent.height
            width: parent.width
            color: delegate.ListView.isCurrentItem ? "white" : "black"
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }
        Rectangle {
            anchors.topMargin: 5
            //anchors.top: texttitle.bottom
            border.color: "black"
            width: texttitle.width
            height: 1
        }
    }
    MouseArea {
        anchors.fill: delegate;
        id: listtitlemousearea

        onClicked: {
            delegate.ListView.view.currentIndex = index
//            mainwindow.currentDescription = itunessummary
//            mainwindow.currentTitle = title
//            mainwindow.currentMediaurl = media
//            mainwindow.currentPageurl = link

            //Gemmer menuen væk når Afsnittet er blevet trykket på.
            //bodyMenu.height = 0

            //listtitlemousearea_clicked = true
           // listtitlemousearea_clicked = false

            //Sender brugeren til toppen af teksten
            //bodyContentFlickable.contentY = 0


            bodyVideoAudioMenu.height = 0
            bodyMenu.height = mainwindow.height
            feedModel.source = feed
            feedModel.reload()

        }

    }

    //Animationen når der er blevet trykket på et element
    states: [
        State {
        name: "down"; when: listtitlemousearea_clicked == false
        PropertyChanges { target: bodyMenu; y: 0; x: 0; height: 0 }
          },
        State {
        name: "up";  when: listtitlemousearea_clicked == true
        //PropertyChanges { target: descriptiontext; y: 160; rotation: 180; color: "red" }
        PropertyChanges { target: bodyMenu; y: 0; x: 0; height: bodyMenu.height;  }
        }

      ]

    transitions: [
        Transition {
        from: "up"; to: "down"; reversible: false
            ParallelAnimation {
                NumberAnimation { properties: "x,y,width, height"; duration: 250; easing.type: Easing.InOutQuad }
                ColorAnimation { duration: 500 }
            }

        }
    ]
}
