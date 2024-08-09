import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.LocalStorage 2.0

Rectangle {
    id: backgroundImage
    //anchors.fill: parent
    layer.enabled: false
    opacity: 0.7
    z: 1
    color: "black"
    height: 740
    width: parent.width

    Rectangle {
        id: rectangle
        height: parent.height / 2.7
        color: "black"
        border.color: "#ffffff"
        radius: 20
        border.width: 2
        visible: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 42
        anchors.rightMargin: 42
        anchors.topMargin: 50

        ColumnLayout {
            anchors.fill: parent

            Label {
                id: headLabel
                text: qsTr("Add training plan")
                color: "white"
                font.pointSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                font.italic: true
            }

            Rectangle {
                border.color: "#ffffff"
                border.width: 2
                Layout.preferredHeight: 180
                Layout.fillWidth: true
                color: "#000000"

                RowLayout {
                    anchors.fill: parent
                    spacing: -2

                    //anchors.leftMargin: -185
                    Rectangle {
                        id: rectangle1
                        color: "#000000"
                        border.color: "#ffffff"
                        border.width: 2
                        Layout.preferredWidth: parent.width / 2.4
                        Layout.fillHeight: true

                        Label {
                            id: roundLabel
                            color: "#ffffff"
                            text: qsTr("Round")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 0
                            anchors.topMargin: 0
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignTop
                            topPadding: 5
                            leftPadding: 15
                            font.pointSize: 14
                        }
                        Image {
                            id: clockImage
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: roundLabel.bottom
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 17
                            anchors.rightMargin: 70
                            anchors.topMargin: 15
                            anchors.bottomMargin: 31
                            source: "qrc:/ui/assets/images/clock-tool.png"
                            fillMode: Image.PreserveAspectFit
                        }

                        ComboBox {
                            id: roundBox
                            y: 77
                            width: 100 // Set your desired fixed width
                            height: 40 // Set your desired fixed height
                            anchors.topMargin: 13
                            font.pixelSize: 18
                            wheelEnabled: true
                            flat: false
                            clip: true
                            valueRole: "value"
                            textRole: "text"
                            anchors {
                                left: clockImage.right
                                right: parent.right
                                rightMargin: 26
                                leftMargin: 15
                            }
                            model: (function () {
                                var data = []

                                for (var i = 1; i <= 99; i++) {
                                    data.push({
                                                  "value": i,
                                                  "text": qsTr(i.toString())
                                              })
                                }
                                return data
                            })()

                            background: Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "black"
                                radius: 15
                            }

                            // Set the text color for the selected item
                            contentItem: Text {
                                id: roundCount
                                text: roundBox.currentText
                                font.pixelSize: 19
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }

                            // Customize the appearance of the dropdown indicator
                            indicator: Item {
                                id: item1
                                width: 13
                                height: 13
                                anchors.left: roundCount.right
                                anchors.top: parent.top
                                anchors.leftMargin: 2
                                anchors.topMargin: 12
                                Image {
                                    anchors.fill: parent
                                    source: "qrc:/ui/assets/images/down.png"
                                }
                            }

                            popup: Popup {
                                width: 100 // Match this with the ComboBox width
                                height: 200 // Set a fixed height for the popup
                                implicitWidth: 100 // Ensure the popup doesn't resize dynamically
                                implicitHeight: 200 // Ensure the popup doesn't resize dynamically

                                // Customize the appearance of each item in the dropdown list
                                contentItem: ListView {
                                    width: parent.width
                                    height: parent.height
                                    model: roundBox.delegateModel

                                    delegate: ItemDelegate {
                                        width: parent.width
                                        contentItem: Text {
                                            text: modelData.text
                                            color: "white"
                                            font.pixelSize: 18
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        color: "#000000"
                        border.color: "#ffffff"
                        border.width: 2
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width / 1.7

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: -5

                            Rectangle {
                                id: rectangle2
                                color: "#000000"
                                border.color: "#ffffff"
                                border.width: 2
                                Layout.fillHeight: true
                                Layout.preferredHeight: parent.height / 3
                                Layout.fillWidth: true

                                Label {
                                    color: "#ffffff"
                                    text: qsTr("Training time (hh:mm:ss)")
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.leftMargin: 0
                                    anchors.topMargin: 0
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignTop
                                    topPadding: 3
                                    leftPadding: 10
                                    font.pointSize: 15
                                }

                                ComboBox {
                                    id: trainingBox
                                    height: 40
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 40
                                    anchors.rightMargin: 40
                                    anchors.verticalCenterOffset: 3
                                    valueRole: "value"
                                    textRole: "text"

                                    // Model for times from 00:00:00 to 23:59:59
                                    model: ListModel {
                                        Component.onCompleted: {
                                            for (var h = 0; h < 24; h++) {
                                                for (var m = 0; m < 60; m++) {
                                                    for (var s = 0; s < 60; s++) {
                                                        var time = (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
                                                        append({
                                                                   "value": time,
                                                                   "text": time
                                                               })
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    background: Rectangle {
                                        width: parent.width
                                        height: parent.height
                                        color: "black"
                                        radius: 15
                                    }

                                    // Display the selected time
                                    contentItem: Text {
                                        id: trainingText
                                        text: trainingBox.currentText
                                        font.pixelSize: 15
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.bold: true
                                    }
                                    indicator: Item {
                                        width: 15
                                        height: 15
                                        anchors.left: trainingText.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 0
                                        anchors.topMargin: 14
                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/ui/assets/images/down.png"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            // Use the appropriate path for your image
                                        }
                                    }

                                    // Customize the dropdown appearance if needed
                                    popup: Popup {
                                        width: 150 // Match this with the ComboBox width
                                        height: 400 // Set a fixed height for the popup
                                        implicitWidth: 150 // Ensure the popup doesn't resize dynamically
                                        implicitHeight: 400 // Ensure the popup doesn't resize dynamically

                                        // Customize the appearance of each item in the dropdown list
                                        contentItem: ListView {
                                            width: parent.width
                                            height: parent.height
                                            model: trainingBox.delegateModel

                                            delegate: ItemDelegate {
                                                width: parent.width
                                                contentItem: Text {
                                                    text: modelData.text
                                                    color: "white"
                                                    font.pixelSize: 18
                                                }
                                            }
                                            ScrollBar.vertical: ScrollBar {
                                                policy: ScrollBar.AlwaysOn
                                            }
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                color: "#000000"
                                border.color: "#ffffff"
                                border.width: 2
                                Layout.fillHeight: true
                                Layout.preferredHeight: parent.height / 3
                                Layout.fillWidth: true

                                Label {
                                    color: "#ffffff"
                                    text: qsTr("Break time (hh:mm:ss)")
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.leftMargin: 0
                                    anchors.topMargin: 0
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignTop
                                    topPadding: 3
                                    leftPadding: 10
                                    font.pointSize: 15
                                }
                                ComboBox {
                                    id: breakBox
                                    height: 40
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.leftMargin: 40
                                    anchors.rightMargin: 40
                                    anchors.verticalCenterOffset: 4
                                    valueRole: "value"
                                    textRole: "text"

                                    // Model for times from 00:00:00 to 23:59:59
                                    model: ListModel {
                                        Component.onCompleted: {
                                            for (var h = 0; h < 24; h++) {
                                                for (var m = 0; m < 60; m++) {
                                                    for (var s = 0; s < 60; s++) {
                                                        var time = (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
                                                        append({
                                                                   "value": time,
                                                                   "text": time
                                                               })
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    background: Rectangle {
                                        width: parent.width
                                        height: parent.height
                                        color: "black"
                                        radius: 15
                                    }

                                    // Display the selected time
                                    contentItem: Text {
                                        id: breakText
                                        text: breakBox.currentText
                                        font.pixelSize: 15
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font.bold: true
                                    }
                                    indicator: Item {
                                        width: 15
                                        height: 15
                                        anchors.left: breakText.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 0
                                        anchors.topMargin: 14
                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/ui/assets/images/down.png"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            // Use the appropriate path for your image
                                        }
                                    }

                                    // Customize the dropdown appearance if needed
                                    popup: Popup {
                                        width: 150 // Match this with the ComboBox width
                                        height: 400 // Set a fixed height for the popup
                                        implicitWidth: 150 // Ensure the popup doesn't resize dynamically
                                        implicitHeight: 400 // Ensure the popup doesn't resize dynamically

                                        // Customize the appearance of each item in the dropdown list
                                        contentItem: ListView {
                                            width: parent.width
                                            height: parent.height
                                            model: breakBox.delegateModel

                                            delegate: ItemDelegate {
                                                width: parent.width
                                                contentItem: Text {
                                                    text: modelData.text
                                                    color: "white"
                                                    font.pixelSize: 18
                                                }
                                            }
                                            ScrollBar.vertical: ScrollBar {
                                                policy: ScrollBar.AlwaysOn
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                color: "#000000"
                                border.color: "#ffffff"
                                border.width: 2
                                Layout.fillHeight: true
                                Layout.preferredHeight: parent.height / 3
                                Layout.fillWidth: true

                                Label {
                                    color: "#ffffff"
                                    text: qsTr("Activity")
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.leftMargin: 0
                                    anchors.topMargin: 0
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignTop
                                    topPadding: 3
                                    leftPadding: 10
                                    font.pointSize: 15
                                }
                                ComboBox {
                                    id: activityBox
                                    y: 18
                                    height: 37
                                    textRole: "text"
                                    valueRole: "value"
                                    font.pixelSize: 18
                                    anchors.topMargin: 6
                                    anchors {
                                        left: parent.left
                                        right: parent.right
                                        rightMargin: 29
                                        leftMargin: 8
                                    }
                                    background: Rectangle {
                                        width: parent.width
                                        height: parent.height
                                        color: "black"
                                        radius: 15
                                    }
                                    contentItem: Text {
                                        id: activityText
                                        text: activityBox.currentText
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.pixelSize: 10
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        font.bold: true
                                    }
                                    indicator: Item {
                                        width: 15
                                        height: 15
                                        anchors.left: activityText.right
                                        anchors.top: parent.top
                                        anchors.leftMargin: 3
                                        anchors.topMargin: 14
                                        Image {
                                            anchors.fill: parent
                                            source: "qrc:/ui/assets/images/down.png"
                                            // Use the appropriate path for your image
                                        }
                                    }
                                    popup: Popup {
                                        width: 350 // Match this with the ComboBox width
                                        height: 200 // Set a fixed height for the popup
                                        implicitWidth: 350 // Ensure the popup doesn't resize dynamically
                                        implicitHeight: 200 // Ensure the popup doesn't resize dynamically

                                        // Customize the appearance of each item in the dropdown list
                                        contentItem: ListView {
                                            width: parent.width
                                            height: parent.height
                                            model: activityBox.delegateModel

                                            delegate: ItemDelegate {
                                                width: parent.width
                                                contentItem: Text {
                                                    text: modelData.text
                                                    color: "white"
                                                    font.pixelSize: 13
                                                }
                                            }
                                            ScrollBar.vertical: ScrollBar {
                                                policy: ScrollBar.AlwaysOn
                                            }
                                        }
                                    }
                                    model: [{
                                            "value": Qt.NoModifier,
                                            "text": qsTr("select Activity")
                                        }, {
                                            "value": Qt.ShiftModifier,
                                            "text": qsTr("Shadow boxing")
                                        }, {
                                            "value": Qt.ShiftModifier,
                                            "text": qsTr("Boxing with punching bag")
                                        }, {
                                            "value": Qt.ShiftModifier,
                                            "text": qsTr("Boxing with a heavy bag")
                                        }, {
                                            "value": Qt.ShiftModifier,
                                            "text": qsTr("Real boxing in the ring")
                                        }]
                                }
                            }
                        }
                    }
                }
            }
            RowLayout {
                Layout.preferredHeight: 60
                Layout.fillWidth: true

                Button {
                    text: "Yes"
                    font.family: "Courier"
                    font.bold: true
                    font.italic: false
                    font.pointSize: 13
                    icon.width: 24
                    Layout.leftMargin: 20
                    Layout.topMargin: -7
                    Layout.fillWidth: true
                    highlighted: true
                    flat: false

                    onClicked: {
                        // console.log("Selected Round: " + roundBox.currentText)
                        // console.log("Training Time: " + trainingBox.currentText)
                        // console.log("Break Time: " + breakBox.currentText)
                        // console.log("Activity: " + activityBox.currentText)
                        roundType.roundFunction(roundBox.currentText,
                                                trainingBox.currentText,
                                                breakBox.currentText,
                                                activityBox.currentText)
                        trainingPlan.visible = false
                        roundType.visible = true
                    }
                }
                Button {
                    id: cancelButton
                    Layout.preferredHeight: 50
                    //text: "Cancel"

                    //Layout.preferredHeight: 40
                    Layout.rightMargin: 20
                    Layout.topMargin: -7
                    Layout.bottomMargin: 0
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: "black"
                        radius: 18
                        border.color: "#ffffff"
                        border.width: 2 // Optional: adds rounded corners
                    }

                    contentItem: Text {
                        text: "Cancel"
                        color: "white" // Sets the text color to white for better contrast with the black background
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pointSize: 13
                        font.family: "Courier"
                    }
                    onClicked: {
                        trainingPlan.visible = false
                        roundType.visible = true
                    }
                }
            }
        }
    }
}
