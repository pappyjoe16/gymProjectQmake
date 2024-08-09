import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.LocalStorage 2.0

Rectangle {
    id: backgroundImage
    anchors.fill: parent
    layer.enabled: false
    z: -1
    color: "black"

    property int nextCounterValue: 1

    // Function to get database connection
    function getDatabase() {
        return LocalStorage.openDatabaseSync("MyAppDatabase", "1.0",
                                             "StorageDatabase", 1000000)
    }

    // Function to initialize database table
    function initializeDatabase() {
        var db = getDatabase()
        db.transaction(function (tx) {
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS incrementers(id INTEGER PRIMARY KEY AUTOINCREMENT, count INTEGER, roundText TEXT, trainingText TEXT, breakText TEXT, activityText TEXT)')
        })
    }

    // Function to save data to local storage
    function saveIncrementerModel() {
        var db = getDatabase()
        db.transaction(function (tx) {
            // Delete existing records to avoid duplicates
            tx.executeSql('DELETE FROM incrementers')

            // Loop through the model and save each item
            for (var i = 0; i < incrementerModel.count; i++) {
                var item = incrementerModel.get(i)
                tx.executeSql(
                            'INSERT INTO incrementers (count, roundText, trainingText, breakText, activityText) VALUES (?, ?, ?, ?, ?)',
                            [item.count, item.roundText, item.trainingText, item.breakText, item.activityText])
            }
        })
        console.log("Data saved to local storage")
    }

    // Function to load data from local storage
    function loadIncrementerModel() {
        var db = getDatabase()
        db.transaction(function (tx) {
            var results = tx.executeSql('SELECT * FROM incrementers')
            for (var i = 0; i < results.rows.length; i++) {
                var item = results.rows.item(i)
                incrementerModel.append({
                                            "count": item.count,
                                            "roundText": item.roundText,
                                            "trainingText": item.trainingText,
                                            "breakText": item.breakText,
                                            "activityText": item.activityText
                                        })
                // Update nextCounterValue to continue counting from last point
                backgroundImage.nextCounterValue = Math.max(
                            backgroundImage.nextCounterValue, item.count + 1)
            }
        })
        console.log("Data loaded from local storage")
    }

    // Function to delete a specific item from the model and local storage
    function deleteIncrementerModel(index) {
        var item = incrementerModel.get(index);

        var db = getDatabase();
        db.transaction(function(tx) {
            // Delete the corresponding record from the database
            tx.executeSql('DELETE FROM incrementers WHERE count = ?', [item.count]);
        });

        // Remove the item from the model
        incrementerModel.remove(index);
        console.log("Item deleted from model and local storage");
    }

    Component.onCompleted: {
        initializeDatabase(
                    ) // Initialize the database when the component is created
        loadIncrementerModel() // Load data when the app starts
    }

    function roundFunction(roundBox, trainingBox, breakBox, activityBox) {
        incrementerModel.append({
                                    "count": backgroundImage.nextCounterValue,
                                    "roundText": roundBox,
                                    "trainingText": trainingBox,
                                    "breakText": breakBox,
                                    "activityText": activityBox
                                })
        backgroundImage.nextCounterValue += 1
        saveIncrementerModel() // Save model to local storage after appending
    }

    Image {
        id: backButton
        height: 26
        source: "qrc:/ui/assets/images/backArrow.png"
        anchors.topMargin: 16
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageloader.pageLoader("backToQuickstart")
            }
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: 372
            leftMargin: 14
        }
    }

    Rectangle {
        id: roundButton
        y: 745
        width: 70
        height: 70
        color: "#990000"
        radius: 46
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 21
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageloader.pageLoader("trainingPage")
            }
        }
        Text {
            id: name
            color: "#ffffff"
            text: qsTr("+")
            anchors.fill: parent
            anchors.topMargin: -11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: false
            font.pointSize: 50
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageloader.pageLoader("trainingPage")
                }
            }
        }
    }
    Label {
        id: pageTitleLabel
        height: 33
        color: "#ffffff"
        text: qsTr("Round Type")
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 171
        anchors.rightMargin: 171
        anchors.topMargin: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pointSize: 18
        font.italic: true
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: pageTitleLabel.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 13
        anchors.bottomMargin: 97

        Flickable {
            id: flickable
            Layout.fillHeight: true
            Layout.fillWidth: true
            //anchors.fill: parent
            contentWidth: incrementerRow.width
            contentHeight: incrementerRow.height
            clip: true

            ColumnLayout {
                id: incrementerRow
                spacing: 10
                //width: childrenRect.width
                //height: childrenRect.height
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }
        }
    }
    ListModel {
        id: incrementerModel
    }

    Component {
        id: incrementerDelegate
        Item {

            id: item1
            // width: 350
            // height: 90
            x: 15
            y: 0
            width: 420
            height: 70

            Rectangle {
                id: styledRectangle
                width: backgroundImage.width //380
                height: 70
                radius: 15
                color: "black"
                border.color: "#000000"
                border.width: 2

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    Label {
                        id: headLabel
                        text: model.count
                        color: "white"
                        font.pointSize: 16
                        //horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        Layout.leftMargin: 13
                        //Layout.preferredHeight: 30
                        Layout.fillHeight: true
                        font.italic: false
                    }

                    // Middle Section
                    Rectangle {
                        color: "#000000"
                        radius: 15
                        border.color: "#333333"
                        border.width: 2
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        RowLayout {
                            anchors.fill: parent
                            spacing: 10
                            //nchors.verticalCenter: parent.verticalCenter
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            ColumnLayout {
                                Layout.leftMargin: 34
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Text {
                                    text: "Round"
                                    font.pixelSize: 16
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: "white"
                                    font.bold: true
                                }

                                Text {
                                    id: roundText
                                    text: model.roundText
                                    font.pixelSize: 18
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: "white"
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Text {
                                    text: "Training time"
                                    font.pixelSize: 16
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: "white"
                                    font.bold: true
                                }

                                Text {
                                    id: trainingText
                                    text: model.trainingText
                                    font.pixelSize: 18
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: "white"
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                spacing: 4
                                Text {
                                    text: "Break time"
                                    font.pixelSize: 16
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: "white"
                                    font.bold: true
                                }

                                Text {
                                    id: breakText
                                    text: model.breakText
                                    font.pixelSize: 18
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    color: "white"
                                    font.bold: true
                                }
                            }
                            Image {
                                id: closeImg
                                source: "qrc:/ui/assets/images/close.png"
                                Layout.rightMargin: 11
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        var index = incrementerRepeater.index;
                                        deleteIncrementerModel(index);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Repeater {
        id: incrementerRepeater
        model: incrementerModel
        delegate: incrementerDelegate
        parent: incrementerRow
    }

    Connections {
        target: pageloader
        function onSwitchToQuickstart() {
            roundSelectPage.visible = true
            quickStartPage.visible = true
            roundType.visible = false
        }
        function onSwitchTotrainingPlanPage() {
            trainingPlan.visible = true
            //roundType.visible = false
        }
    }
}
