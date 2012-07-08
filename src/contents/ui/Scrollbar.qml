// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: slider
    //width: slider.ListView.view.width

    property int currentProgress: 10
    property int currentMaximum: parent.width

    Rectangle {
        id: mainRectangle
        width: parent.width
        height: parent.height
        //anchors.fill: parent
        color: "lightgrey"

    }
    Rectangle {
        id: progress
        width: (parent.width
        height:  50 //(mainRectangle.height/currentMaximum)*currentProgress
        color: "red"
        y: currentProgress

        MouseArea {
            anchors.fill: progress
            onPressed: {
               // progress.width = mouseX
                console.log(mouseY)
            }
    }
    }

    MouseArea {
        anchors.fill: mainRectangle
        onPressed: {
           // progress.width = mouseX
//            progress.y = mouseY
//            console.log(mouseY)
        }
    }

    function setProgress(progress){
        currentProgress = progress
    }

    function setMaximum(maximum) {
        currentMaximum = maximum
    }
}


