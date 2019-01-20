import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2


Item {
    id: dialogComponent
    anchors.fill: parent
    // Add a simple animation to fade in the popup
    // let the opacity go from 0 to 1 in 400ms
    PropertyAnimation { target: dialogComponent; property: "opacity";
        duration: 400; from: 0; to: 1;
        easing.type: Easing.InOutQuad ; running: true }

    property string pictreFolderHome: appWindow.pictureHome
    property int newBlurValue: appWindow.blurValue
    property int newDurationValue: appWindow.showImageDuration
    width: 800
    height: 600

    function acceptNewValues() {
        appWindow.changeSettings(newBlurValue,newDurationValue,pictreFolderHome)
        dialogComponent.destroy()
    }

    // This rectange is the a overlay to partially show the parent through it
    // and clicking outside of the 'dialog' popup will do 'nothing'
    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6
        // add a mouse area so that clicks outside
        // the dialog window will not do anything
        MouseArea {
            width: 800
            height: 600
            anchors.fill: parent
        }
    }

    // This rectangle is the actual popup
    FileDialog {
        id: fileDialog
        title: "Please choose the parent folder for pictures"
        selectFolder: true
        folder: shortcuts.pictures
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
            Qt.quit()
        }
    }
    Rectangle {
        id: dialogWindow
        width: 640
        height: 480
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 0.003
                color: "#1ff3cf"
            }

            GradientStop {
                position: 1
                color: "#4c4c4c"
            }

        }

        Text {
            id: blurText
            width: 200
            height: 25
            text: qsTr("Background Blur Value:")
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.top: parent.top
            anchors.topMargin: 40
            font.pointSize: 12
        }

        Text {
            id: imageDurationText
            x: -9
            y: -8
            width: 200
            height: 25
            text: qsTr("Image Display Duration:")
            font.pointSize: 12
            anchors.topMargin: 10
            anchors.top: blurText.bottom
            anchors.leftMargin: 30
            anchors.left: parent.left
        }

        Text {
            id: imageLocationText
            x: -6
            y: 0
            width: 200
            height: 25
            text: qsTr("Top-level Image Folder:")
            font.pointSize: 12
            anchors.topMargin: 10
            anchors.top: imageDurationText.bottom
            anchors.leftMargin: 30
            anchors.left: parent.left
        }

        Slider {
            id: blurSlider
            height: 25
            value: newBlurValue
            from: 0
            to: 100
            anchors.verticalCenter: blurText.verticalCenter
            anchors.leftMargin: 10
            anchors.left: blurText.right
            anchors.rightMargin: 5
            anchors.right: blurValue.left
            spacing: -2
            focusPolicy: Qt.WheelFocus
            stepSize: 5
        }

        Text {
            id: blurValue
            text: blurSlider.value
            clip: true
            textFormat: Text.PlainText
            font.capitalization: Font.AllLowercase
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: blurText.verticalCenter
            height: 25
            width: 40
            font.pointSize: 12
            anchors.right: parent.right
            anchors.rightMargin: 1
        }

        Slider {
            id: durationSlider
            height: 25
            from: 0
            to: 100000
            anchors.verticalCenter: imageDurationText.verticalCenter
            anchors.leftMargin: 10
            anchors.left: imageDurationText.right
            anchors.rightMargin: 5
            anchors.right: durationValue.left
            spacing: -2
            focusPolicy: Qt.WheelFocus
            stepSize: 1000
            value: newDurationValue
        }

        Text {
            id: durationValue
            text: durationSlider.value/1000
            clip: true
            font.capitalization: Font.AllLowercase
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: imageDurationText.verticalCenter
            height: 25
            width: 40
            font.pointSize: 12
            anchors.right: parent.right
            anchors.rightMargin: 5
        }

        Button {
            id: fileLocationBtn
            width: 30
            height: 30
            //            text: qsTr(". . .")
            text: qsTr("TEXT")
            font.pointSize: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: imageLocationText.verticalCenter
            flat: false
        }

        Text {
            id: imageFileLocation
            height: 25
            text: qsTr("pictreFolderHome")
            font.pointSize: 12
            anchors.right: fileLocationBtn.left
            anchors.rightMargin: 10
            anchors.left: imageLocationText.right
            anchors.leftMargin: 10
            anchors.verticalCenter: imageLocationText.verticalCenter
        }
    }
}

//Item {
//    id: settingsDialog
//    width: 580
//    height: 400
////    SystemPalette { id: palette }
////    clip: true

//    PropertyAnimation { target: settingsDialog; property: "opacity";
//                                  duration: 400; from: 0; to: 1;
//                                  easing.type: Easing.InOutQuad ; running: true }
//    FileDialog {
//        id: dlgImageFolder
//        folder: appWindow.pictureHome
//        width: 500
//        height: 300
//    }

////    Dialog {
////        id: helloDialog
////        modality: dialogModal.checked ? Qt.WindowModal : Qt.NonModal
////        title: customizeTitle.checked ? windowTitleField.text : "Hello"
////        onButtonClicked: console.log("clicked button " + clickedButton)
////        onAccepted: lastChosen.text = "Accepted " +
////            (clickedButton == StandardButton.Ok ? "(OK)" : (clickedButton == StandardButton.Retry ? "(Retry)" : "(Ignore)"))
////        onRejected: lastChosen.text = "Rejected " +
////            (clickedButton == StandardButton.Close ? "(Close)" : (clickedButton == StandardButton.Abort ? "(Abort)" : "(Cancel)"))
////        onHelp: lastChosen.text = "Yelped for help!"
////        onYes: lastChosen.text = (clickedButton == StandardButton.Yes ? "Yeessss!!" : "Yes, now and always")
////        onNo: lastChosen.text = (clickedButton == StandardButton.No ? "Oh No." : "No, no, a thousand times no!")
////        onApply: lastChosen.text = "Apply"
////        onReset: lastChosen.text = "Reset"

////        Label {
////            text: "Hello world!"
////        }
////    }

//    Rectangle {
//        height: 40
//        width: 100
//        radius: 10
//        anchors.centerIn: parent
//        anchors.bottom: parent.bottom
//        MouseArea {
//            anchors.fill: parent
//            onClicked: settingsDialog.destroy()
//        }
//    }
//Button {
//    id: btnAccept
//    x: 28
//    y: 155
//    text: qsTr("Accept")
//    //            isDefault: true
//    onClicked: {
//        dialogComponent.destroy()
//    }
//}

//Button {
//    id: btnCancel
//    x: 215
//    y: 155
//    text: qsTr("Cancel")
//    onClicked: {
//        dialogComponent.destroy()
//    }
//}


//}







































/*##^## Designer {
    D{i:21;anchors_x:225}D{i:5;anchors_height:200;anchors_width:320}
}
 ##^##*/
