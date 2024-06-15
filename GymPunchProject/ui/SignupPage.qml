import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0

Image {
    id: backgroundImage
    width: 410
    height: 740
    anchors.fill: parent
    source: "qrc:/ui/assets/images/05.jpeg"
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0
    layer.enabled: false
    opacity: 1
    z: -1
    fillMode: Image.Stretch

    function creatDB() {
        var db = LocalStorage.openDatabaseSync("GymAppDB", "1.0",
                                               "Storage for login details",
                                               1000000)

        db.transaction(function (tx) {
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS LoginDetails(username TEXT, password TEXT)')
            console.log("DB Created successfully..")
        })
    }

    function saveLoginDetails(username, password) {
        var db = LocalStorage.openDatabaseSync("GymAppDB", "1.0",
                                               "Storage for login details",
                                               1000000)

        db.transaction(function (tx) {
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS LoginDetails(username TEXT, password TEXT)')
            tx.executeSql('INSERT INTO LoginDetails VALUES(?, ?)',
                          [username, password])
            console.log("Login Details saved successfully..")
        })
    }

    function retrieveLoginDetails() {
        var db = LocalStorage.openDatabaseSync("GymAppDB", "1.0",
                                               "Storage for login details",
                                               1000000)
        var username, password
        var detailsExist = false

        db.transaction(function (tx) {
            var rs = tx.executeSql('SELECT * FROM LoginDetails')
            if (rs.rows.length > 0) {
                detailsExist = true
                username = rs.rows.item(0).username
                password = rs.rows.item(0).password
            }
        })
        console.log("Login Details retrived successfully..")

        return {
            "exist": detailsExist,
            "username": username,
            "password": password
        }
    }

    Button {
        id: backButton
        height: 45
        palette.buttonText: "white"
        icon.source: "qrc:/ui/assets/images/backArrow.png"
        icon.height: parent.height
        icon.width: parent.width
        font.family: "Tahoma"
        highlighted: true
        flat: false
        anchors.topMargin: 14
        onClicked: pageloader.pageLoader("backHome")

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 325
            leftMargin: 4
        }
    }

    Button {
        id: signupbutton
        y: 390
        height: 60
        text: qsTr("Agree and register")
        palette.buttonText: "white"
        font.family: "Tahoma"
        font.bold: true
        font.italic: false
        font.pointSize: 15
        highlighted: true
        anchors.topMargin: -22

        anchors {
            left: parent.left
            right: parent.right
            top: privacyPolicy.bottom
            rightMargin: 50
            leftMargin: 50
        }
        onClicked: {
            if (emailAddress.text.trim() == "" || passwordInput.text.trim(
                        ) == "") {
                errorPopup.text = "Username and password are required."
                errorPopup.open()
            } else if (passwordInput.text.length < 8) {
                errorPopup.text = "Password must be at least \n      8 characters long."
                errorPopup.open()
            } else {
                var encryptedPassword = authHandler.encryptPassword(
                            passwordInput.text)
                authHandler.setAPIKey("AIzaSyAmzWxVSGaolPUToZiVCdB5oo4Ffl5Afhs")
                authHandler.signUserUp(emailAddress.text, encryptedPassword)
                saveLoginDetails(emailAddress.text, encryptedPassword)
            }
        }
    }

    TextField {
        id: emailAddress
        x: 89
        y: 218
        width: 362
        height: 54
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        maximumLength: 100
        renderType: Text.QtRendering
        mouseSelectionMode: TextInput.SelectCharacters
        echoMode: TextInput.Normal
        placeholderText: qsTr("Email Address")
        color: "#330000"
        anchors.topMargin: 29
        anchors {
            left: parent.left
            right: parent.right
            top: emailLoginLabel.bottom
            rightMargin: 39
            leftMargin: 39
        }

        background: Item {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                radius: 15
                border.width: 4
                border.color: "#330000"
            }
        }

        onAccepted: passwordInput.forceActiveFocus()
        cursorVisible: true
    }

    TextField {
        id: passwordInput
        width: 362
        height: 54
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        maximumLength: 100
        renderType: Text.QtRendering
        mouseSelectionMode: TextInput.SelectCharacters
        placeholderText: qsTr("Password")
        echoMode: TextInput.Password

        anchors.topMargin: 16
        anchors {
            left: parent.left
            right: parent.right
            top: emailAddress.bottom
            rightMargin: 39
            leftMargin: 39
        }

        background: Item {
            width: parent.width
            height: parent.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#ffffff"
                radius: 15
                border.width: 4
                border.color: "#330000"
                opacity: 1
            }
        }
        font.preferShaping: false
        onAccepted: signupbutton.clicked()
        cursorVisible: true
    }

    Label {
        id: emailLoginLabel
        x: 198
        y: 155
        width: 144
        height: 26
        color: "#ffffff"
        text: qsTr("Email Register")
        horizontalAlignment: Text.AlignHCenter
        layer.mipmap: true
        font.weight: Font.Bold
        font.pointSize: 24
        font.bold: true
        font.family: "Times New Roman"
        anchors.topMargin: 135
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 89
            leftMargin: 89
        }
    }
    Label {
        id: passwordLabel
        x: 198
        y: 155
        width: 144
        height: 26
        color: "white"
        text: qsTr("The pasword must contain at least 8 characters.")
        horizontalAlignment: Text.AlignHCenter
        layer.mipmap: true
        font.pointSize: 10
        font.italic: true
        font.family: "Times New Roman"

        anchors.topMargin: 1
        anchors {
            left: parent.left
            right: parent.right
            top: passwordInput.bottom
            rightMargin: 89
            leftMargin: 89
        }
    }

    Label {
        id: privacyPolicy
        width: 165
        height: 60
        color: "white"
        //highlighted: true    use when change to button
        text: qsTr("By registering, you agree to our terms of service.\nCheck out our privacy policy")
        //layer.mipmap: true
        //font.weight: Font.Bold
        font.pointSize: 11
        font.italic: true
        font.underline: true
        font.family: "Times New Roman"
        //flat: true      use when change to button
        anchors.topMargin: 80
        //opacity: 1 //    use when change to button
        anchors {
            left: parent.left
            right: parent.right
            top: passwordLabel.bottom
            rightMargin: 52
            leftMargin: 52
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
        // Center the popup on the screen
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        // Close the popup after a short delay
        onOpened: {
            closeTimer.restart()
        }
        Timer {
            id: closeTimer
            interval: 3000 // 3000 milliseconds (2 seconds)
            onTriggered: errorPopup.close()
        }
        property string text: "" // Property to dynamically set the error message text
    }

    Connections {
        target: pageloader
        function onSwitchToAppPage() {
            mainPage.visible = true
            signupPage.visible = false
        }
    }

    Connections {
        target: authHandler
        function onSignUpErrorSignal(signUpErrorMessage) {
            //console.log("Error message received:", errorMessage)
            if (signUpErrorMessage == "EMAIL_EXISTS") {
                errorPopup.text = "  Error Occured \nEmail already exist"
                errorPopup.open()
            } else if (signUpErrorMessage == "INVALID_EMAIL") {
                errorPopup.text = "       Error Occured \nYou Enter an Invalid Email"
                errorPopup.open()
            } else if (signUpErrorMessage == "SUCCESS") {
                errorPopup.text = "Successful SignUp\nSetup your Profile"
                errorPopup.open()
                userInfoPage.visible = true
                signupPage.visible = false
            }
        }
    }

    Button {
        id: googleButton
        x: -7
        y: 383
        height: 60
        text: name.text
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: alternativeLabel.bottom
        anchors.leftMargin: 70
        anchors.rightMargin: 70
        anchors.topMargin: 12
        highlighted: false
        icon.color: "#00885757"
        icon.source: "qrc:/ui/assets/images/google.png"

        onClicked: authHandler.authenticateWithGoogle()
        Text {
            id: name
            text: qsTr("Continue with Google")
            //horizontalAlignment: Text.AlignHCenter
            //verticalAlignment: Text.AlignVCenter
            font.italic: false
            font.family: "Tahoma"
            font.bold: true
            font.pointSize: 12
            color: "red"
            visible: false
        }
    }

    Label {
        id: alternativeLabel
        x: 196
        y: 153
        width: 144
        height: 26
        color: "#ffffff"
        text: qsTr("Alternative login")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: signupbutton.bottom
        anchors.leftMargin: 124
        anchors.rightMargin: 124
        anchors.topMargin: 17
        horizontalAlignment: Text.AlignHCenter
        layer.mipmap: true
        font.pointSize: 15
        font.italic: true
        font.family: "Times New Roman"
    }

    Rectangle {
        id: line1
        height: 2
        color: "white"
        anchors.left: parent.left
        anchors.right: alternativeLabel.left
        anchors.top: signupbutton.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: -1
        anchors.topMargin: 28
    }

    Rectangle {
        id: line2
        height: 2
        color: "#ffffff"
        anchors.left: alternativeLabel.right
        anchors.right: parent.right
        anchors.top: signupbutton.bottom
        anchors.leftMargin: -3
        anchors.rightMargin: 2
        anchors.topMargin: 29
    }
}
