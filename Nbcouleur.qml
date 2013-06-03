import QtQuick 2.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components 0.1

Page {
	id: root
	title: i18n.tr("Master Mind")

	Column {
		spacing: units.gu(1)
		anchors {
			margins: units.gu(2)
			fill: parent
		}
		ListItem.Header {
			text: i18n.tr("Nombre de couleurs possibles")
		}
		Repeater {
			model: 5
			ListItem.Standard {
				text: i18n.tr(index+4)
				selected: pageStack.nbcolors === (index+4)
				progression: true
				onClicked: {
					pageStack.nbcolors = index+4
					pageStack.push(home)
				}
			}
		}
	}
}
