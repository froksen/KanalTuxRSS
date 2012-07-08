// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtMultimediaKit 1.1

Item {
    id: audioPlayerItem
   // property bool isAudioLoaded: !audioPlayer.InvalidMedia
    property string currentMediasource: ""

//    Rectangle {
//        id: uiFace
//        width: 100
//        height: 100
//        color: "blue"
//    }


    function playAudio(){
        audioPlayer.play()
    }
    /*
      Function Which Stops Video Playing
      */
    function stopAudio(){
        audioPlayer.stop()
    }
    /*
      Function Which Stops Video Playing
      */
    function pauseAudio(){
        audioPlayer.pause()
    }

    function getPos() {
        return audioPlayer.position
    }

    function setMediasource(newsource){
        audioPlayer.source = newsource;
    }

    function isPlaying() {
        return audioPlayer.playing
    }

    function isPaused() {
        return audioPlayer.paused
    }

    function getMaximum() {
        return audioPlayer.duration;
    }
    function setPos(newPos) {
        audioPlayer.position = newPos;
    }

    /*

      Actual QML based Video Component
      */
    Audio{
        id:audioPlayer
        //anchors.fill: videoPlayerItem // never forget to mention the size and position
        source: ""
        //focus: true
    }
//    Binding {
//        target: audiotext
//        property: "text"
//        value: audioPlayer.position
//        when: playArea.pressed
//    }
}
