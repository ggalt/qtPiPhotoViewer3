import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: imagePage
    objectName: "imagePage"
    color: "black"

    function changeState(newState) {
        // console.log("Current State:", state)
        // console.log("New State:", newState)
        imagePage.state = newState
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
    }

    states: [
        State {
            name: "BlankImage"
            PropertyChanges {
                target: foregroundImage
                source: "qrc:/images/black.png"
            }
            PropertyChanges {
                target: foregroundImage
                opacity: 1
            }
            PropertyChanges {
                target: imageDropShadow
                opacity: 1
            }
            PropertyChanges {
                target: backgroundImage
                source: "qrc:/images/black.png"
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
            ScriptAction {
                scriptName: "InitializeScript"
            }
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
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: imageDropShadow
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration
                    easing.type: Easing.InOutQuad
                }
            }

            onRunningChanged: {
                if((state=="ImageOut") && (!running)) {
                    mainWindow.currentImage = mainWindow.nextImage
                    changeState("ImageIn")
                }
            }
        }

}
