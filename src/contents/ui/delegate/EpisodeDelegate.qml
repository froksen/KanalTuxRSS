// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: delegate
    width: delegate.ListView.view.width
    height: 50

    property bool listtitlemousearea_clicked: false

    Rectangle {
        width: delegate.width
        height: parent.height
        color: delegate.ListView.isCurrentItem ? "steelblue" : "#efefef"

        Text {
            id: texttitle
            text: title
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
            mainwindow.currentDescription = itunessummary
            mainwindow.currentTitle = title
            mainwindow.currentMediaurl = media
            mainwindow.currentPageurl = link

            bodyMenu.width = menuHidebutton.width
            //bodyContent.width = mainHeaderrect.width - bodyMenu.width

            listtitlemousearea_clicked = true
            listtitlemousearea_clicked = false

        }

    }

    states: [
        State {
        name: "down";  when: listtitlemousearea_clicked == false
        //PropertyChanges { target: descriptiontext; y: 160; rotation: 180; color: "red" }
        PropertyChanges { target: bodyMenu; y: 0; x: 0; }
          },
        State {
        name: "up"; when: listtitlemousearea_clicked == true
        //PropertyChanges { target: descriptiontext; y: 160; rotation: 180; color: "red" }
        PropertyChanges { target: bodyMenu; y: 0; x: menuHidebutton.width;  }

        }

      ]

    transitions: [
        Transition {
        from: "up"; to: "down"; reversible: false
            ParallelAnimation {
                NumberAnimation { properties: "x,y,width"; duration: 500; easing.type: Easing.InOutQuad }
                ColorAnimation { duration: 500 }
            }
        }
    ]
}