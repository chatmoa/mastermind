var maxIndex = 6;
var maxColumn = 6;
var maxRow = 11;
var blockSize = 32;
var blockSpace = 10;
//var baseLine = new Array(maxIndex);
var colors = ['transparent', 'yellow', 'blue', 'green', 'pink', 'red', 'orange', 'black', 'brown'];
var component = null;


function startNewGame(h) {
	//Delete baseLine from previous game
	/*for (var i = 0; i < maxIndex; i++) {
		if (baseLine[i] !== null) {
			baseLine[i].destroy();
		}
	}*/

	//Initialize Board
	//baseLine = new Array(maxIndex);
	for (var column = 0; column < maxIndex; column++) {
		//baseLine[column] = null;
		//grille.(createPunaise());
	}

	//Initialize Board
	/*baseLine = new Array(maxIndex);
	for (var column = 0; column < maxIndex; column++) {
		for (var row = 0; row < maxRow; row++) {
			baseLine[column] = null;
			createPunaise(column, row);
		}
	}*/
}

function createPunaise() {
	if (component === null) {
		component = Qt.createComponent("Punaise.qml")
	}

	// Note that if Block.qml was not a local file, component.status would be
	// Loading and we should wait for the component's statusChanged() signal to
	// know when the file is downloaded and ready before calling createObject().
	if (component.status === Component.Ready) {
		var dynamicObject = component.createObject(background);
		if (dynamicObject === null) {
			console.log("error creating block");
			console.log(component.errorString());
			return false;
		}
		dynamicObject.dim = blockSize;
		//if(row === 0) {
			var colIndex = Math.round((Math.random() * (colors.length-1)) + 1);
			console.log("creating block "+  colIndex);
			dynamicObject.mcolor = colors[colIndex];
		/*} else if(row === -1) {
			dynamicObject.mcolor = colors[column];
		} else {
			dynamicObject.mcolor = colors[0];
		}*/

		return dynamicObject;
	} else {
		console.log("error loading block component");
		console.log(component.errorString());
		return null;
	}
}
/*
function createPunaise(column, row) {
	if (component === null)
		component = Qt.createComponent("Punaise.qml");

	// Note that if Block.qml was not a local file, component.status would be
	// Loading and we should wait for the component's statusChanged() signal to
	// know when the file is downloaded and ready before calling createObject().
	if (component.status === Component.Ready) {
		var dynamicObject = component.createObject(background);
		if (dynamicObject === null) {
			console.log("error creating block");
			console.log(component.errorString());
			return false;
		}
		dynamicObject.x = column * (blockSize + 10) + 30;
		dynamicObject.y = (background.height - 110) - (row * (blockSize + 10));
		dynamicObject.dim = blockSize;
		if(row === 0) {
			var colIndex = Math.round((Math.random() * (colors.length-1)) + 1);
			console.log("creating block "+  colIndex);
			dynamicObject.mcolor = colors[colIndex];
		} else if(row === -1) {
			dynamicObject.mcolor = colors[column];
		} else {
			dynamicObject.mcolor = colors[0];
		}

		baseLine[column] = dynamicObject;
	} else {
		console.log("error loading block component");
		console.log(component.errorString());
		return false;
	}
	return true;
}
*/
