import QtCore
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts 2.15
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
    property int met: 7
    property int countdownValue: 3
    property int userWeight
    property int effectivePunch
    property double punchTime
    property double averagePunchTime

    Image {
        id: backButton
        height: 26
        source: "qrc:/ui/assets/images/backArrow.png"
        anchors.topMargin: 16
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageloader.pageLoader("backToHeartRateDevice")
            }
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 372
            leftMargin: 14
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
        anchors.bottomMargin: 40
        font.pointSize: 16
        highlighted: true

        onClicked: {
            circularProgressContainer.visible = true
            startButton.visible = false
            pauseButton.visible = true
            stopButton.visible = true
            rectangle.countdownValue = 3
            countdownTimer.start()

            countdownCanvas.requestPaint() // Initial paint
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
        width: 100
        // Adjust width as needed
        height: 100 // Adjust height as needed
        radius: 180
        anchors.left: parent.left
        anchors.top: row.bottom
        anchors.leftMargin: 74
        anchors.topMargin: 12 // Set radius to make it round
        color: "lightblue" // Adjust color as needed

        Rectangle {
            x: 5
            y: 5
            width: 90 // Adjust width as needed
            height: 90 // Adjust height as needed
            radius: 180 // Set radius to make it round
            color: "black" // Adjust color as needed

            Label {
                id: leftspeed
                width: 74
                height: 21
                anchors.centerIn: parent // Center the text inside the rectangle
                // Set label text
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenterOffset: 1
                anchors.horizontalCenterOffset: 0
                font.family: "Courier"
                font.bold: true // Adjust font size as needed
                color: "white"
                text: qsTr("0.0")
                // Adjust text color as needed
            }

            Text {
                x: -1
                y: -1
                width: 74
                height: 21
                color: "#ffffff"
                text: qsTr("Km/h")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 25
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: scoreLabel
        width: 157
        // Adjust width as needed
        height: 34 // Adjust height as needed
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.left: parent.left
        anchors.top: scoreBox.bottom
        anchors.leftMargin: 48
        anchors.topMargin: 6 // Set radius to make it round
        color: "#00000000" // Adjust color as needed

        Text {
            width: 142
            height: 16
            anchors.centerIn: parent // Center the text inside the rectangle
            // Set label text
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: 0

            font.family: "Courier"
            font.bold: true // Adjust font size as needed
            color: "white"
            text: qsTr("Punch Power")
            // Adjust text color as needed
        }
    }

    Rectangle {
        id: puchBox
        width: 100
        height: 100
        color: "#add8e6"
        radius: 180
        anchors.left: parent.left
        anchors.top: speedLabel.bottom
        anchors.leftMargin: 74
        anchors.topMargin: 20
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: 180

            Label {
                id: leftCount
                width: 74
                height: 24
                color: "#ffffff"
                text: qsTr("0.0")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: -4
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }

            Text {
                x: 9
                y: 9
                width: 74
                height: 24
                color: "#ffffff"
                text: qsTr("punches")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 14
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: scoreBox
        width: 100
        height: 100
        color: "#add8e6"
        radius: width / 2
        anchors.left: parent.left
        anchors.top: punchLabel.bottom
        anchors.leftMargin: 74
        anchors.topMargin: 20
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: width / 2
            Label {
                id: leftPower
                width: 91
                height: 24
                color: "#ffffff"
                text: qsTr("0.0")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: -1
                anchors.horizontalCenterOffset: 1
                anchors.centerIn: parent
            }

            Text {
                x: -1
                y: -1
                width: 91
                height: 24
                color: "#ffffff"
                text: qsTr("G-Force")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 20
                anchors.horizontalCenterOffset: 1
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: punchLabel
        width: 157
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.left: parent.left
        anchors.top: puchBox.bottom
        anchors.leftMargin: 48
        anchors.topMargin: 6
        Text {
            width: 148
            height: 18
            color: "#ffffff"
            text: qsTr("Left Punches count")
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: 0
            font.family: "Courier"
            font.bold: true
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: speedLabel
        width: 157
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.left: parent.left
        anchors.top: speedBox.bottom
        anchors.leftMargin: 48
        anchors.topMargin: 6
        Text {
            width: 96
            height: 16
            color: "#ffffff"
            text: qsTr("Speed (Km/h)")
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
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
        anchors.bottomMargin: 40
        highlighted: true
        font.pointSize: 16
        visible: false

        onClicked: {

            // Start the timer when the button is clicked
            if (pauseButton.text === "Pause") {
                timer.running = false
                pauseButton.text = "Resume"
                rectangle.startButtonClicked = false
            } else {
                timer.running = true
                pauseButton.text = "Pause"
                rectangle.startButtonClicked = true
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
        anchors.bottomMargin: 40
        highlighted: true
        font.pointSize: 16
        visible: false

        onClicked: {
            timer.running = false
            pauseButton.text = "Resume"
            rectangle.startButtonClicked = false
            confirmPopup.open()
            confirmPopup.text = "Confirm you want to end this training?"
        }
    }

    Timer {
        id: timer
        interval: 1000 // Timer interval in milliseconds (1 second)
        repeat: true // Repeat the timer

        onTriggered: {
            // Increment the elapsed time
            rectangle.elapsedSeconds++
            // Update the label text with the formatted elapsed time
            timerLabel.text = rectangle.formatTime(rectangle.elapsedSeconds)

            rectangle.effectivePunch = parseInt(leftCount.text,
                                                10) + parseInt(rightCount.text,
                                                               10)
            var durationHour = rectangle.elapsedSeconds / 3600
            caloriesReading.text = Math.trunc(
                        rectangle.met * rectangle.userWeight * durationHour)
            rectangle.averagePunchTime = rectangle.punchTime / rectangle.effectivePunch
            console.log("Average Punches Speed:" + rectangle.averagePunchTime.toFixed(
                            2))
            //console.log("Effective Punches:" + rectangle.effectivePunch)
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
        x: 270
        height: 43
        text: "00:00:00"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 18
        anchors.topMargin: 40
        horizontalAlignment: Text.AlignHCenter
        font.family: "Times New Roman"
        font.pointSize: 27
        font.bold: true
        color: "white"
        anchors.horizontalCenterOffset: 136 // Initial value
    }

    Label {
        id: caloriesLabel
        x: 209
        width: 150
        height: 28
        color: "#ffffff"
        text: qsTr("Calories")
        anchors.right: parent.right
        anchors.top: scoreLabel1.bottom
        anchors.rightMargin: 52
        anchors.topMargin: 17
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.italic: false
        font.family: "Tahoma"
        font.pointSize: 17

        Image {
            id: caloriesImage
            x: 127
            y: -5
            width: 36
            height: 35
            anchors.right: parent.right
            anchors.rightMargin: 0
            source: "qrc:/ui/assets/images/calories.png"
        }
    }

    Label {
        id: caloriesReading
        x: 270
        width: 52
        height: 73
        color: "#ffffff"
        text: qsTr("0")
        anchors.right: parent.right
        anchors.top: caloriesLabel.bottom
        anchors.rightMargin: 98
        anchors.topMargin: 3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 55
        font.bold: true
        font.family: "Verdana"
    }

    Label {
        id: caloriesUnit
        x: 267
        color: "#ffffff"
        text: qsTr("kcal")
        anchors.right: parent.right
        anchors.top: caloriesReading.bottom
        anchors.rightMargin: 101
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 18
        font.family: "Tahoma"
    }
    Label {
        id: heartRateLabel
        width: 178
        height: 28
        color: "#ffffff"
        text: qsTr("Heart rate")
        anchors.left: parent.left
        anchors.top: scoreLabel.bottom
        anchors.leftMargin: 35
        anchors.topMargin: 17
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pointSize: 17
        font.italic: false
        font.family: "Tahoma"

        Image {
            x: 134
            y: 1
            width: 30
            height: 30
            anchors.right: parent.right
            anchors.rightMargin: 10
            source: "qrc:/ui/assets/images/heart-rate.png"
        }
    }

    Label {
        id: heartrateReadingLabel
        width: 51
        height: 74
        color: "#ffffff"
        text: qsTr("0")
        anchors.left: parent.left
        anchors.top: heartRateLabel.bottom
        anchors.leftMargin: 99
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 55
        font.family: "Verdana"
        font.bold: true
    }

    Label {
        id: heartRateUnit
        width: 45
        height: 25
        color: "#ffffff"
        text: qsTr("BPM")
        anchors.left: parent.left
        anchors.top: heartrateReadingLabel.bottom
        anchors.leftMargin: 102
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 18
        font.family: "Tahoma"
    }

    Rectangle {
        id: speedBox1
        x: 236
        y: 2
        width: 100
        height: 100
        color: "#add8e6"
        radius: 180
        anchors.right: parent.right
        anchors.top: row.bottom
        anchors.rightMargin: 74
        anchors.topMargin: 12
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: 180
            Label {
                id: rightspeed
                width: 74
                height: 21
                color: "#ffffff"
                text: qsTr("0.0")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 1
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }

            Text {
                x: -1
                y: -1
                width: 74
                height: 21
                color: "#ffffff"
                text: qsTr("Km/h")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 25
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: scoreLabel1
        x: 205
        y: 2
        width: 157
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.right: parent.right
        anchors.top: scoreBox1.bottom
        anchors.rightMargin: 48
        anchors.topMargin: 6
        Text {
            width: 142
            height: 16
            color: "#ffffff"
            text: qsTr("Punch Power")
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            font.family: "Courier"
            font.bold: true
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: puchBox1
        x: 336
        y: 2
        width: 100
        height: 100
        color: "#add8e6"
        radius: 180
        anchors.right: parent.right
        anchors.top: speedLabel1.bottom
        anchors.rightMargin: 74
        anchors.topMargin: 20
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: 180
            Label {
                id: rightCount
                width: 74
                height: 24
                color: "#ffffff"
                text: qsTr("0.0")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: -4
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }

            Text {
                x: 9
                y: 9
                width: 74
                height: 24
                color: "#ffffff"
                text: qsTr("punches")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 14
                anchors.horizontalCenterOffset: 0
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: scoreBox1
        x: 336
        y: 2
        width: 100
        height: 100
        color: "#add8e6"
        radius: width / 2
        anchors.right: parent.right
        anchors.top: punchLabel1.bottom
        anchors.rightMargin: 74
        anchors.topMargin: 20
        Rectangle {
            x: 5
            y: 5
            width: 90
            height: 90
            color: "#000000"
            radius: width / 2
            Label {
                id: rightPower
                width: 91
                height: 24
                color: "#ffffff"
                text: qsTr("0.0")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: -1
                anchors.horizontalCenterOffset: 1
                anchors.centerIn: parent
            }

            Text {
                x: -1
                y: -1
                width: 91
                height: 24
                color: "#ffffff"
                text: qsTr("G-Force")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.bold: true
                anchors.verticalCenterOffset: 20
                anchors.horizontalCenterOffset: 1
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: punchLabel1
        x: 211
        y: 2
        width: 157
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.right: parent.right
        anchors.top: puchBox1.bottom
        anchors.rightMargin: 48
        anchors.topMargin: 6
        Text {
            width: 148
            height: 18
            color: "#ffffff"
            text: qsTr("Right Punches count")
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            font.family: "Courier"
            font.bold: true
            anchors.verticalCenterOffset: 1
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: speedLabel1
        x: 205
        y: 2
        width: 157
        height: 34
        color: "#00000000"
        radius: 14
        border.color: "#ffffff"
        border.width: 2
        anchors.right: parent.right
        anchors.top: speedBox1.bottom
        anchors.rightMargin: 48
        anchors.topMargin: 6
        Text {
            width: 96
            height: 16
            color: "#ffffff"
            text: qsTr("Speed (Km/h)")
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            font.family: "Courier"
            font.bold: true
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
        }
    }

    Row {
        id: row
        height: 45
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 48
        anchors.rightMargin: 48
        anchors.topMargin: 80
        Rectangle {
            color: "black"
            border.color: "#e9f0f1"
            border.width: 1
            width: parent.width / 2
            height: parent.height
            Label {
                id: leftPunchesLabel
                width: 142
                height: 28
                color: "#ffffff"
                text: qsTr("Left Hand")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 9
                anchors.topMargin: 9
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.pointSize: 20
                font.italic: true
                font.family: "Tahoma"
            }
        }
        Rectangle {
            color: "black"
            border.color: "#e9f0f1"
            border.width: 1
            width: parent.width / 2
            height: parent.height
            Label {
                id: rightPunchesLabel
                width: 140
                height: 28
                color: "#ffffff"
                text: qsTr("Right Hand")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 8
                anchors.topMargin: 9
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 20
                font.italic: true
                font.family: "Tahoma"
                font.bold: false
            }
        }
    }

    Popup {
        id: confirmPopup
        width: 280
        height: 140
        background: Rectangle {
            color: "#dfe6e6" // Set the background color here
            border.color: "#c8cece"
            border.width: 2
            radius: 10
        }
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 14
                font.pointSize: 15
                color: "red"
                text: confirmPopup.text
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                spacing: 1

                //anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    border.color: "#c8cece"
                    border.width: 1
                    radius: 10

                    Button {
                        text: "Cancel"
                        anchors.fill: parent
                        flat: true
                        onClicked: {
                            // Handle the stop action
                            confirmPopup.close()
                            //console.log("Stop button clicked")
                            // Add your stop process logic here
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 45
                    border.color: "#c8cece"
                    border.width: 1
                    radius: 10

                    Button {
                        text: "Yes"
                        anchors.fill: parent
                        flat: true
                        onClicked: {
                            startButton.visible = true
                            pauseButton.visible = false
                            stopButton.visible = false
                            // Start the timer when the button is clicked
                            timer.stop()
                            rectangle.elapsedSeconds = 0
                            timerLabel.text = "00:00:00"
                            rectangle.startButtonClicked = false
                            device.javaDisconnectDevice()
                            device.bleDeviceDisconnected()
                            leftspeed.text = 0
                            leftCount.text = 0
                            leftPower.text = 0
                            rightspeed.text = 0
                            rightCount.text = 0
                            rightPower.text = 0
                            heartrateReadingLabel.text = 0
                            caloriesReading.text = 0
                            confirmPopup.close()
                            roundSelectPage.visible = true
                            sensorReadingPage.visible = false
                        }
                    }
                }
            }
        }
        //}

        // Center the popup on the screen
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        // Close the popup after a short delay
        property string text: "" // Property to dynamically set the error message text
    }

    Timer {
        id: countdownTimer
        interval: 250 // 0.5 second
        repeat: true
        onTriggered: {
            if (rectangle.countdownValue > 0) {
                rectangle.countdownValue -= 0.25
            } else {
                countdownTimer.stop()
                // Start the timer when the button is clicked
                timer.start()
                rectangle.startButtonClicked = true
            }
        }
    }

    Rectangle {
        id: circularProgressContainer
        width: 150
        height: 150
        radius: 75
        visible: false
        color: "transparent"
        anchors.centerIn: parent

        Text {
            id: countdownText
            text: rectangle.countdownValue > 0 ? Math.ceil(
                                                     rectangle.countdownValue) : ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pointSize: 40
            anchors.centerIn: parent
            color: "white"
        }

        Canvas {
            id: countdownCanvas
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            onPaint: {
                var ctx = countdownCanvas.getContext("2d")
                ctx.clearRect(0, 0, countdownCanvas.width,
                              countdownCanvas.height)
                ctx.beginPath()
                ctx.arc(countdownCanvas.width / 2, countdownCanvas.height / 2,
                        countdownCanvas.width / 2 - 5, 0,
                        2 * Math.PI * (rectangle.countdownValue / 3), false)
                ctx.lineWidth = 8
                ctx.strokeStyle = "red"
                ctx.stroke()
            }
            //onTriggered: countdownCanvas.requestPaint()
            Connections {
                target: countdownTimer
                function onTriggered() {
                    countdownCanvas.requestPaint()
                }
            }
        }
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
            //console.log("HR Value:" + hrVal)
            if (rectangle.startButtonClicked) {
                heartrateReadingLabel.text = hrVal
            }
        }
        function onLeftRealTimePunchReadingValue(leftPunchSpeed, leftPunchCount, leftPunchPower, userWeight, leftPunchTime) {
            rectangle.userWeight = userWeight
            if (rectangle.startButtonClicked) {
                leftspeed.text = leftPunchSpeed
                leftCount.text = leftPunchCount
                leftPower.text = leftPunchPower
                //console.log("left Punches time:" + leftPunchTime)
                rectangle.punchTime += leftPunchTime
            }
        }
        function onRightRealTimePunchReadingValue(rightPunchSpeed, rightPnchCount, rightPunchPower, userWeight, rightPunchTime) {
            rectangle.userWeight = userWeight
            if (rectangle.startButtonClicked) {
                rightspeed.text = rightPunchSpeed
                rightCount.text = rightPnchCount
                rightPower.text = rightPunchPower
                //console.log("right Punches time:" + rightPunchTime)
                rectangle.punchTime += rightPunchTime
            }
        }
    }
}
