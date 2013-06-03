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

		gradient: Gradient {
			GradientStop { position: 0; color: "LemonChiffon" }
			GradientStop { position: 0.4; color: "Moccasin" }
		}
	}
	DropShadow {
		anchors.fill: fond
		horizontalOffset: parent.height/-15
		verticalOffset: parent.height/15
		radius: 12
		samples: 24
		color: "#80000000"
		source: fond
	}
	InnerShadow {
		anchors.fill: fond
		horizontalOffset: parent.height/20
		verticalOffset: parent.height/-20
		radius: 12
		samples: 24
		spread: 0
		color: "#80000000"
		source: fond
	}
	Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }

	GridView {
		id: palette
		anchors {
			margins: units.gu(1)
			fill: parent
		}

		width: parent.width
		height: parent.height
		cellWidth: parent.width / pageStack.nbcolors
		cellHeight: cellWidth
		x: units.gu(1)
		y: units.gu(1)

		delegate: Item {
			height: palette.cellWidth - units.gu(2)
			width: height
			Punaise {
				mcolor: mycolor
				dim: palette.cellWidth - units.gu(2)
				scale: 1
			}
		}
		model: ListModel {}
		rebound: Transition {
			NumberAnimation {
				properties: "x,y"
				duration: 1000
				easing.type: Easing.OutBounce
			}
		}
	}
	Component.onCompleted: {
		for( var i=0; i<pageStack.nbcolors; i++) {
			palette.model.append({mycolor: pageStack.colors[i]});
		}
	}
}
