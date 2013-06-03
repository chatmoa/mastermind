import QtQuick 2.0
import QtQuick.Particles 2.0
import QtGraphicalEffects 1.0
import QtMultimedia 5.0

import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import Ubuntu.Components.Popups 0.1
import "game.js" as Game

Page {
	SystemPalette { id: activePalette }
	id: root
	property bool trouvee: false

	anchors {
		fill: parent
	}
	/**
	 * Pop up de selection de couleur
	 **/
	Component {
		id: colorSelector
		Popover {
			id: popover
			Column {
				height: palette.cellWidth
				anchors {
					top: parent.top
					left: parent.left
					right: parent.right
				}
				Rectangle {
					color: "whitesmoke"
					width: parent.width
					height: parent.height
					GridView {
						id: palette

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
								scale: 0.9
								MouseArea {
									anchors.fill: parent
									onClicked: {
										caller.setPunaise(mycolor)
										PopupUtils.close(popover)
									}
								}
							}
						}
						model: ListModel {}
					}
				}
			}
			Component.onCompleted: {
				for( var i=0; i<pageStack.nbcolors; i++) {
					palette.model.append({mycolor: pageStack.colors[i]});
				}
			}
		}
	}
	/**
	 * Plateu du jeu
	 **/
	Item {
		anchors.fill: parent
		Image {
			id: background
			anchors.fill: parent
			source: "shared/pics/background.jpg"
			fillMode: Image.PreserveAspectCrop
		}
	}

	/**
	 * Createur d'une ligne de jeu
	 **/
	Component {
		id: punaiseLineDelegate
		Row {
			id: line
			signal soluce()
			property bool abandon: myabandon


			spacing: units.gu(1)
			anchors {
				left: parent.left
				right: parent.right
			}
			onSoluce: {
				punaiseLine.enabled = false
				if(okbtn) {
					okbtn.destroy()
					if(! root.trouvee) {
						for( var i=0; i<pageStack.nbcol; i++) {
							var x = i*(punaiseLine.cellWidth)+10
							var y = 10
							punaiseLine.itemAt(x ,y).setPunaise(lines.solution[i])
						}
					}
				}
				if(duplikbtn) {
					duplikbtn.destroy()
				}

				console.log(" punaiseLine.soluce()")
				lines.soluce.disconnect(soluce)
			}

			GridView {
				id: punaiseLine
				width: parent.width*2/3
				cellWidth: (width/pageStack.nbcol)
				cellHeight: cellWidth
				height: cellWidth
				enabled: true

				model: ListModel {}
				delegate: Cellule {
					dim: punaiseLine.cellWidth - units.gu(2)
					enabled: !line.myabandon
				}
				focus: true
				displaced: Transition {
				    NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
				}
			}
			MouseArea {
				id: duplikbtn
				width: punaiseLine.cellWidth/2
				height: punaiseLine.cellWidth/2
				visible: Game.nbline > 0
				anchors.verticalCenter: line.verticalCenter
				Rectangle {
					anchors.fill: parent
					color: 'transparent'
					Image {
						id: duplikimg
						anchors.fill: parent
						fillMode: Image.PreserveAspectFit
						source: "shared/pics/duplik.svg"
					}
					DropShadow {
					    anchors.fill: duplikimg
					    horizontalOffset: units.gu(-1)
					    verticalOffset: units.gu(1)
					    radius: 8.0
					    samples: 16
					    color: "#80000000"
					    source: duplikimg
					}

				}
				onClicked: {
					for( var i=0; i<pageStack.nbcol; i++) {
						var x = i*(punaiseLine.cellWidth)+10
						var y = 10
						punaiseLine.itemAt(x ,y).setPunaise(Game.getColorOf(i).color)
					}
					duplikbtn.destroy()
				}
			}
			MouseArea {
				id: okbtn
				width: punaiseLine.cellWidth/2
				height: punaiseLine.cellWidth/2
				anchors.verticalCenter: line.verticalCenter
				Rectangle {
					anchors.fill: parent
					color: 'transparent'
					Image {
						id: okimg
						anchors.fill: parent
						fillMode: Image.PreserveAspectFit
						source: "shared/pics/ok.svg"
					}
					DropShadow {
					    anchors.fill: okimg
					    horizontalOffset: units.gu(-1)
					    verticalOffset: units.gu(1)
					    radius: 8.0
					    samples: 16
					    color: "#80000000"
					    source: okimg
					}
				}
				onClicked: {
					punaiseLine.enabled = false
					correctLine.visible = true
					okbtn.destroy()
					if(duplikbtn)
						duplikbtn.destroy()

					var result = [], toutbon = true
					for( var i=0; i<pageStack.nbcol; i++) {
						var x = i*(punaiseLine.cellWidth)+10
						var y = 10
						result[i] = {color: punaiseLine.itemAt(x ,y).mcolor}
						if(result[i].color === lines.solution[i]) {
							result[i].propos = true
							correctLine.model.append({mycolor: 'black'})
						} else {
							result[i].propos = false
							toutbon = false
						}
					}

					Game.addResult(result)

					if(! toutbon) {
						for( i=0; i<pageStack.nbcol; i++) {
							if(result[i].propos !== true) {
								for( var j=0; j<pageStack.nbcol; j++) {
									if(result[j].soluce !== true && result[i].color === lines.solution[j]) {
										correctLine.model.append({mycolor: 'lightgray'})
										result[j].soluce = true
										break
									}
								}
							}
						}
						lines.model.insert(0, {})
//						presentoir.y = lines.height - presentoir.height - ((Game.nbline + 1) * (line.height + units.gu(1)))

					} else {
						root.trouvee = true
						lines.soluce()
					}
				}
			}
			GridView {
				id: correctLine
				visible: false
				width: parent.width*2/3
				cellWidth: (width/pageStack.nbcol)/2
				cellHeight: cellWidth
				height: cellWidth+units.gu(1)
				enabled: false
				focus: true
				anchors.verticalCenter: parent.verticalCenter

				model:  ListModel {}
				delegate:  Item {
					height: parent.height
					width: height
					Punaise {
						mcolor: mycolor
						scale: 1
						dim: correctLine.cellWidth-units.gu(2)
					}
				}
				add: Transition {
					id: addTrans
					SequentialAnimation {
						NumberAnimation {
							property: "x"; to: addTrans.ViewTransition.item.y + 50
							easing.type: Easing.OutQuad
						}
						NumberAnimation { property: "x"; duration: 1800; easing.type: Easing.OutBounce }
					}
				}
//				onYChanged: {
//					presentoir.y = lines.height - presentoir.height - ((Game.nbline + 1) * (line.height + units.gu(1)))
//				}
			}
			Component.onCompleted: {
				console.log("abandon:"+abandon+' - '+myabandon)
				for( var i=0; i<pageStack.nbcol; i++) {
					punaiseLine.model.append({mycolor: 'transparent'});
//					punaiseLine.model.append({mycolor: 'white'});
				}
				if(abandon === true) {
					okbtn.destroy()
					duplikbtn.destroy()
				}

				lines.soluce.connect(soluce)
				//presentoir.y = lines.height - presentoir.height - ((Game.nbline + 1) * (line.height + units.gu(1)))
			}
		}

	}
	ListView {
		id: lines
		property bool soluced: false

		signal soluce()
		onSoluce: {
			console.log("Lines.soluce() "+soluced )
			finaltext.show(root.trouvee ? 'Bravo !' : 'Facile ...')
			if(soluced === false) {
				//lines.model.append({myabandon: true})
				soluced = true
				if(!trouvee) {
					pageStack.playSound("shared/sound/drow_sound1.wav")
				} else {
					pageStack.playSound("shared/sound/artifices.wav")
				}

				//presentoir.y = lines.height - ((lines.width*2/3)/pageStack.nbcol) * 2
				presentoir.visible = false
			}
		}

		function initLine() {
			lines.model.clear()
			soluced = false
			root.trouvee = false
			finaltext.init()
		}
		function initSolution() {
			var soluce = [], newColor
			for( var i=0; i<pageStack.nbcol; i++) {
				if(pageStack.nodoublon) {
					var continu = true
					while(continu) {
						newColor = pageStack.colors[Math.floor((Math.random()*pageStack.nbcolors))]
						continu = false
						for(var j=0;j<soluce.length;j++) {
							if(soluce[j] === newColor) {
								continu = true
								break
							}
						}
						if(continu === false) {
							soluce[i] = newColor
						}
					}
				} else {
					newColor = pageStack.colors[Math.floor((Math.random()*pageStack.nbcolors))]
					soluce[i] = newColor
				}
			}
			console.log(soluce)
			Game.nbline = 0
			Game.results = []
			presentoir.visible = true
			return soluce
		}
		property variant solution: initSolution()
		anchors {
			margins: units.gu(2)
			top: presentoir.bottom
			bottom: parent.bottom
			horizontalCenter: parent.horizontalCenter
		}
		width: height/1.5 < (parent.width - (2*units.gu(2))) ? height/1.5 : (parent.width - (2*units.gu(2)))
		spacing: units.gu(1)
		//verticalLayoutDirection: ListView.BottomToTop

		model: ListModel {}
		delegate: punaiseLineDelegate

//		add: Transition {
//			id: dispTrans
//			SequentialAnimation {
//				PauseAnimation {
//					duration: (dispTrans.ViewTransition.index -
//						   dispTrans.ViewTransition.targetIndexes[0]) * 100
//				}
//				NumberAnimation {
//					property: "y"; to: dispTrans.ViewTransition.item.y + 50
//					easing.type: Easing.OutQuad
//				}
//				NumberAnimation { property: "y"; duration: 500; easing.type: Easing.OutBounce }
//			}
//		}
		add: Transition {
		    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
		    NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
		}

		displaced: Transition {
		    NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
		}
		rebound: Transition {
			NumberAnimation {
				properties: "x,y"
				duration: 1000
				easing.type: Easing.OutBounce
			}
		}
	}
	Presentoir {
		id: presentoir
		anchors {
			top: parent.top
			left: lines.left
			right: lines.right
		}
		visible: false
	}
	Final {
		id: finaltext
		anchors {
			left: lines.left
			right: lines.right
		}
		y: parent.height
	}

	Component.onCompleted: {
		lines.model.append({myabandon: false})
	}

	ParticleSystem {
	    id: particlesItem

	    y: parent.height
	    x:(parent.width / 2)
	    running: root.trouvee || !empty

	    ImageParticle {
		source: "shared/pics/snow.png"
		rotationVariation: 180
		color:"white"
		colorVariation: 0
		opacity: 1
	    }

	    Emitter {
		width: 10
		height: 8
		emitRate: 500
		lifeSpan: 3500
		size: 5
		sizeVariation: 16
		velocity: PointDirection{ y: -(parent.height/3); x:0; xVariation: 100; yVariation: 150 }
		endSize: 8
		enabled: root.trouvee
	    }
	    Gravity {
		    magnitude: 100
	    }
	    Turbulence {
		width: parent.width
		height: parent.height
		strength: 500
	    }
	}
	tools: ToolbarActions {
		id: toolsbar
		Action {
			text: "Nouveau"
			iconSource: Qt.resolvedUrl("shared/pics/nouveau_icon.png")
			onTriggered: {
				lines.solution = lines.initSolution()
				lines.initLine()
				lines.model.append({})
			}
		}
		Action {
			text: "Solution"
			iconSource: Qt.resolvedUrl("shared/pics/solution_icon.png")
			onTriggered: {
				lines.soluce()
			}
		}
	}
}
