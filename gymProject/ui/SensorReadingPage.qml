import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 2.15

Rectangle {
    id: rectangle
    width: 410
    height: 740
    color: "black"
    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    property bool startButtonClicked: false
    property int elapsedSeconds: 0 // Store the elapsed time in seconds

    Button {
        id: backButton
        height: 38
        palette.buttonText: "white"
        icon.source: "qrc:/ui/assets/images/backArrow.png"
        icon.height: parent.height
        icon.width: parent.width
        font.family: "Tahoma"
        highlighted: true
        flat: false
        anchors.topMargin: 16
        onClicked: {
            pageloader.pageLoader("backToHeartRateDevice")
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 345
            leftMargin: 6
        }
    }

    Button {
        id: startButton
        y: 641
        height: 52
        text: qsTr("Start")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 107
        anchors.rightMargin: 107
        anchors.bottomMargin: 47
        font.pointSize: 16
        highlighted: true

        onClicked: {
            startButton.visible = false
            pauseButton.visible = true
            stopButton.visible = true

            // Start the timer when the button is clicked
            timer.start()
            startButtonClicked = true
        }
    }

    Label {
        id: pageTitleLabel
        height: 37
        color: "#ffffff"
        text: qsTr("Free Training")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 98
        anchors.rightMargin: 98
        anchors.topMargin: 16
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pointSize: 18
        font.italic: true
    }

    Rectangle {
        id: speedBox
        // Adjust width as needed
        height: 100 // Adjust height as needed
        radius: 180
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 73
        anchors.rightMargin: 237
        anchors.topMargin: 90 // Set radius to make it round
        color: "lightblue" // Adjust color as needed

        Rectangle {
            x: 5
            y: 5
            width: 90 // Adjust width as needed
            height: 90 // Adjust height as needed
            radius: 180 // Set radius to make it round
            color: "black" // Adjust color as needed

            Text {
                width: 48
                height: 21
                anchors.centerIn: parent // Center the text inside the rectangle
                // Set label text
                font.pixelSize: 20
                anchors.verticalCenterOffset: 22
                anchors.horizontalCenterOffset: 1

                font.family: "Courier"
                font.bold: true // Adjust font size as needed
                color: "white"
                text: qsTr("Km/h")
                // Adjust text color as needed
            }
        }
    }

    Rectangle {
        id: scoreLabel
        // Adjust width as needed
        height: 34 // Adjust height as needed
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: scoreBox.bottom
        anchors.leftMargin: 60
        anchors.rightMargin: 224
        anchors.topMargin: 14 // Set radius to make it round
        color: "#00000000" // Adjust color as needed

        Text {
            width: 112
            height: 16
            anchors.centerIn: parent // Center the text inside the rectangle
            // Set label text
            font.pixelSize: 14
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0

            font.family: "Courier"
            font.bold: true // Adjust font size as needed
            color: "white"
            text: qsTr("Average Score")
            // Adjust text color as needed
        }
    }

    Rectangle {
        id: puchBox
        height: 100
        color: "#add8e6"
        radius: 180
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: speedLabel.bottom
        anchors.leftMargin: 73
        anchors.rightMargin: 237
        anchors.topMargin: 24
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: 180

            Text {

                width: 28
                height: 20
                color: "#ffffff"
                text: qsTr("ms")
                font.pixelSize: 20
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 23
                anchors.horizontalCenterOffset: 3
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: scoreBox
        height: 100
        color: "#add8e6"
        radius: width / 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: punchLabel.bottom
        anchors.leftMargin: 73
        anchors.rightMargin: 237
        anchors.topMargin: 32
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: width / 2
            Text {

                width: 29
                height: 16
                color: "#ffffff"
                text: qsTr("DPS")
                font.pixelSize: 16
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 25
                anchors.horizontalCenterOffset: 1
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: punchLabel
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: puchBox.bottom
        anchors.leftMargin: 60
        anchors.rightMargin: 224
        anchors.topMargin: 13
        Text {
            width: 110
            height: 18
            color: "#ffffff"
            text: qsTr("Punching time")
            font.pixelSize: 14
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            font.family: "Courier"
            font.bold: true
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: speedLabel
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: speedBox.bottom
        anchors.leftMargin: 60
        anchors.rightMargin: 224
        anchors.topMargin: 6
        Text {
            width: 44
            height: 16
            color: "#ffffff"
            text: qsTr("Speed")
            font.pixelSize: 14
            font.family: "Courier"
            font.bold: true
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
        }
    }

    Button {
        id: pauseButton
        x: -4
        y: 641
        height: 52
        text: qsTr("Pause")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 59
        anchors.rightMargin: 216
        anchors.bottomMargin: 47
        highlighted: true
        font.pointSize: 16
        visible: false

        onClicked: {

            // Start the timer when the button is clicked
            if (pauseButton.text === "Pause") {
                timer.running = false
                pauseButton.text = "Resume"
                startButtonClicked = false
            } else {
                timer.running = true
                pauseButton.text = "Pause"
                startButtonClicked = true
            }
        }
    }

    Button {
        id: stopButton
        height: 52
        text: qsTr("Stop")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 208
        anchors.rightMargin: 67
        anchors.bottomMargin: 47
        highlighted: true
        font.pointSize: 16
        visible: false

        onClicked: {
            startButton.visible = true
            pauseButton.visible = false
            stopButton.visible = false

            // Start the timer when the button is clicked
            timer.stop()
            elapsedSeconds = 0
            timerLabel.text = "00:00:00"
            startButtonClicked = false
        }
    }

    Timer {
        id: timer
        interval: 1000 // Timer interval in milliseconds (1 second)
        repeat: true // Repeat the timer

        onTriggered: {
            // Increment the elapsed time
            elapsedSeconds++
            // Update the label text with the formatted elapsed time
            timerLabel.text = formatTime(elapsedSeconds)
        }
    }

    function formatTime(seconds) {
        var hours = Math.floor(seconds / 3600)
        var minutes = Math.floor((seconds % 3600) / 60)
        var secs = seconds % 60

        // Add leading zeros if necessary
        var formattedHours = ("0" + hours).slice(-2)
        var formattedMinutes = ("0" + minutes).slice(-2)
        var formattedSeconds = ("0" + secs).slice(-2)

        // Return the formatted time string
        return formattedHours + ":" + formattedMinutes + ":" + formattedSeconds
    }

    Label {
        id: timerLabel
        height: 43
        text: "00:00:00"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 264
        anchors.rightMargin: 7
        anchors.topMargin: 62
        font.family: "Times New Roman"
        font.pointSize: 27
        font.bold: true
        color: "white"
        anchors.horizontalCenterOffset: 136 // Initial value
    }

    Label {
        id: effectivePunch
        x: 245
        y: 255
        width: 159
        height: 28
        color: "#ffffff"
        text: qsTr("Effective punch")
        anchors.right: parent.right
        anchors.bottom: punchReadingLabel.top
        anchors.rightMargin: 6
        anchors.bottomMargin: -1
        font.italic: false
        font.family: "Tahoma"
        font.pointSize: 17
    }

    Label {
        id: punchReadingLabel
        x: 293
        y: 282
        width: 54
        height: 80
        color: "#ffffff"
        text: qsTr("0")
        anchors.right: parent.right
        anchors.bottom: punchTimes.top
        anchors.rightMargin: 63
        anchors.bottomMargin: -4
        font.pointSize: 55
        font.bold: true
        font.family: "Verdana"
    }

    Label {
        id: punchTimes
        x: 276
        y: 358
        color: "#ffffff"
        text: qsTr("Times")
        anchors.right: parent.right
        anchors.bottom: heartRateLabel.top
        anchors.rightMargin: 82
        anchors.bottomMargin: 38
        font.pointSize: 15
        font.family: "Tahoma"
    }

    Label {
        id: heartRateLabel
        x: 226
        y: 416
        width: 159
        height: 28
        color: "#ffffff"
        text: qsTr("Real-time heart rate")
        anchors.right: parent.right
        anchors.bottom: heartrateReadingLabel.top
        anchors.rightMargin: 25
        anchors.bottomMargin: -12
        font.pointSize: 17
        font.italic: false
        font.family: "Tahoma"
    }

    Label {
        id: heartrateReadingLabel
        x: 289
        y: 437
        width: 58
        height: 82
        color: "#ffffff"
        text: qsTr("0")
        anchors.right: parent.right
        anchors.bottom: heartRateUnit.top
        anchors.rightMargin: 63
        anchors.bottomMargin: -2
        font.pointSize: 55
        font.family: "Verdana"
        font.bold: true
    }

    Label {
        id: heartRateUnit
        x: 282
        y: 517
        height: 25
        color: "#ffffff"
        text: qsTr("BPM")
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 90
        anchors.bottomMargin: 198
        font.pointSize: 15
        font.family: "Tahoma"
    }

    Connections {
        target: pageloader
        function onSwitchBackToHeartRateDevice() {
            heartRateDevicePage.visible = true
            sensorReadingPage.visible = false
        }
    }
    Connections {
        target: device
        function onMeasuringChanged(hrVal) {
            console.log("HR Value:" + hrVal)
            if (startButtonClicked) {
                heartrateReadingLabel.text = hrVal
                console.log("READING UPDATE")
            }
        }
    }
}
