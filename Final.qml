import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
	visible: false

	function init() {
		visible = false
		y = 1000
	}
	function show(text) {
		visible = true
		y = 0
		felice.text = text
	}

	Text {
		id: felice
		anchors.horizontalCenter: parent.horizontalCenter
		text: "Bravo !"
		font.pointSize: units.gu(10)
		color: "#d5e9f5"
		style: Text.Outline
		styleColor: "lightgray"
	}
	Behavior on y { SpringAnimation { spring: 2; damping: 0.2} }

	DropShadow {
		anchors.fill: felice
		horizontalOffset: -10
		verticalOffset: 10
		radius: 6.0
		samples: 16
		color: "#80000000"
		source: felice
	}
	InnerShadow {
		anchors.fill: felice
		horizontalOffset: 2
		verticalOffset: -2
		radius: 6.0
		samples: 16
		color: "#80000000"
		source: felice
	}
}
