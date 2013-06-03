import QtQuick 2.0
import QtMultimedia 5.0
import Ubuntu.Components 0.1

Item {
	anchors {
		fill: parent
		margins: units.gu(1)
	}
	Camera {
		id: camera

		imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

		exposure {
			exposureCompensation: -1.0
			exposureMode: Camera.ExposurePortrait
		}

		flash.mode: Camera.FlashRedEyeReduction

		imageCapture {
			onImageCaptured: {
				photoPreview.source = preview  // Show the preview in an Image
			}
		}
	}

	VideoOutput {
		source: camera
		anchors.fill: parent
		focus : visible // to receive focus and capture key events when visible
	}

	Image {
		id: photoPreview
	}
	Button {
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
		}
		text: "Photo"
		onClicked: camera.imageCapture.capture();
	}
}
/*
	Rectangle {
		id: rootTarget
		width: 800
		height: 800

		DropArea {
			id: dragTarget1

			width: 200; height: 200
			y: 100; x: 100

			Rectangle {
				id: target
				anchors.fill: parent
				color: "lightgreen"
			}
			states: [
				State {
					when: dragTarget1.containsDrag
					PropertyChanges {
						target: target
						color: "green"
					}
				}
			]
		}

		DropArea {
			id: dragTarget2
			width: 200; height: 200
			y: 400; x: 100

			Rectangle {
				id: target2
				anchors.fill: parent
				color: "lightgreen"
			}
			states: [
				State {
					when: dragTarget2.containsDrag
					PropertyChanges {
						target: target2
						color: "green"
					}
				}
			]
		}

		Rectangle {
			id: debut
			width: 120; height: 120
			x: 600; y: 600
			color: "red"

			MouseArea {
				id: maDrag
				drag.target: carre
				width: 100; height: 100
				anchors.centerIn: parent

				onReleased: {
					console.log('onReleased')
					parent = carre.Drag.target !== null ? carre.Drag.target : debut
				}

				Rectangle {
					id: carre
					color: "blue"
					width: 100; height: 100
					//x: 600; y: 600
//					anchors.fill: parent
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter

					Drag.active: maDrag.drag.active
					Drag.source: maDrag
					Drag.hotSpot.x: width/2
					Drag.hotSpot.y: height/2

					states: [
						State {
							when: maDrag.drag.active
							PropertyChanges {
								target: carre
								opacity: 0.5
							}
							ParentChange {
								target: carre
								parent: debut
							}

							AnchorChanges {
								target: carre;
								anchors.horizontalCenter: undefined;
								anchors.verticalCenter: undefined
							}
						}
					]
				}
			}
		}
	}
	*/
