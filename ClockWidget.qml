import QtQuick 2.11
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQml 2.12


Rectangle {
    id: clockMain
    property date currentTime: new Date()
    property color backgroundColor: "white"
    property color textColor: "black"
    property string formatString: "hh:mm AP"    // leading zero hour, 12 hour display, AM or PM
    property int visibleDuration: 10*1000
    property real transitionDuration: 0.20   // percentage of visibleDuration
    property string fontFamily: "Arial"
    property int fontPointSize: 20
    property int textMargin: 3

    color: "#00000000"  // main rect is transparent
    width: textMetrics.width + 3*textMargin
    height: textMetrics.height + 2*textMargin

    opacity: 1
    state: "clockVisible"

    function setState(newState) {
        console.log("State of Clock is:", newState)
        state = newState
    }

    signal positionClock

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        opacity: 0.80
        color: backgroundColor
        Text {
            id: timeText
            color: textColor
            text: currentTime.toLocaleTimeString(Qt.LocalTime, formatString)
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: fontFamily
            font.pixelSize: fontPointSize
        }
    }

    TextMetrics {
        id: textMetrics
        font.family: fontFamily
        font.pointSize: fontPointSize
        text: "00:00 A"
    }


    Timer {
        id: displayTimer
        interval: visibleDuration
        running: true
        onTriggered: {
            console.log('display timer triggered')
            setState("clockInvisible")
        }
    }

    Timer {
        id: transitionTimer
        interval: visibleDuration * transitionDuration
        running: false
        onTriggered: setState("clockVisible")
    }

    Timer {
        id: secondsTimer
        interval: 500
        running: false
        onTriggered: toggleColon()
    }

    states: [
        State {
            name: "clockVisible"
            PropertyChanges {
                target: clockMain
                opacity: 0.80
            }
        },
        State {
            name: "clockInvisible"
            PropertyChanges {
                target: clockMain
                opacity: 0.0
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "clockVisible"

            NumberAnimation {
                target: clockMain
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
            onRunningChanged: {
                if(!running && state=="clockVisible") {
                    console.log("clock visible")
                    console.log("clock at", left, right, width, height)
                    displayTimer.start()
                }
            }
        },
        Transition {
            from: "*"
            to: "clockInvisible"

            NumberAnimation {
                target: clockMain
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
            onRunningChanged: {
                if(!running && state=="clockInvisible") {
                    console.log("clock invisible")
                    positionClock()
                    transitionTimer.start()
                }
            }
        }
    ]
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_x:82;anchors_y:100}
}
 ##^##*/
