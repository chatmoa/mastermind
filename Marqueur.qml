import QtQuick 2.0
import QtGraphicalEffects 1.0
import Ubuntu.Components 0.1

Item {

	visible: true
	height: lines.width/pageStack.nbcolors

	Rectangle {
		id: fond
		anchors.fill: parent
		radius: parent.height/3
		opacity: 0.2
		gradient: Gradient {
			GradientStop { position: 0.0; color: "white" }
			GradientStop { position: 0.9; color: "whitesmoke" }
			GradientStop { position: 1.0; color: "gray" }
		}
	}
	Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
}
