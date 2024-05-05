import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: rectangle1
    width: 410
    height: 740
    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    Text {
        text: "Hello !!! Welcome to Profile Page. \n  I am still work in progress" // Display the BLE name
        anchors.centerIn: parent
        anchors.left: parent.left
        leftPadding: 10
        font.pixelSize: 20
        color: "black"
    }

    TabBar {
        id: tabBar
        y: 299
        height: 57
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0

        background: Rectangle {
            color: "#a3a375"
        }

        TabButton {
            id: trainTab
            text: qsTr("Train")
            //icon.color: "#ffffff"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -8
            icon.source: "qrc:/ui/assets/images/boxing.png"
            display: AbstractButton.TextUnderIcon
            //height: parent.height
            checked: false
            onClicked: {
                quickStartPage.visible = true
                dataPage.visible = false
                profilePage.visible = false
                trainTab.checked = true
                profileTab.checked = false
                dataTab.checked = false
            }
        }
        TabButton {
            id: dataTab
            text: qsTr("Data")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -8
            // icon.color: "#ffffff"
            icon.source: "qrc:/ui/assets/images/dataOn.png"
            display: AbstractButton.TextUnderIcon
            checked: false

            //height: parent.height
            onClicked: {
                dataPage.visible = true
                quickStartPage.visible = false
                profilePage.visible = false
                trainTab.checked = false
                profileTab.checked = false
                dataTab.checked = true
            }
        }
        TabButton {
            id: profileTab
            text: qsTr("Profile")
            //icon.color: "#ffffff"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -8
            icon.source: "qrc:/ui/assets/images/mineOn.png"
            display: AbstractButton.TextUnderIcon
            checked: true

            //height: parent.height
            onClicked: {
                profilePage.visible = true
                quickStartPage.visible = false
                dataPage.visible = false
                trainTab.checked = false
                profileTab.checked = true
                dataTab.checked = false
            }
        }
    }
}
