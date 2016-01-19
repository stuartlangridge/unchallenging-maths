import QtQuick 2.0
import Ubuntu.Components 1.3

Label {
    id: thislabel
    anchors.centerIn: parent
    opacity: 0
    property alias anim: anim
    ParallelAnimation {
        id: anim;
        SequentialAnimation {
            PropertyAnimation {
                target: thislabel
                property: "font.pixelSize";
                from: 0
                to: 80;
                duration: 250
            }
            PropertyAnimation {
                target: thislabel
                property: "font.pixelSize";
                from: 80
                to: 500
                duration: 250
            }
        }
        SequentialAnimation {
            PropertyAnimation {
                target: thislabel
                property: "opacity";
                from: 0
                to: 1
                duration: 20
            }
            PropertyAnimation {
                target: thislabel
                property: "opacity";
                from: 1.0
                to: 0;
                duration: 480
            }
        }
    }
}
