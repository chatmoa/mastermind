import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
	// objectName for functional testing purposes (autopilot-qt5)
	objectName: "mainView"

	// Note! applicationName needs to match the .desktop filename
	applicationName: "MasterMind"

	/*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
	automaticOrientation: true

	width: units.gu(51)
	height: units.gu(76)


	PageStack {
		id: pageStack

		function init() {
			return ['Darkorange','DarkGreen','DarkBlue','DarkRed','Gold','Purple','Maroon','Deeppink'];
		}
		function playSound(sound) {
			gameSound.source = sound
			gameSound.play()
		}
		function stopSound() {
			gameSound.stop()
		}

		property variant colors: init()
		property int nbcol
		property int nbcolors: 6
		property bool nodoublon: true

		SoundEffect {
			id: gameSound
			source: "shared/sound/artifices.wav"
		}
		Component.onCompleted: push(home)
		Page {
			id: home

			title: i18n.tr("Master Mind")
			visible: false

			Column {
				spacing: units.gu(1)
				anchors {
					margins: units.gu(2)
					fill: parent
				}
				ListItem.Standard {
					text: i18n.tr("Couleur unique")
					control: Switch {
						checked: pageStack.nodoublon
					}
				}
				ListItem.SingleValue {
					text: i18n.tr("Nombre de couleurs possibles")
					value: pageStack.nbcolors
					progression: true
					onClicked: {
						pageStack.push(Qt.resolvedUrl("Nbcouleur.qml"))
					}
				}
				ListItem.Standard {
					text: i18n.tr("Jouer avec 4 pions")
					onClicked: {
						pageStack.nbcol = 4
						pageStack.push(Qt.resolvedUrl("Plateau.qml"))
					}
					progression: true
				}
				ListItem.Standard {
					text: i18n.tr("Jouer avec 6 pions")
					onClicked: {
						pageStack.nbcol = 6
						pageStack.nbcolors = 8
						pageStack.push(Qt.resolvedUrl("Plateau.qml"))
					}
					progression: true
				}
				ListItem.Standard {
					text: i18n.tr("Test")
					onClicked: {
						pageStack.push(Qt.resolvedUrl("test.qml"))
					}
					progression: true
				}
			}
		}
	}
}
