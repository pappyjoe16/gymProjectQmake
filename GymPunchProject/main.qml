import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "ui"
import Pageswitcher 1.0
import AuthHandler 1.0
import Base64format 1.0
import Device 1.0

Window {
    width: 410
    height: 740
    visible: true
    id: mainWindow
    title: "gymAppTest2"

    Image {
        id: backgroundImage
        width: 410
        height: 740
        anchors.fill: parent
        source: "qrc:/ui/assets/images/backgnd1.jpg"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        layer.enabled: false
        opacity: 1
        z: -1
        fillMode: Image.Stretch
        sourceSize.height: 740
    }

    function checkLoginDetails() {
        signupPage.creatDB()
        var loginDetails = signupPage.retrieveLoginDetails()
        if (loginDetails.exist) {
            //console.log("Username: " + loginDetails.username + ", Password: "
            //            + loginDetails.password)
            loginPage.callLogin(loginDetails.username, loginDetails.password)
            // if (errorMessage === "INVALID_LOGIN_CREDENTIALS") {
            //     return true
            // }
            return false // Hide mainPage if login details exist
        } else {
            console.log("No login details saved.")
            return true // show mainPage if no login details exist
        }
    }
    Pageswitcher {
        id: pageloader
    }

    Device {
        id: device
    }

    AuthHandler {
        id: authHandler
    }

    Base64format {
        id: base64format
    }

    LoginPage {
        id: loginPage
        visible: false
    }

    SignupPage {
        id: signupPage
        visible: false
    }
    ForgetPassword {
        id: forgetPassword
        visible: false
    }
    BLEDeviceConnectPage {
        id: deviceConnectPage
        visible: false
    }
    UserInfoPage {
        id: userInfoPage
        visible: false
    }

    QuickStartPage {
        id: quickStartPage
        visible: false
    }

    HelpPage {
        id: helpPage
        visible: false
    }

    DataPage {
        id: dataPage
        visible: false
    }

    ProfilePage {
        id: profilePage
        visible: false
    }
    HeartRateDevicePage {
        id: heartRateDevicePage
        visible: false
    }
    SensorReadingPage {
        id: sensorReadingPage
        visible: false
    }
    DataEntry {
        id: dataEntryPage
        visible: false
    }
    RoundSelectPage {
        id: roundSelectPage
        visible: false
    }
    TrainingPlan {
        id: trainingPlan
        visible: false
    }
    RoundTypePage {
        id: roundType
        visible: false
    }

    AppPage {
        id: mainPage
        visible: checkLoginDetails() // Call a function to determine visibility
    }

    Connections {
        id: connect
        target: authHandler
        function onSignInErrorSignal(signInErrorMessage) {
            var errorMessage = ""

            switch (signInErrorMessage) {
            case "INVALID_EMAIL":
                errorMessage = "Error Occured\nYou Entered an Invalid Email"
                break
            case "INVALID_LOGIN_CREDENTIALS":
                errorMessage = "Error Occured\nInvalid Login Details"

                break
            case "TOO_MANY_ATTEMPTS_TRY_LATER":
                errorMessage = "Access to account is blocked\nDue to many failed login attempts\nKindly reset your password"
                break
            case "SUCCESS":
                errorMessage = "Successful Login"
                quickStartPage.visible = true
                break
            default:
                errorMessage = "Unknown Error"
            }

            loginPage.errorPopup.text = errorMessage
            loginPage.errorPopup.open()
        }
    }
}
