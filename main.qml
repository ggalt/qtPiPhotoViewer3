import QtQuick 2.11
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    visible: true
    width: 1024
    height: 768

    property int showImageDuration: 5000                // 5 seconds (5000 milliseconds)
    property int imageFadeDuration: 1000                // 1 second
    property int backgroundTransitionDuration: 300      // .3 seconds
    property int showImageLongDuration: 5 * 60 * 1000   // 5 minutes
    property int showTitleBarDuration: 5 * 1000         // 5 seconds
    property real backgroundOpacity: 0.75
    property int blurValue: 99
    property int shadowOffset: 4
    property real shadowOpacity: 0.5
    property string pictureHome: ""
    property bool movingForward: true
    property string imagePath: ""
    property int imageRotation: 0

    visibility: "FullScreen"

    function toggleFullScreen() {
        // console.log("****VISIBILITY IS:",appWindow.visibility)
        if(appWindow.visibility===5)
            appWindow.visibility="Windowed"
        else
            appWindow.visibility="FullScreen"
    }

    function getImage() {
        return myImages.nextImage()
    }

    function loadNextImage() {
        if(movingForward) {
            mainWindow.currentImage = myImages.nextImage()
            // console.log("Next Image")
        }
        else {
            mainWindow.currentImage = myImages.previousImage()
            movingForward = true
            // console.log("****LOADING PREVIOUS IMAGE***")
        }
        getImagePath()
    }

    function getImagePath() {
        imagePath = myImages.returnImagePath()
        console.log(imagePath)
    }

    function imageTimerStart() {
        imageTimer.restart()
//        imageTimer.start()
        // console.log("starting image timeer")
    }

    function imageTimerStop() {
        imageTimer.stop()
    }

    function imageLongTimerStart() {
        imageTimerStop()
        imageLongTimer.start()
    }

    function titleBarTimerStop() {
        titleBarTimer.stop()
    }

    // trying to make a simultaneous cross-fade between old and new backgrounds

    function setImageState(imgState) {

        if(imgState==="BlankImage") {
            mainWindow.state = imgState
        }
        else {
             console.log("HELP!! Unknown image state:", imgState)
        }
    }

    function goToImage(direction) {
        imageTimer.stop()
        if(direction === "next") {
            movingForward = true
        } else {
            movingForward = false
        }
        console.log("Moving Forward:", movingForward, "timer is running?", imageTimer.running)
        appWindow.setImageState("BlankImage")
    }

    function loadSettingsDialog() {
        Qt.createComponent("SettingsDialog.qml").createObject(appWindow,{})
    }

    function changeSettings(newBlurValue, newDurationValue, newURL) {
        // console.log("blur:",newBlurValue,"duration:",newDurationValue,"URL:",newURL)
        if(newBlurValue > 0)
            blurValue = newBlurValue
        if(newDurationValue > 0)
            showImageDuration = newDurationValue * 1000
        if(newURL!== "") {
            pictureHome = newURL
        }
    }

    Timer {
        id: imageTimer
        interval: showImageDuration
        running: false
        onTriggered: {
            // console.log("imageTimer triggered")
//            imageRotation = 0
            mainWindow.state = "BlankImage"
        }
    }

    Timer {
        id: imageLongTimer
        interval: showImageLongDuration
        running: false
        onTriggered: {
            console.log("imageLongTimer triggered")
            stop()
            mainWindow.state = "BlankImage"
        }
    }

    Timer {
        id: titleBarTimer
        interval: showTitleBarDuration // 5 seconds
        running: false
        onTriggered: {
            // console.log("imageTimer triggered")
            mainWindow.setPathState("PathInvisible")
        }
    }


    MainPage {
        id: mainWindow
        property string currentImage: appWindow.getImage()
        anchors.fill: parent

        focus: true
        Keys.onLeftPressed: {
            console.log("left key press")
            imageRotation = 0
            appWindow.goToImage("previous")
        }
        Keys.onRightPressed: {
            console.log("right key press")
            imageRotation = 0
            appWindow.goToImage("next")
        }
        Keys.onReturnPressed: {
            appWindow.close()
        }
        Keys.onEscapePressed: {
            appWindow.close()
        }
        Keys.onUpPressed: {
            console.log("Up Key Press")
            imageLongTimerStart()
        }
        Keys.onDownPressed: {
            getImagePath()
            mainWindow.setPathState("PathVisible")
            titleBarTimer.start()
            console.log("Down Key Press"+imagePath)
        }
        Keys.onDigit7Pressed: {
            // rotate left
            console.log("7 Pressed")
            imageRotation -= 90
            mainWindow.state = "QuickBlank"
        }
        Keys.onDigit9Pressed: {
            // rotate right
            console.log("9 Pressed")
            imageRotation += 90
            mainWindow.state = "QuickBlank"
        }
        Keys.onDigit5Pressed: {
            appWindow.toggleFullScreen()
        }
        Keys.onBackPressed: {
            appWindow.toggleFullScreen()

        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.BlankCursor
        onDoubleClicked: loadSettingsDialog() //launch settings dialog
        onPressAndHold: appWindow.toggleFullScreen()
        onClicked: {
            console.log("MOUSE CLICK", mouseX)
            console.log("Screen width:", parent.width)
            if(mouseX < parent.width / 4) {     // we clicked on the left so we want to back up
                goToImage("previous")
            } else if(mouseX > 3*parent.width / 4){
                goToImage("next")
            }
        }
    }

}
