import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.0

Rectangle {
    id: backgroundImage
    width: 410
    height: 740
    anchors.fill: parent
    anchors.rightMargin: 0
    anchors.bottomMargin: 0
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
    anchors.leftMargin: 0
    anchors.topMargin: 0
    layer.enabled: false
    opacity: 1
    z: -1

    Label {
        id: pageTitleLabel
        height: 37
        color: "#ffffff"
        text: qsTr("My Profile")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 98
        anchors.rightMargin: 98
        anchors.topMargin: 12
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pointSize: 18
        font.italic: true
    }

    Column {
        id: column1
        height: 130
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageTitleLabel.bottom
        //anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 10
        spacing: 15

        Rectangle {
            id: profileSummary
            anchors.fill: parent
            anchors.topMargin: 0
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

            MouseArea {}

            Image {
                id: image
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8
                anchors.rightMargin: 279
                anchors.topMargin: 5
                anchors.bottomMargin: 9
                source: "qrc:/ui/assets/images/user.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {}
            }
            Label {
                id: label
                height: 36
                color: "#ffffff"
                text: qsTr("Joseph Akinboyede")
                anchors.left: image.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 12
                anchors.rightMargin: 8
                anchors.topMargin: 14
                font.pointSize: 20

                MouseArea {}
            }

            Label {
                id: label1
                y: 92
                width: 62
                height: 24
                color: "#ffffff"
                text: qsTr("200cm")
                anchors.left: image.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 9
                anchors.bottomMargin: 14
                font.italic: false
                font.pointSize: 17

                MouseArea {}
            }

            Label {
                id: label2
                y: 93
                width: 62
                height: 24
                color: "#ffffff"
                text: qsTr("150kg")
                anchors.left: label1.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 12
                anchors.bottomMargin: 13
                font.pointSize: 17

                MouseArea {}
            }

            Label {
                id: label3
                y: 94
                height: 24
                color: "#ffffff"
                text: qsTr("Right handed")
                anchors.left: label2.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.bottomMargin: 12
                font.pointSize: 17

                MouseArea {}
            }

            Image {
                id: image1
                x: 352
                y: -1
                width: 39
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 19
                anchors.topMargin: 51
                anchors.bottomMargin: 42
                source: "qrc:/ui/assets/images/next.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {}
            }
        }

        Column {
            id: column2
            height: 280
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: profileSummary.bottom
            //anchors.fill: parent
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 26
            spacing: 2

            Rectangle {
                id: reminderCol
                color: "#151313"
                height: parent.height / 5
                width: parent.width

                MouseArea {}

                Label {
                    id: labelReminder
                    x: 13
                    width: 198
                    color: "#ffffff"
                    text: qsTr("Start Reminder")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 28
                    anchors.topMargin: 8
                    anchors.bottomMargin: 12
                    font.pointSize: 20

                    MouseArea {}
                }

                Image {
                    id: image2
                    x: 352
                    width: 39
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 19
                    anchors.topMargin: 11
                    anchors.bottomMargin: 9
                    source: "qrc:/ui/assets/images/next.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {}
                }
            }
            Rectangle {
                id: dataSyncCol
                color: "#151313"
                height: parent.height / 5
                width: parent.width

                MouseArea {}

                Label {
                    id: dataSyncLabel
                    x: 13
                    width: 259
                    color: "#ffffff"
                    text: qsTr("Data synchronization")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 28
                    anchors.topMargin: 8
                    anchors.bottomMargin: 12
                    font.pointSize: 20

                    MouseArea {}
                }

                Image {
                    id: dataSyncImage
                    x: 352
                    width: 39
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 19
                    anchors.topMargin: 11
                    anchors.bottomMargin: 9
                    source: "qrc:/ui/assets/images/next.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {}
                }
            }
            Rectangle {
                id: feedbackCol
                color: "#151313"
                height: parent.height / 5
                width: parent.width

                MouseArea {}

                Label {
                    id: feedbackLabel
                    x: 13
                    width: 259
                    color: "#ffffff"
                    text: qsTr("Feedback")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 28
                    anchors.topMargin: 8
                    anchors.bottomMargin: 12
                    font.pointSize: 20

                    MouseArea {}
                }

                Image {
                    id: feedbackImage
                    x: 352
                    width: 39
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 19
                    anchors.topMargin: 11
                    anchors.bottomMargin: 9
                    source: "qrc:/ui/assets/images/next.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {}
                }
            }
            Rectangle {
                id: helpCol
                color: "#151313"
                height: parent.height / 5
                width: parent.width

                MouseArea {}

                Label {
                    id: helpLabel
                    x: 13
                    width: 259
                    color: "#ffffff"
                    text: qsTr("Help")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 28
                    anchors.topMargin: 8
                    anchors.bottomMargin: 12
                    font.pointSize: 20

                    MouseArea {}
                }

                Image {
                    id: helpImage
                    x: 352
                    width: 39
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 19
                    anchors.topMargin: 11
                    anchors.bottomMargin: 9
                    source: "qrc:/ui/assets/images/next.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {}
                }
            }
            Rectangle {
                id: aboutCol
                color: "#151313"
                height: parent.height / 5
                width: parent.width

                Label {
                    id: aboutLabel
                    x: 13
                    width: 259
                    color: "#ffffff"
                    text: qsTr("About")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 28
                    anchors.topMargin: 8
                    anchors.bottomMargin: 12
                    font.pointSize: 20

                    MouseArea {}
                }

                Image {
                    id: aboutImage
                    x: 352
                    width: 39
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 19
                    anchors.topMargin: 11
                    anchors.bottomMargin: 9
                    source: "qrc:/ui/assets/images/next.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {}
                }
            }
        }
        Column {
            id: column3
            height: 280
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: column2.bottom
            //anchors.fill: parent
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 24
            spacing: 2

            Rectangle {
                id: signOutCol
                color: "#151313"
                height: parent.height / 5
                width: parent.width

                MouseArea {}

                Label {
                    id: signOutLabel
                    x: 13
                    width: 259
                    color: "#ffffff"
                    text: qsTr("Sign out")
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 28
                    anchors.topMargin: 8
                    anchors.bottomMargin: 12
                    font.pointSize: 20

                    MouseArea {}
                }

                Image {
                    id: signOutImage
                    x: 352
                    width: 39
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 19
                    anchors.topMargin: 11
                    anchors.bottomMargin: 9
                    source: "qrc:/ui/assets/images/next.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {}
                }
            }
        }
    }
}
