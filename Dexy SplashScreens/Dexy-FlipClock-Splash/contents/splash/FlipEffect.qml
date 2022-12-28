import QtQuick 2.15

/**
 * Provides a flip-panel effect on a given item
 * It is assumed we have the same geometry of that item and anchored on top
 */

// in any sane world we would hide the flipEffect when we're not animating
// however QtQuick tries to be clever and flushes with Effectsource when there's no monitor
// and I relied on that..
// doesn't seem too costly, so meh
// it does look hilarious if you resize though...

Item
{
	id: root
	property Item sourceItem
	property int duration: 1000
	property bool supress: true

	function flip()
	{
		// lazy hack to avoid the first flip that happens on initial bind
		if (supress)
		{
			supress = false;
			return;
		}

		flipAnim.start()
	}

	ShaderEffectSource
	{
		id: oldTop
		sourceItem: root.sourceItem
		sourceRect: Qt.rect(0, 0, root.sourceItem.width, root.sourceItem.height/2)
		live: false
	}

	ShaderEffectSource
	{
		id: oldBottom
		sourceItem: root.sourceItem
		sourceRect: Qt.rect(0, root.sourceItem.height/2, root.sourceItem.width, root.sourceItem.height/2)
		live: false
	}

	ShaderEffectSource
	{
		id: newBottom
		sourceItem: root.sourceItem
		sourceRect: Qt.rect(0, root.sourceItem.height/2, root.sourceItem.width, root.sourceItem.height/2)
		live: false
		textureMirroring: ShaderEffectSource.NoMirroring
	}

	ShaderEffect
	{
		id: effect
		anchors.top: root.top
		anchors.bottom: root.verticalCenter
		anchors.left: root.left
		anchors.right: root.right
		property variant source: oldTop
		z: 10
		transform: Rotation
		{
			id: upperRotation
			origin.x: effect.width/2
			origin.y: effect.height
			axis.x: 1
			axis.y: 0
			axis.z: 0
			angle: 90
		}
	}

	ShaderEffect
	{
		id: effect2
		anchors.top: root.top
		anchors.bottom: root.verticalCenter
		anchors.left: root.left
		anchors.right: root.right
		property variant source: newBottom
		z: 10
		transform: Rotation
		{
			id: lowerRotation
			origin.x: effect.width/2
			origin.y: effect.height
			axis.x: 1
			axis.y: 0
			axis.z: 0
			angle: 90
		}
	}

	ShaderEffect
	{
		property variant source: oldBottom
		anchors.top: root.verticalCenter
		anchors.bottom: root.bottom
		anchors.left: root.left
		anchors.right: root.right
		z:1
	}

	SequentialAnimation
	{
		id: flipAnim

		NumberAnimation
		{
			target: upperRotation
			property: "angle"
			from: 0
			to: -90
			duration: root.duration / 2
		}

		ScriptAction
		{
			script:
			{
				newBottom.scheduleUpdate()
			}
		}

		NumberAnimation
		{
			target: lowerRotation
			property: "angle"
			from: -90
			to: -180
			duration: root.duration / 2
		}

		ScriptAction
		{
			script:
			{
				oldTop.scheduleUpdate();
				oldBottom.scheduleUpdate();
			}
		}
	}

	// horizontal line to make it look like a flippy thing
	Rectangle
	{
		color: "#7580bc"
		height: 2
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		z: 20
	}
}
