import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: rectangle
    width: 410
    height: 740
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#100412"
        }

        GradientStop {
            position: 0.58579
            color: "#93676b"
        }

        GradientStop {
            position: 0.92544
            color: "#670505"
        }
        orientation: Gradient.Vertical
    }
    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

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
            pageloader.pageLoader("backToQuickstart")
            bleModelRight.clear()
            bleModelLeft.clear()
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 347
            leftMargin: 4
        }
    }

    Rectangle {
        id: leftRectangle
        height: 469
        radius: 14
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: connectButton.top
        anchors.leftMargin: 20
        anchors.rightMargin: 215
        anchors.topMargin: 173
        anchors.bottomMargin: 20

        Image {
            id: leftSensorImage
            height: 137
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 34
            anchors.rightMargin: 34
            anchors.topMargin: 20
            source: "qrc:/ui/assets/images/leftSensor1.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: leftViewContainer
            color: "#e6e6e6"
            radius: 14
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: leftSensorImage.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.rightMargin: 13
            anchors.topMargin: 6
            anchors.bottomMargin: 10
            visible: false

            ListView {
                id: bleListViewLeft
                anchors.fill: parent
                model: bleModelLeft
                clip: true
                spacing: 5
                width: parent.width // Adjust width as needed
                height: parent.height // Adjust height as needed

                delegate: Rectangle {

                    width: bleListViewLeft.width
                    height: 50
                    color: index % 2 === 0 ? "#262626" : "#404040"
                    radius: 14

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //device.connectDevice(bleAddress)
                            console.log(bleName + ": " + bleAddress)
                        }
                    }

                    Text {
                        text: bleName // Display the BLE name
                        anchors.centerIn: parent
                        anchors.left: parent.left
                        leftPadding: 10
                        font.pixelSize: 16
                        color: "white"
                    }
                    Text {
                        text: bleAddress // Display the BLE address
                        anchors.centerIn: parent
                        anchors.right: parent.right
                        rightPadding: 10
                        font.pixelSize: 16
                        color: "white"
                        visible: false
                    }
                }
            }

            function addBleDevicLeft(bleName, bleAddress) {
                // Check if the bleAddress already exists in the model
                var addressExists = false
                for (var i = 0; i < bleModelLeft.count; ++i) {
                    if (bleModelLeft.get(i).bleAddress === bleAddress) {
                        addressExists = true
                        break
                    }
                }

                // If bleAddress doesn't exist, append the new device
                if (!addressExists) {
                    bleModelLeft.append({
                                        "bleName": bleName,
                                        "bleAddress": bleAddress
                                    })
                } else {
                    // Handle the case when the address already exists (optional)
                    console.log("Address already exists: " + bleAddress)
                }
            }

            ListModel {
                id: bleModelLeft
            }
        }
    }

    Rectangle {
        id: rightRectangle
        height: 469
        radius: 14
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: connectButton.top
        anchors.leftMargin: 211
        anchors.rightMargin: 24
        anchors.topMargin: 173
        anchors.bottomMargin: 20

        Image {
            id: rightSensorImage
            height: 137
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 34
            anchors.rightMargin: 34
            anchors.topMargin: 20
            source: "qrc:/ui/assets/images/rightSensor.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: rightViewContainer
            color: "#e6e6e6"
            radius: 14
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rightSensorImage.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.rightMargin: 13
            anchors.topMargin: 6
            anchors.bottomMargin: 10
            visible: false

            ListView {
                id: bleListViewRight
                anchors.fill: parent
                model: bleModelRight
                clip: true
                spacing: 5
                width: parent.width // Adjust width as needed
                height: parent.height // Adjust height as needed

                delegate: Rectangle {

                    width: bleListViewRight.width
                    height: 50
                    color: index % 2 === 0 ? "#262626" : "#404040"
                    radius: 14

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //device.connectDevice(bleAddress)
                            console.log(bleName + ": " + bleAddress)
                        }
                    }

                    Text {
                        text: qsTr(bleName) // Display the BLE name
                        anchors.centerIn: parent
                        anchors.left: parent.left
                        leftPadding: 10
                        font.pixelSize: 16
                        color: "white"
                    }
                    Text {
                        text: bleAddress // Display the BLE address
                        anchors.centerIn: parent
                        rightPadding: 10
                        font.pixelSize: 16
                        color: "white"
                        visible: false
                    }
                }
            }

            function addBleDevicRight(bleName, bleAddress) {
                // Check if the bleAddress already exists in the model
                var addressExists = false
                for (var i = 0; i < bleModelRight.count; ++i) {
                    if (bleModelRight.get(i).bleAddress === bleAddress) {
                        addressExists = true
                        break
                    }
                }

                // If bleAddress doesn't exist, append the new device
                if (!addressExists) {
                    bleModelRight.append({
                                        "bleName": bleName,
                                        "bleAddress": bleAddress
                                    })
                } else {
                    // Handle the case when the address already exists (optional)
                    console.log("Address already exists: " + bleAddress)
                }
            }

            ListModel {
                id: bleModelRight
            }
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
        onClicked: {
            pageloader.pageLoader("ToHeartRateDevice")

        }
    }

    Label {
        id: instrctLabel
        height: 37
        color: "white"
        text: qsTr("Please press the power button to start your device and connect \nthe device with the same ID number on the back")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 115
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 12
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
        id: helpLabel
        height: 37
        color: "#ffffff"
        text: qsTr("Help")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 336
        anchors.rightMargin: 8
        anchors.topMargin: 17
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 16
        font.italic: true
        font.bold: true

        MouseArea {
            anchors.fill: parent
            onClicked: pageloader.pageLoader("helpPage")
        }
    }
    Label {
        id: searchLabel
        height: 25
        color: "#ffffff"
        text: qsTr("Searching...")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 132
        anchors.rightMargin: 132
        anchors.topMargin: 89
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 15
        font.italic: true
        font.bold: false
        Image {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 119
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            source: "qrc:/ui/assets/images/search.png"
        }
    }

    Connections {
        target: pageloader
        function onSwitchToQuickstart() {
            roundSelectPage.visible = true
            deviceConnectPage.visible = false
        }
        function onSwitchToHelpPage() {
            helpPage.visible = true
            deviceConnectPage.visible = false
        }
        function onSwitchToHeartRateDevice() {
            deviceConnectPage.visible = false
            heartRateDevicePage.visible = true
            device.startDeviceDiscovery()
        }
    }

    Connections {
        target: device
        function onSendAddressLeft(bleName, bleAddress) {
            leftViewContainer.visible = true
            //console.log(bleName + ": " + bleAddress)
            leftViewContainer.addBleDevicLeft(bleName, bleAddress)
        }
        function onSendAddressRight(bleName, bleAddress) {
            rightViewContainer.visible = true
            //console.log(bleName + ": " + bleAddress)
            rightViewContainer.addBleDevicRight(bleName, bleAddress)
        }

    }
}
