import QtQuick 2.15
import QtQuick.Controls 2.15

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

    property var bleDevice: [null, null, null]

    Image {
        id: backButton
        height: 26
        source: "qrc:/ui/assets/images/backArrow.png"
        anchors.topMargin: 16
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageloader.pageLoader("backToBLEConnect")
                bleModel.clear()
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
        id: connectButton
        y: 662
        height: 52
        text: qsTr("Connect to device")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 41
        anchors.rightMargin: 45
        anchors.bottomMargin: 26
        font.pointSize: 16
        highlighted: true
        enabled: true

        Label {
            id: addressLabel
            height: 37
            color: "#ffffff"
            text: qsTr("Device connection")
            visible: false
            font.bold: true
            font.pointSize: 18
            font.italic: true
        }

        onClicked: {
            pageloader.pageLoader("ToSensorReadingPage")
        }
    }

    Label {
        id: instrctLabel
        height: 50
        color: "white"
        text: qsTr("For armband heart rate monitor,\nplease turn on the device before use.")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: searchLabel.bottom
        anchors.leftMargin: 54
        anchors.rightMargin: 66
        anchors.topMargin: 6
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 16
        font.italic: true
    }

    Label {
        id: pageTitleLabel
        height: 37
        color: "#ffffff"
        text: qsTr("Device connection")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 98
        anchors.rightMargin: 98
        anchors.topMargin: 8
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pointSize: 18
        font.italic: true
    }

    Label {
        id: searchLabel
        height: 25
        color: "#ffffff"
        text: qsTr("Searching for Heart rate device...")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: image.bottom
        anchors.leftMargin: 59
        anchors.rightMargin: 55
        anchors.topMargin: 20
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 20
        font.italic: true
        font.bold: false
        Image {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: -26
            anchors.rightMargin: 296
            anchors.topMargin: -1
            anchors.bottomMargin: 1
            source: "qrc:/ui/assets/images/search.png"
        }
    }

    Image {
        id: image
        height: 240
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 51
        anchors.rightMargin: 45
        anchors.topMargin: 65
        source: "qrc:/ui/assets/images/heartrate.jpg"
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        id: viewContainer
        height: 300
        color: "white"
        radius: 14
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: instrctLabel.bottom
        anchors.leftMargin: 40
        anchors.rightMargin: 39
        anchors.topMargin: 16
        visible: true

        ListView {
            id: bleListView
            anchors.fill: parent
            model: bleModel
            clip: true
            spacing: 5
            width: parent.width // Adjust width as needed
            height: parent.height // Adjust height as needed

            delegate: Rectangle {
                id: bleDelegate
                width: bleListView.width
                height: 50
                color: index % 2 === 0 ? "#262626" : "#404040"
                radius: 14

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //addressLabel.text = bleAddress
                        bleDelegate.color = "#993333"
                        rectangle.bleDevice[2] = bleAddress
                        if (rectangle.bleDevice[2] != null) {
                            console.log(bleName + ": " + rectangle.bleDevice[2])
                            connectButton.enabled = true
                        }
                    }
                }

                Text {
                    text: bleName // Display the BLE name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    leftPadding: 10
                    font.pixelSize: 16
                    color: "white"
                }
                Text {
                    text: bleAddress // Display the BLE address
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    rightPadding: 10
                    font.pixelSize: 16
                    color: "white"
                    visible: true
                }
            }
        }
        function addBleDevice(bleName, bleAddress) {
            // Check if the bleAddress already exists in the model
            var addressExists = false
            for (var i = 0; i < bleModel.count; ++i) {
                if (bleModel.get(i).bleAddress === bleAddress) {
                    addressExists = true
                    break
                }
            }

            // If bleAddress doesn't exist, append the new device
            if (!addressExists) {
                bleModel.append({
                                    "bleName": bleName,
                                    "bleAddress": bleAddress
                                })
            } else {
                // Handle the case when the address already exists (optional)
                console.log("Address already exists: " + bleAddress)
            }
        }

        ListModel {
            id: bleModel
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000 // 0.5 second
        repeat: true
        onTriggered: {
            if (rectangle.countdownValue > 0) {
                rectangle.countdownValue -= 1
            } else {
                for (var i = 0; i < ((rectangle.bleDevice.length) - 1); i++) {
                    device.javaConnectDevice(rectangle.bleDevice[i])
                }
                countdownTimer.stop()
            }
        }
    }

    property double countdownValue: 3

    Connections {
        target: pageloader
        function onSwitchToBLEConnect() {
            bleModel.clear()
            deviceConnectPage.visible = true
            heartRateDevicePage.visible = false
        }
        function onSwitchToSensorReadingPage() {
            //device.connectDevice(addressLabel.text)
            device.connectDevice(rectangle.bleDevice[2])
            countdownTimer.start()
            //console.log("New Heart Address: " + addressLabel.text)
            sensorReadingPage.visible = true
            heartRateDevicePage.visible = false
        }
    }

    Connections {
        target: device
        function onSendAddressHeart(bleName, bleAddress) {
            //console.log(bleName + ": " + bleAddress)
            viewContainer.addBleDevice(bleName, bleAddress)
        }
    }
}
