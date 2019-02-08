import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQml 2.12


Rectangle {
    id: clockMain
    property bool is24Hour: false
    property bool showDate: false
    property date currentTime: new Date()
    property color backgroundColor: white
    property color textColor: black
    property string formatString: "hh:mm AP"    // leading zero hour, 12 hour display, AM or PM
    property bool showColon: true
    property int marginValue: 5
    property int visibleDuration: 10*1000
    property real transitionDuration: 0.20   // percentage of visibleDuration
    property string fontFamily: "Arial"
    property int fontPointSize: 20
    property int displayBandWidth: 0

    color: "#00000000"  // main rect is transparent

    opacity: 1
    state: "clockVisible"

    function setState(newState) {
        state = newState
    }

    function toggleColon() {
        showColon = !showColon

    }

    /// we assume a standard 4:3 aspect ratio for pictures so this determines the smallest space on the side
    /// of each picture that will be "blank" and available to display a clock
    function getBandWidth() {
        displayBandWidth = (height * 4) / 6;

        if( textMetrics.width <= displayBandWidth /2 )
            while( textMetrics.width <= displayBandWidth / 2 ) {
                fontPointSize++;
            }
        else if ( textMetrics.width >= (displayBandWidth * 3)/4 ) {
            while( textMetrics.width >= (displayBandWidth * 3)/4 ) {
                fontPointSize--;
            }
        }
        clockMain.width = textMetrics.width + marginValue * 2
        clockMain.height = textMetrics.height + marginValue * 2
    }

    function positionClock() {
        leftBumper = 0
        if( Math.random() < 0.5 ) {
            leftBumper = clockMain.parent.width - displayBandWidth
        }
        clockMain.left = leftBumper + (Math.random() * (displayBandWidth - clockMain.width))
        clockMain.top = Math.random() * (clockMain.parent.height - clockMain.height)
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        opacity: 0.80
        color: backgroundColor
    }

    TextMetrics {
        id: textMetrics
        font.family: fontFamily
        font.pointSize: fontPointSize
        text: "00:00 A"
    }

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

    Timer {
        id: displayTimer
        interval: visibleDuration
        running: false
        onTriggered: setState("clockInvisible")
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
                opacity: 0
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
