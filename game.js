var results = [];
var nbline = 0;

function getColorOf(index) {
	return results[nbline-1][index];
}
function addResult(result) {

	results[nbline++] = result;

	var str = "";
	for( var i=0; i<4; i++) {
		str += results[nbline-1][i].color + ' - ';
	}
	console.log(str);
}

/*
var component;
var sprite;
var config;

function createPunaise(c) {
	config = c;
	component = Qt.createComponent("Punaise.qml");
	if (component.status === Component.Ready) {
		finishCreation();
	} else {
		component.statusChanged.connect(finishCreation);
	}
}

function finishCreation() {
	if (component.status === Component.Ready) {
		sprite = component.createObject(daCellule,config);
		if (sprite === null) {
			// Error Handling
			console.log("Error creating object");
		}
	} else if (component.status === Component.Error) {
		// Error Handling
		console.log("Error loading component:", component.errorString());
	}
}
*/
