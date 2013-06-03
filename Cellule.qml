import QtQuick 2.0
import QtGraphicalEffects 1.0
import Ubuntu.Components.Popups 0.1

DropArea {
	id: daCellule
	property int dim
	property string mcolor

	width: dim
	height: dim
	enabled: true

	onEnabledChanged: {
		setPunaise(mcolor);
	}

	function setPunaise(mcolor) {
		console.log("Cellule - setPunaise:" + mcolor);
		daCellule.mcolor = mcolor;
		if(mcolor) {
			inPunaise.visible = true;
			inPunaise.setColor(mcolor);
		} else {
			inPunaise.visible = false;
			inPunaise.setColor('transparent');
		}

//		God.createPunaise({
//			mcolor:daCellule.mcolor,
//			rotation: 30,
//			z: 500,
//			dim: daCellule.dim,
//			enabled: daCellule.enabled
//		});
	}

	Rectangle {
		anchors.centerIn: parent
		id: cellule
		width: dim * 0.35
		height: dim * 0.35
		radius: dim/2
		rotation: 45

//		border {
//			width: width/16
//			color: "#80000000"
//		}


		gradient: Gradient { // This sets a vertical gradient fill
			GradientStop { position: 0; color: 'black' }
			GradientStop { position: 1; color: 'white' }
		}
		MouseArea {
			anchors.fill: parent
			onClicked: {
				if(daCellule.enabled) {
					PopupUtils.open(colorSelector, daCellule)
				}
			}
		}
		states: [
			State {
				when: daCellule.containsDrag
				PropertyChanges {
					target: cellule
					scale: 1.5
				}
			}
		]
	}

	Punaise {
		id: inPunaise
		mcolor: daCellule.mcolor

		dim: daCellule.dim
		enabled: daCellule.enabled
		visible: !daCellule.enabled
		active: true
	}

	onEntered: {
		//console.log("onEntered");
		//console.log(drag.source);
	}
	onDropped: {
		//console.log ("onDropped");
	}
	onExited: {
		//console.log ("onExited");
	}
}
