import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 2.15

Rectangle {
    id: backgroundImage
    width: 410
    height: 740
    anchors.fill: parent
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#0a0505"
        }
        GradientStop {
            position: 1
            color: "#000000"
        }
        orientation: Gradient.Vertical
    }
    layer.enabled: false
    opacity: 1
    z: -1

    Label {
        id: pageTitleLabel
        height: 37
        color: "#ffffff"
        text: qsTr("My Profile")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 12
        font.bold: true
        font.pointSize: 18
        font.italic: true
    }

    RowLayout {
        id: profileSummary
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageTitleLabel.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 10

        Rectangle {
            id: profilePicture
            Layout.preferredHeight: 120
            Layout.fillWidth: true
            Layout.fillHeight: true
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#2b2727"
                }
                GradientStop {
                    position: 1
                    color: "#000000"
                }
                orientation: Gradient.Vertical
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    roundSelectPage.visible = false
                    dataEntryPage.visible = true
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                spacing: 5
                Image {
                    id: userImage
                    source: "qrc:/ui/assets/images/user.png"
                    Layout.fillHeight: true
                    Layout.minimumHeight: parent.height / 4
                    Layout.minimumWidth: parent.width / 4
                    sourceSize.height: userImage.height
                    sourceSize.width: userImage.width
                    fillMode: Image.PreserveAspectFit
                }
                ColumnLayout {
                    id: column
                    spacing: 5
                    Layout.minimumHeight: parent.height
                    Layout.minimumWidth: parent.width / 4
                    Layout.fillWidth: true
                    Label {
                        id: nameLabel
                        color: "#ffffff"
                        text: qsTr("name")
                        Layout.fillWidth: true
                        font.pointSize: 20
                    }

                    Row {
                        //anchors.bottom: parent.bottom
                        //anchors.bottomMargin: 0
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        Layout.fillWidth: false
                        spacing: 10

                        Label {
                            id: heightLabel
                            color: "#ffffff"
                            text: qsTr("height")
                            font.pointSize: 17
                        }
                        Label {
                            id: weightLabel
                            color: "#ffffff"
                            text: qsTr("weight")
                            font.pointSize: 17
                        }
                        Label {
                            id: handedlabel
                            color: "#ffffff"
                            text: qsTr("handed")
                            font.pointSize: 17
                        }
                    }
                }
                Image {
                    id: image11
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 40
                    source: "qrc:/ui/assets/images/next.png"
                    Layout.rightMargin: 0
                    fillMode: Image.PreserveAspectFit
                    //anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    ColumnLayout {
        id: column2
        width: parent.width
        //anchors.topMargin: 26
        anchors.top: profileSummary.bottom
        anchors.topMargin: 10
        spacing: 2

        Rectangle {
            id: reminderCol
            color: "#151313"
            Layout.fillWidth: true
            Layout.preferredHeight: 56

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    //     roundSelectPage.visible = false
                    //     dataEntryPage.visible = true
                }
            }

            Label {
                id: labelReminder
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                text: qsTr("Start Reminder")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pointSize: 20
            }

            Image {
                id: image2
                x: 354
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 17
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                verticalAlignment: Image.AlignBottom
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: dataSyncCol
            color: "#151313"
            Layout.fillWidth: true
            Layout.preferredHeight: 56

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    //     roundSelectPage.visible = false
                    //     dataEntryPage.visible = true
                }
            }

            Label {
                id: dataSyncLabel
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                text: qsTr("Data synchronization")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pointSize: 20
            }

            Image {
                id: dataSyncImage
                x: 351
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 17
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: feedbackCol
            color: "#151313"
            Layout.fillWidth: true
            Layout.preferredHeight: 56

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    //     roundSelectPage.visible = false
                    //     dataEntryPage.visible = true
                }
            }

            Label {
                id: feedbackLabel
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                text: qsTr("Feedback")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pointSize: 20
            }

            Image {
                id: feedbackImage
                x: 352
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 17
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: helpCol
            color: "#151313"
            Layout.fillWidth: true
            Layout.preferredHeight: 56

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    //     roundSelectPage.visible = false
                    //     dataEntryPage.visible = true
                }
            }

            Label {
                id: helpLabel
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                text: qsTr("Help")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pointSize: 20
            }

            Image {
                id: helpImage
                x: 352
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 17
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            id: aboutCol
            color: "#151313"
            Layout.fillWidth: true
            Layout.preferredHeight: 56

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    //     roundSelectPage.visible = false
                    //     dataEntryPage.visible = true
                }
            }

            Label {
                id: aboutLabel
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                text: qsTr("About")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pointSize: 20
            }

            Image {
                id: aboutImage
                x: 352
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 17
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    ColumnLayout {
        id: column3
        width: parent.width
        anchors.top: column2.bottom
        anchors.topMargin: 10
        spacing: 2

        Rectangle {
            id: signOutCol
            color: "#151313"
            Layout.fillWidth: true
            Layout.preferredHeight: 56

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    signupPage.deleteAllLoginDetails()
                    profilePage.visible = false
                    roundSelectPage.visible = false
                    quickStartPage.visible = false
                    mainPage.visible = true
                }
            }

            Label {
                id: signOutLabel
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                text: qsTr("Sign out")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                font.pointSize: 20
            }

            Image {
                id: signOutImage
                x: 352
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 17
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    Connections {
        target: authHandler
        function onUserRetrieved(username, usergender, userage, userheight, userweight, userhandHabit, userprofilePicture) {
            userImage.source = userprofilePicture
            nameLabel.text = username
            heightLabel.text = userheight
            weightLabel.text = userweight
            handedlabel.text = userhandHabit
        }
    }

    Connections {
        target: device
        function onCallForWeight() {
            device.getWeight(weightLabel.text)
        }
    }
}
