// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: slider
    width: parent.width

    property int currentProgress: 10
    property int currentMaximum: parent.width

    Rectangle {
        id: mainRectangle
        width: parent.width
        height: parent.height
        color: "lightgrey"

    }
    Rectangle {
        id: progress
        width: (mainRectangle.width/currentMaximum)*currentProgress
        height: mainRectangle.height
        color: "red"


    }

    MouseArea {
        anchors.fill: mainRectangle
        onPressed: {
           // progress.width = mouseX
        }
    }

    function setProgress(progress){
        currentProgress = progress
    }

    function setMaximum(maximum) {
        currentMaximum = maximum
    }
}


