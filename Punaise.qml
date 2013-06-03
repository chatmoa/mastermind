import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtMultimedia 5.0
import Ubuntu.Components.Popups 0.1

MouseArea {
	id: dragArea

	property string mcolor
	property int dim
	property bool active: false
	property Item realparent

	drag.target: punaise
	width: dim
	height: dim
	anchors.centerIn: parent

	enabled: true

	function setColor(color) {
		mcolor = color
		if(explosion.explode) {
			explosion.stop()
		}
		pageStack.playSound("shared/sound/open_menu.wav")
		console.log('Animate setColor:'+color)
		animation.running = true
	}

	onClicked: {
		if(false && dragArea.enabled) {
			dragArea.mcolor = 'transparent'
			PopupUtils.open(colorSelector, punaise.parent.parent)
			explosion.start()
		}
	}
	onWheel: {
		if(active) {
			var colorIndex = pageStack.colors.indexOf(mcolor)

			if (wheel.angleDelta.y > 0) {
				if(colorIndex === (pageStack.nbcolors -1)) {
					colorIndex = -1
				}
				parent.setPunaise(pageStack.colors[colorIndex+1])
			} else {
				if(colorIndex < 1) {
					colorIndex = pageStack.nbcolors
				}
				parent.setPunaise(pageStack.colors[colorIndex-1])
			}
		}
	}

	onReleased: {
		if(punaise.Drag.target) {
			var colori = punaise.Drag.target.mcolor
			punaise.Drag.target.setPunaise(punaise.parent.mcolor)
			if(realparent.setPunaise) {
				realparent.setPunaise(colori)
			}
			parent = parent
		}
		//parent = punaise.Drag.target !== null ? punaise.Drag.target : parent
	}
	onPressed: {
		console.log('start drag')
		console.log(punaise.parent.parent)
		console.log(parent)
		realparent = parent
	}

	Rectangle {
		id: punaise
		width: dim
		height: dim
		radius: dim/2
		scale: 1

		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter

		Drag.active: dragArea.drag.active
		Drag.hotSpot.x: dragArea.dim / 2
		Drag.hotSpot.y: dragArea.dim / 2
		//Drag.keys: ["punaise"]

		LinearGradient {
			anchors.fill: parent
			source: parent
			start: Qt.point(dim, 0)
			end: Qt.point(0, dim)
			gradient: Gradient {
				GradientStop { position: 0.0; color: 'white' }
				GradientStop { position: 0.7; color: dragArea.mcolor }
			}
		}
		states: [
			State {
				when: dragArea.drag.active
				ParentChange {
					target: dragArea
					parent: presentoir
				}
				AnchorChanges {
					target: punaise;
					anchors.horizontalCenter: undefined;
					anchors.verticalCenter: undefined
				}
			}
		]
		//		Rectangle {
		//			width: dim/3
		//			height: dim/3
		//			radius: width/2
		//			anchors.verticalCenter: parent.verticalCenter
		//			anchors.horizontalCenter: parent.horizontalCenter
		//			LinearGradient {
		//				anchors.fill: parent
		//				source: parent
		//				start: Qt.point(0, parent.width)
		//				end: Qt.point(parent.height, 0)
		//				gradient: Gradient {
		//					GradientStop { position: 0.0; color: 'white' }
		//					GradientStop { position: 0.7; color:  dragArea.mcolor}
		//				}
		//			}

		//		}
	}
	DropShadow {
		anchors.fill: punaise
		horizontalOffset: dim/-5
		verticalOffset: dim/5
		radius: 6.0
		samples: 16
		color: "#80000000"
		source: punaise
	}
	InnerShadow {
		anchors.fill: punaise
		horizontalOffset: dim/10
		verticalOffset: dim/-10
		radius: 12
		samples: 12
		spread: 0
		color: "#80000000"
		source: punaise
	}

	SequentialAnimation {
		id: animation
		PropertyAnimation {
			target: dragArea
			duration: 200
			properties: "scale"
			from: 1
			to: 0.6
		}
		PropertyAnimation {
			target: dragArea
			duration: 200
			properties: "scale"
			from: 0.6
			to: 1
		}
	}
	Explosion {
		id: explosion
	}
}

