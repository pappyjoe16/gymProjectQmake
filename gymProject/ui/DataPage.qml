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
        text: "Hello !!! Welcome to Data Page. \n   I am still work in progress" // Display the BLE name
        anchors.centerIn: parent
        anchors.left: parent.left
        leftPadding: 10
        font.pixelSize: 20
        color: "black"
    }
}
