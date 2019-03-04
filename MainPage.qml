import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: imagePage
    objectName: "imagePage"
    color: "black"

    property int iClearVerticalBandWidth: (width - ((4* height)/3 ))/2  // width of open bars on left and right that will be clear (assuming no pararama images).

    function changeState(newState) {
        // console.log("Current State:", state)
        // console.log("New State:", newState)
        imagePage.state = newState
    }

    function setPathState(pathState) {
        appWindow.titleBarTimerStop()
        foregroundImage.state=pathState
    }

    Image {
        id: backgroundImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: mainWindow.currentImage
        autoTransform: true
        opacity: 0
    }

    FastBlur {
        id: backgroundBlur
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: appWindow.blurValue
        opacity: 0
        //        onOpacityChanged: // console.log("NEW IMAGE BLUR OPACITY CHANGED TO:", newBackgroundBlur.opacity, "state is:", imagePage.state)
    }

//    ClockWidget {
//        id: clockWidget
//        property int leftBumper: 0
//        x: 0
//        y: 0

//        onPositionClock: {
//            leftBumper = 0
//            if( Math.random() < 0.5 ) {
//                leftBumper = parent.width - iClearVerticalBandWidth
//            }
//            x = leftBumper + (Math.random() * (iClearVerticalBandWidth - width))
//            y = Math.random() * (parent.height - height)
//        }

//        //    /// we assume a standard 4:3 aspect ratio for pictures so this determines the smallest space on the side
//        //    /// of each picture that will be "blank" and available to display a clock
//        //    function getBandWidth() {

//        //        if( textMetrics.width <= displayBandWidth /2 )      // if the current clock would only fill less than half the boundary
//        //            while( textMetrics.width <= displayBandWidth / 2 ) {
//        //                fontPointSize++;
//        //            }
//        //        else if ( textMetrics.width >= (displayBandWidth * 3)/4 ) { // if the current clock would fill more than 3/4 of the boundary.
//        //            while( textMetrics.width >= (displayBandWidth * 3)/4 ) {
//        //                fontPointSize--;
//        //            }
//        //        }
//        //        clockMain.width = textMetrics.width + marginValue * 2
//        //        clockMain.height = textMetrics.height + marginValue * 2
//        //    }

//        //    function positionClock() {
//        //        leftBumper = 0
//        //        if( Math.random() < 0.5 ) {
//        //            leftBumper = clockMain.parent.width - displayBandWidth
//        //        }
//        //        clockMain.left = leftBumper + (Math.random() * (displayBandWidth - clockMain.width))
//        //        clockMain.top = Math.random() * (clockMain.parent.height - clockMain.height)
//        //    }


//    }

    DropShadow {
        id: imageDropShadow
        horizontalOffset: appWindow.shadowOffset
        verticalOffset: appWindow.shadowOffset
        radius: 8.0
        anchors.fill: foregroundImage
        samples: 17
        transparentBorder: true
        color: "#80000000"
        source: foregroundImage
        opacity: 0
    }

    Image {
        id: foregroundImage
        anchors.fill: parent
        anchors.rightMargin: 10 + appWindow.shadowOffset
        anchors.leftMargin: 10 + appWindow.shadowOffset
        anchors.bottomMargin: 10 + appWindow.shadowOffset
        anchors.topMargin: 10 + appWindow.shadowOffset
        fillMode: Image.PreserveAspectFit
        opacity: 0
        source: mainWindow.currentImage
        autoTransform: true

        Rectangle {
            id: recImagePathText
            height: foregroundImage.height / 30
            color: "#80ffffff"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            Text {
                id: txtImagePath
                text: qsTr(appWindow.imagePath)
                anchors.fill: parent
                styleColor: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: foregroundImage.height / 40
                opacity: 1
            }
        }

        states: [
            State {
                name: "PathVisible"
                PropertyChanges {
                    target: recImagePathText
                    opacity: .90
                }
            },
            State {
                name: "PathInvisible"
                PropertyChanges {
                    target: recImagePathText
                    opacity: 0
                }
            }
        ]
        transitions: [
            Transition {
                from: "*"
                to: "PathVisible"

                NumberAnimation {
                    target: recImagePathText
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            },
            Transition {
                from: "*"
                to: "PathInvisible"

                NumberAnimation {
                    target: recImagePathText
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        ]
    }

    states: [
        State {
            name: "BlankImage"
            PropertyChanges {
                target: foregroundImage
                opacity: 0
            }
            PropertyChanges {
                target: imageDropShadow
                opacity: 0
            }
            PropertyChanges {
                target: backgroundImage
                opacity: 0
            }
            PropertyChanges {
                target: backgroundBlur
                opacity: 0
            }

            //            StateChangeScript {
            //                script: {
            //                    name: "InitializeScript"
            //                    // console.log("InitializeScript")
            //                    appWindow.loadNextImage()
            //                    changeState("ImageOut")
            //                }
            //            }
        },

        State {
            name: "ShowImage"
            PropertyChanges {
                target: backgroundBlur
                opacity: appWindow.backgroundOpacity
            }
            PropertyChanges {
                target: foregroundImage
                opacity: 1
            }
            PropertyChanges {
                target: imageDropShadow
                opacity: appWindow.shadowOpacity
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "BlankImage"
            ParallelAnimation {
                NumberAnimation {
                    target: backgroundBlur
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: foregroundImage
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: imageDropShadow
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.OutQuad
                }
            }

            onRunningChanged: {
                if(!running && state=="BlankImage") {
                    console.log("BlankImage ends")
                    appWindow.loadNextImage()
                    changeState("ShowImage")
                    setPathState("PathInvisible")
                }
            }

            //            ScriptAction {
            //                scriptName: "InitializeScript"
            //            }
        },
        Transition {
            from: "*"
            to: "ShowImage"
            ParallelAnimation {
                NumberAnimation {
                    target: backgroundBlur
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: foregroundImage
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: imageDropShadow
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.InQuad
                }
            }

            onRunningChanged: {
                if(!running && state=="ShowImage") {
                    appWindow.imageTimerStart()
                    console.log("ShowImage ends")
                }
            }

            //            onRunningChanged: {
            //                if((state=="ShowImage") && (!running)) {
            //                    mainWindow.currentImage = mainWindow.nextImage
            //                    changeState("ImageIn")
            //                }
            //            }
        }
    ]
}





/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
