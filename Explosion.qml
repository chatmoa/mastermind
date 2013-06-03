import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Particles 2.0

Item {
	anchors.fill: parent
	id: root
	property bool explode: false

	function start() {
		root.explode = true
	}
	function stop() {
		root.explode = false
	}

	ParticleSystem {
		anchors.centerIn: parent
		running: root.explode || !empty
		ImageParticle {
			source: "shared/pics/particle.png"
			rotationVariation: 180
			color:"white"
			colorVariation: 1
			opacity: 0.9
		}
		Emitter {
			width: parent.width
			height: parent.height
			lifeSpan: 1500
			velocity: PointDirection{ xVariation: 30; yVariation: 30 }
			enabled: root.explode
			size: 32
			sizeVariation: 16
			emitRate: 100
		}
	}
}

