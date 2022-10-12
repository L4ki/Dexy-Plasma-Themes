import QtQuick 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

Image {
    id: root
    source: "images/background.png"
    fillMode: Image.PreserveAspectCrop

	property int stage

	onStageChanged:
	{
		if (stage == 1)
		{
			introAnimation.running = true
		}
	}

	width: 1920
	height: 1200

	FontLoader {
		id: fixedFont
		source: "BebasNeue-Regular.ttf"
	}

	PlasmaCore.DataSource
	{
		id: dataSource
		engine: "time"
		connectedSources: "Local"
		interval: 60000
		intervalAlignment: PlasmaCore.Types.AlignToMinute
		onDataChanged:
		{
			updateTime()
		}
	}

	function updateTime() {
		root.hour = dataSource.data["Local"]["DateTime"].getHours()
		root.min = dataSource.data["Local"]["DateTime"].getMinutes()
	}

	property int hour
	property int min

	// helper for testing animation
	//Timer
	//{
		//running: true
		//interval: 4000
		//repeat: true
		//onTriggered: root.hour++
	//}

	Digit
	{
		id: hours
		y: root.height
		height: root.height * 0.2
		width: Math.min(parent.width * 0.45, height)
		anchors.right: parent.horizontalCenter
		anchors.rightMargin: parent.width * 0.01
		font: fixedFont.name
		//anchors.verticalCenter: root.verticalCenter
		number: root.hour
		onNumberChanged: flipEffectHours.flip()
	}

	FlipEffect
	{
		id: flipEffectHours
		sourceItem: hours
		anchors.fill: hours
	}

	Digit
	{
		id: min
		y: root.height
		height: root.height * 0.2
		width: Math.min(parent.width * 0.45, height)
		anchors.left: parent.horizontalCenter
		anchors.leftMargin: parent.width * 0.01
		font: fixedFont.name
		//anchors.verticalCenter: root.verticalCenter
		number: root.min
		onNumberChanged: flipEffectMin.flip()
	}

	FlipEffect {
		id: flipEffectMin
		sourceItem: min
		anchors.fill: min
	}

	Rectangle
	{
		radius: 3
		color: "#d1d5e9"
		height: 6
		width: height*40
		anchors
		{
			bottom: parent.bottom
			bottomMargin:200
			horizontalCenter: parent.horizontalCenter
		}

		Rectangle
		{
			radius: 3
			color: "#7580bc"
			width: (parent.width / 6) * (stage - 0.00)
			anchors
			{
				left: parent.left
				top: parent.top
				bottom: parent.bottom
			}

			Behavior on width
			{
				PropertyAnimation
				{
					duration: 250
					easing.type: Easing.InOutQuad
				}
			}
		}
	}

	SequentialAnimation
	{
		id: introAnimation
		running: false

		ParallelAnimation
		{
			PropertyAnimation
			{
				property: "y"
				target: hours
				to: (root.height / 2) - (hours.height / 2)
				duration: 1500
				easing.type: Easing.InOutBack
				easing.overshoot: 1.0
			}

			PropertyAnimation
			{
				property: "y"
				target: min
				to: (root.height / 2) - (min.height / 2)
				duration: 1500
				easing.type: Easing.InOutBack
				easing.overshoot: 1.0
			}
		}
	}
}
