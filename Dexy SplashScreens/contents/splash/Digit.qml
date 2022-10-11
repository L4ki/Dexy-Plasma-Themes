import QtQuick 2.15

Rectangle
{
	id: root
	property int number
	property alias font: text.font.family
	radius: height *  0.05

	color: "#24273a"

	Text
	{
		id: text
		text: (root.number < 10 ? "0" : "") + root.number
		anchors.fill: parent
		color: "#d1d5e9"
		font.pixelSize: Math.min(height * 0.4, width * 0.4)
		font.family: fixedFont.name
		renderType: Text.QtRendering
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
	}
}
