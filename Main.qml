import QtQuick 2.0
import Ubuntu.Components 1.1

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    id: root

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "unchallengingmaths.sil"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(40)
    height: units.gu(75)

    property int num1: 5
    property int num2: 6

    function chosen(val) {
        if (parseInt(val, 10) == root.num1 + root.num2) {
            yes.anim.start()
            root.reinit()
        } else {
            no.anim.start()
        }
    }
    function shuffle(array) {
      var currentIndex = array.length, temporaryValue, randomIndex;

      // While there remain elements to shuffle...
      while (0 !== currentIndex) {

        // Pick a remaining element...
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;

        // And swap it with the current element.
        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
      }

      return array;
    }
    function reinit() {
        root.num1 = Math.round(Math.random() * 10);
        root.num2 = Math.round(Math.random() * 10);
        var inc = Math.round(Math.random() * 4);
        var btns = [b1,b2,b3,b4];
        shuffle(btns);
        for (var i=0; i<=3; i++) {
            btns[i].text = (root.num1 + root.num2 - inc + i).toString();
        }
    }

    Component.onCompleted: {
        root.reinit();
        mainStack.push(pg);
    }

    PageStack {
        id: mainStack
        anchors {
            fill: undefined // unset the default to make the other anchors work
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    Page {
        title: i18n.tr("Hint")
        id: poll
        visible: false

        Rectangle {
            color: Qt.rgba(0,0,0,0)
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: units.gu(2)
            anchors.leftMargin: units.gu(2)
            anchors.bottomMargin: units.gu(2)
            anchors.rightMargin: units.gu(2)

            Label {
                id: pollhead
                anchors.top: parent.top
                anchors.left: parent.left
                width: parent.width
                text: "Complete a poll to get a hint"
                horizontalAlignment: Text.AlignHCenter
            }

            PollFish {
                id: pollfish
                anchors.top: pollhead.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.topMargin: units.gu(2)

                api_key: "1a69b759-d42b-4d70-951b-c7efc0f08411"
                onStatusChanged: {
                    if (status === "surveyClosed") {
                        mainStack.pop();
                    }
                }
            }
        }

    }

    Page {
        title: i18n.tr("Unchallenging Maths")
        id: pg
        visible: false

        Column {
            spacing: units.gu(1)
            anchors {
                margins: units.gu(2)
                fill: parent
            }

            Label {
                id: label
                fontSize: "x-large"
                text: root.num1 + " + " + root.num2 + " = "
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                height: parent.width / 3
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(3)
                Button {
                    id: b1
                    width: parent.parent.width / 3
                    height: parent.parent.width / 3
                    text: ""
                    onClicked: root.chosen(text)
                    font.pixelSize: 50
                }
                Button {
                    id: b2
                    width: parent.parent.width / 3
                    height: parent.parent.width / 3
                    text: ""
                    onClicked: root.chosen(text)
                    font.pixelSize: 50
                }
            }
            Row {
                height: parent.width / 3
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(3)
                Button {
                    id: b3
                    width: parent.parent.width / 3
                    height: parent.parent.width / 3
                    text: ""
                    onClicked: root.chosen(text)
                    font.pixelSize: 50
                }
                Button {
                    id: b4
                    width: parent.parent.width / 3
                    height: parent.parent.width / 3
                    text: ""
                    onClicked: root.chosen(text)
                    font.pixelSize: 50
                }
            }

            Button {
                text: "Hint"
                width: parent.width
                font.pixelSize: 40
                height: 80
                onClicked: {
                    mainStack.push(poll);
                    pollfish.begin();
                }
            }
        }


        GrowLabel {
            id: yes
            text: "correct!"
            color: "#00aa00"
        }
        GrowLabel {
            id: no
            text: "wrong"
            color: "#aa0000"
        }


    }
}

