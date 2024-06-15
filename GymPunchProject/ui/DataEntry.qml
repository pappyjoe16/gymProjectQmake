import QtCore
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts 2.15

//import Qt.labs.platform
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

    property string qmlbase64String: ""

    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    Image {
        id: profileImage
        height: 120
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 145
        anchors.rightMargin: 145
        anchors.topMargin: 85
        source: "qrc:/ui/assets/images/user.png"
        sourceSize.height: profileImage.height
        sourceSize.width: profileImage.width
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: fileDialog.open()
        }

        Label {
            id: label
            color: "white"
            text: qsTr("+")
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 110
            anchors.rightMargin: -9
            anchors.topMargin: 70
            anchors.bottomMargin: 4
            font.bold: true
            font.pointSize: 37

            MouseArea {
                anchors.fill: parent
                onClicked: fileDialog.open()
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an image"

        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
        currentFolder: StandardPaths.standardLocations(
                           StandardPaths.PicturesLocation)[0]
        //onAccepted: profileImage.source = selectedFile
        onAccepted: {
            var fileUrl = fileDialog.selectedFile
            if (fileUrl !== "") {
                profileImage.source = selectedFile
                //console.log("Now I will call base64format function....")
                base64format.handleUserProfileImage(profileImage.source)
            }
        }
        onRejected: {
            console.log("Dialog rejected")
        }
    }

    Label {
        id: profile
        width: 144
        height: 45
        color: "#ffffff"
        text: qsTr("Data Entry")
        horizontalAlignment: Text.AlignHCenter
        layer.mipmap: true
        font.weight: Font.Bold
        font.pointSize: 32
        font.bold: true
        font.family: "Times New Roman"
        anchors.topMargin: 19
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 100
            leftMargin: 100
        }
    }

    TextField {
        id: userNameField
        height: 45
        placeholderText: qsTr("Enter your name")
        placeholderTextColor: "#100412"
        font.pixelSize: 18
        horizontalAlignment: Text.AlignLeft
        hoverEnabled: false
        maximumLength: 100
        echoMode: TextInput.Normal

        anchors.topMargin: 22
        anchors {
            left: parent.left
            right: parent.right
            top: profileImage.bottom
            rightMargin: 43
            leftMargin: 43
        }

        background: Item {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                radius: 15
                opacity: 1
            }
        }
        font.preferShaping: false
        onAccepted: genderBox.pressed
        cursorVisible: true
    }

    ComboBox {
        id: genderBox
        height: 45
        textRole: "text"
        valueRole: "value"
        font.pixelSize: 18
        anchors.topMargin: 6
        anchors {
            left: parent.left
            right: parent.right
            top: userNameField.bottom
            rightMargin: 43
            leftMargin: 43
        }
        background: Item {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                radius: 15
                opacity: 1
            }
        }
        model: [{
                "value": Qt.NoModifier,
                "text": qsTr("select gender")
            }, {
                "value": Qt.ShiftModifier,
                "text": qsTr("male")
            }, {
                "value": Qt.ShiftModifier,
                "text": qsTr("female")
            }, {
                "value": Qt.ShiftModifier,
                "text": qsTr("other")
            }]
    }

    ComboBox {
        id: ageBox
        height: 45
        anchors.topMargin: 13
        font.pixelSize: 18
        valueRole: "value"
        textRole: "text"
        anchors {
            left: parent.left
            right: parent.right
            top: genderBox.bottom
            rightMargin: 43
            leftMargin: 43
        }
        model: (function () {
            var data = []
            data.push({
                          "value": Qt.NoModifier,
                          "text": qsTr("select age")
                      })
            for (var i = 10; i <= 100; i++) {
                data.push({
                              "value": Qt.ShiftModifier,
                              "text": qsTr(i.toString() + " years")
                          })
            }
            return data
        })()

        background: Item {
            width: parent.width
            height: parent.height
            Rectangle {
                width: parent.width
                height: parent.height
                opacity: 1
                color: "#ffffff"
                radius: 15
            }
        }
    }

    ComboBox {
        id: heightBox
        height: 45
        anchors.topMargin: 13
        font.pixelSize: 18
        valueRole: "value"
        textRole: "text"
        anchors {
            left: parent.left
            right: parent.right
            top: ageBox.bottom
            rightMargin: 43
            leftMargin: 43
        }
        model: (function () {
            var data = []
            data.push({
                          "value": Qt.NoModifier,
                          "text": qsTr("select height")
                      })
            for (var i = 150; i <= 230; i++) {
                data.push({
                              "value": Qt.ShiftModifier,
                              "text": qsTr(i.toString() + " cm")
                          })
            }
            return data
        })()

        background: Item {
            width: parent.width
            height: parent.height
            Rectangle {
                width: parent.width
                height: parent.height
                opacity: 1
                color: "#ffffff"
                radius: 15
            }
        }
    }
    ComboBox {
        id: weightBox
        height: 45
        anchors.topMargin: 13
        font.pixelSize: 18
        valueRole: "value"
        textRole: "text"
        anchors {
            left: parent.left
            right: parent.right
            top: heightBox.bottom
            rightMargin: 43
            leftMargin: 43
        }
        model: (function () {
            var data = []
            data.push({
                          "value": Qt.NoModifier,
                          "text": qsTr("select weight")
                      })
            for (var i = 35; i <= 150; i++) {
                data.push({
                              "value": Qt.ShiftModifier,
                              "text": qsTr(i.toString() + " KG")
                          })
            }
            return data
        })()

        background: Item {
            width: parent.width
            height: parent.height
            Rectangle {
                width: parent.width
                height: parent.height
                opacity: 1
                color: "#ffffff"
                radius: 15
            }
        }
    }
    ComboBox {
        id: handBox
        height: 45
        anchors.topMargin: 13
        textRole: "text"
        valueRole: "value"
        font.pixelSize: 18
        anchors {
            left: parent.left
            right: parent.right
            top: weightBox.bottom
            rightMargin: 43
            leftMargin: 43
        }
        background: Item {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                radius: 15
                opacity: 1
            }
        }
        model: [{
                "value": Qt.NoModifier,
                "text": qsTr("select hand habit")
            }, {
                "value": Qt.ShiftModifier,
                "text": qsTr("Right handed")
            }, {
                "value": Qt.ShiftModifier,
                "text": qsTr("Left handed")
            }]
    }

    Item {
        id: __materialLibrary__
    }

    Image {
        id: baseImage
        y: 688
        height: 52
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        source: "qrc:/ui/assets/images/svg.png"
        fillMode: Image.PreserveAspectFit
    }

    Button {
        id: updateButton
        y: 604
        height: 63
        text: qsTr("Update")
        font.family: "Tahoma"
        font.bold: true
        font.italic: false
        font.pointSize: 15
        highlighted: false
        anchors.bottomMargin: 73
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            rightMargin: 88
            leftMargin: 88
        }
        onClicked: {
            if (userNameField.text.trim() === ""
                    || genderBox.currentText === "select gender"
                    || ageBox.currentText === "select age"
                    || heightBox.currentText === "select height"
                    || weightBox.currentText === "select weight"
                    || handBox.currentText === "select hand habit") {
                errorPopup.text = "All fields are required."
                errorPopup.open()
            } else {
                // console.log("Your details are as following: " + userNameField.text
                //             + "\t" + genderBox.currentText + "\t" + ageBox.currentText
                //             + "\t" + heightBox.currentText + "\t" + weightBox.currentText
                //             + "\t" + handBox.currentText + "\t" + rectangle.qmlbase64String)
                authHandler.updateUserProfile(userNameField.text,
                                              genderBox.currentText,
                                              ageBox.currentText,
                                              heightBox.currentText,
                                              weightBox.currentText,
                                              handBox.currentText,
                                              rectangle.qmlbase64String)
            }
        }
    }
    Popup {
        id: errorPopup
        width: 280
        height: 70
        contentItem: Rectangle {
            color: "lightgray"
            Label {
                anchors.centerIn: parent
                font.pointSize: 11.5
                color: "red"
                text: errorPopup.text
            }
        }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        // onOpened: {
        //     closeTimer.restart()
        // }
        Timer {
            id: closeTimer
            interval: 3000 // 3000 milliseconds (2 seconds)
            onTriggered: errorPopup.close()
        }
        property string text: "" // Property to dynamically set the error message text
    }

    Connections {
        target: base64format
        function onSendBase64String(base64String) {
            rectangle.qmlbase64String = "data:image/png;base64," + base64String
            //console.log("I am Emitted: " + base64String)
            //baseImage.source = rectangle.qmlbase64String
        }
    }

    Connections {
        target: authHandler
        function onUserAdded() {
            userInfoPage.visible = false
            quickStartPage.visible = true
        }
        function onUserRetrived(username, usergender, userage, userheight, userweight, userhandHabit, userprofilePicture) {
            // console.log("User profile received:", username, usergender,
            //             userage, userheight, userweight, userhandHabit,
            //             userprofilePicture)
            profileImage.source = userprofilePicture
            userNameField.text = username
            genderBox.currentIndex = getComboBoxIndex(genderBox, usergender)
            ageBox.currentIndex = getComboBoxIndex(ageBox, userage)
            heightBox.currentIndex = getComboBoxIndex(heightBox, userheight)
            weightBox.currentIndex = getComboBoxIndex(weightBox, userweight)
            handBox.currentIndex = getComboBoxIndex(handBox, userhandHabit)
        }
        function onUserUpdated() {
            dataEntryPage.visible = false
            roundSelectPage.visible = true
            authHandler.retriveProfile()
        }
    }

    function getComboBoxIndex(comboBox, value) {
        for (var i = 0; i < comboBox.model.length; ++i) {
            if (comboBox.model[i].text === value) {
                return i
            }
        }
        return -1 // Value not found in the model
    }
}
