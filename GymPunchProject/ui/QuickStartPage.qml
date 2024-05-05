

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: rectangle1
    width: 410
    height: 740
    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
    anchors.leftMargin: 0
    anchors.topMargin: 0

    Image {
        id: quickstartImage
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        anchors.bottomMargin: parent.height / 2
        source: "qrc:/ui/assets/images/backgnd8.jpg"
        Text {
            text: "<b><i>Quick Start</b><i>"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 103
            anchors.rightMargin: 102
            anchors.topMargin: 166
            anchors.bottomMargin: 165
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Helvetica"
            font.pointSize: 24
            color: "white"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageloader.pageLoader("connectPage")
                    console.log("Quick Image clicked!")
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageloader.pageLoader("connectPage")
                console.log("Quick Image clicked!")
            }
        }
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 0
            rightMargin: 0
            topMargin: 0
        }
    }

    Image {
        id: trainingImage
        anchors.top: quickstartImage.bottom
        anchors.topMargin: 0
        source: "qrc:/ui/assets/images/05.jpeg"
        Text {
            text: "<b><i>Round Mode</b><i> "
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 103
            anchors.rightMargin: 102
            anchors.topMargin: 166
            anchors.bottomMargin: 165
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Helvetica"
            font.pointSize: 24
            color: "white"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Handle the click event here
                    console.log("Training Image clicked!")
                    // Add your custom logic or navigate to another page, etc.
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Handle the click event here
                console.log("Training Image clicked!")
                // Add your custom logic or navigate to another page, etc.
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
                    checked: true
                    onClicked: {

                        // quickStartPage.visible = true
                        // dataPage.visible = false
                        // profilePage.visible = false
                        // trainTab.checked = true
                        // profileTab.checked = false
                        // dataTab.checked = false
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
                    //height: parent.height
                    checked: false

                    onClicked: {

                        // dataPage.visible = true
                        // quickStartPage.visible = false
                        // profilePage.visible = false
                        // trainTab.checked = false
                        // profileTab.checked = false
                        // dataTab.checked = true
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
                    //height: parent.height
                    checked: false

                    onClicked: {

                        // profilePage.visible = true
                        // quickStartPage.visible = false
                        // dataPage.visible = false
                        // trainTab.checked = false
                        // profileTab.checked = true
                        // dataTab.checked = false
                    }
                }
            }
        }
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 0
            rightMargin: 0
            bottomMargin: 0
        }
    }

    Connections {
        target: pageloader
        function onSwitchToConnectPage() {
            deviceConnectPage.visible = true
            quickStartPage.visible = false
            device.startDeviceDiscovery()
        }
    }
}
