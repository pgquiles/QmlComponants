import QtQuick 2.0

Item {

    id: sliderContainer

    anchors.fill: parent

    // Configuration

    property int positions : 3;
    property int currentPosition : 0;
    property int animationDuration : 500

    readonly property int dragMax : ma.drag.maximumX
    readonly property int dragMin : ma.drag.minimumX

    // Override the default component

    property alias visual : slider.sourceComponent

    // Events

    signal clicked();
    signal pressed();
    signal pressAndHold();
    signal released();
    signal moved(int move);

    Loader {

        id: slider

        // This is the default componant, you can overide it by setting a componant to sliderContainter.control

        sourceComponent: Rectangle{

            color: "#22ffffff"
            border.color: "#09c"
            border.width: 3
            radius: 6
        }

        // Control position - don't changed thoses properties if you set the sliderContainer.control

        x: (sliderContainer.width / sliderContainer.positions) * sliderContainer.currentPosition;
        y: -5;
        width: parent.width / positions;
        height: parent.height + 10       
        smooth: true

        // Animation when position changed

        Behavior on x{

            PropertyAnimation{properties: "x"; easing.type: Easing.InOutQuad; duration: sliderContainer.animationDuration}
        }

        onXChanged: {

            if (ma.userMove){

                var move = slider.x - ma.initialX
                if ( move !== 0) sliderContainer.moved(move);
            }
        }

        // Event handling

        MouseArea {

            id:ma
            anchors.fill: parent
            drag.target: parent;
            drag.axis: Drag.XAxis
            drag.minimumX: 2;
            drag.maximumX: sliderContainer.width - slider.width - 2

            property bool hold : false;
            property int initialX : -1;
            property bool userMove : false;

            onPressed : {

                sliderContainer.pressed();

                initialX = slider.x;
                mouse.accepted = true;
                userMove = true;
            }

            onPressAndHold: {

                sliderContainer.pressAndHold();
                hold = true;
            }

            onClicked: {

                sliderContainer.clicked();
            }

            onReleased: {

                sliderContainer.released();

                userMove = false;

                if (hold){

                    hold = false;

                    var cP = sliderContainer.currentPosition;
                    sliderContainer.currentPosition = -1;
                    sliderContainer.currentPosition = cP;
                }

                else{

                    sliderContainer.currentPosition = -1;
                    sliderContainer.currentPosition = Math.floor( (slider.x  / ((sliderContainer.width / sliderContainer.positions) /2) ) / 2 + 0.5);
                }
            }
        }
    }
}
