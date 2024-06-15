import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: rectangle1
    anchors.fill: parent

    TabBar {
        id: tabBar
        height: 57
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        background: Rectangle {
            color: "#a3a375"
        }

        TabButton {
            text: qsTr("Train")
            icon.source: "qrc:/ui/assets/images/boxing.png"
            display: AbstractButton.TextUnderIcon
            onClicked: stackLayout.currentIndex = 0
        }
        TabButton {
            text: qsTr("Data")
            icon.source: "qrc:/ui/assets/images/dataOn.png"
            display: AbstractButton.TextUnderIcon
            onClicked: stackLayout.currentIndex = 1
        }
        TabButton {
            text: qsTr("Profile")
            icon.source: "qrc:/ui/assets/images/mineOn.png"
            display: AbstractButton.TextUnderIcon
            onClicked: {

                stackLayout.currentIndex = 2
            }
        }
    }

    StackLayout {
        id: stackLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: tabBar.top

        Loader {
            source: "QuickStartPage.qml"
            visible: stackLayout.currentIndex === 0
            onLoaded: //item.activeChanged.connect(function () {
            {
                tabBar.currentIndex = 0
            }
        }
        Loader {
            source: "DataPage.qml"
            visible: stackLayout.currentIndex === 1
            onLoaded: //item.activeChanged.connect(function () {
            {
                tabBar.currentIndex = 1
            }
        }
        Loader {
            source: "ProfilePage.qml"
            visible: stackLayout.currentIndex === 2
            onLoaded: //item.activeChanged.connect(function () {
            {
                tabBar.currentIndex = 2
                //authHandler.retriveProfile()
            }
        }
    }
}
