package;

import flixel.FlxG;

/**
 * Old AS3 flixel had `FlxG.kb` and `FlxG.ka` for keyboard A and B.
 * This is a bit of a "port" of that convention, without touching FlxG!
 */
class Controls {
	public static var ka(get, default):Bool = false;
	public static var kb(get, default):Bool = false;
	public static var kaP(get, default):Bool = false;
	public static var kbP(get, default):Bool = false;
	public static var kbR(get, default):Bool = false;
	public static var kaR(get, default):Bool = false;

	static function get_ka():Bool {
		var didPress:Bool = FlxG.keys.anyPressed(["X", "TAB"]);

		if (FlxG.gamepads.lastActive != null)
			didPress = didPress || FlxG.gamepads.lastActive.anyPressed(["B"]);

		if (FlxG.touches.list != null)
			didPress = didPress || FlxG.touches.getFirst()?.pressed;

		didPress = didPress || FlxG.mouse.pressed;

		return didPress;
	}

	static function get_kb():Bool {
		var didPress:Bool = FlxG.keys.anyPressed(["SPACE", "C"]);

		if (FlxG.gamepads.lastActive != null)
			didPress = didPress || FlxG.gamepads.lastActive.anyPressed(["A"]);

		return didPress;
	}

	static function get_kaP():Bool {
		var didPress:Bool = FlxG.keys.anyJustPressed(["X", "TAB"]);

		if (FlxG.gamepads.lastActive != null)
			didPress = didPress || FlxG.gamepads.lastActive.anyJustPressed(["B"]);

		if (FlxG.touches.list != null)
			didPress = didPress || FlxG.touches.getFirst()?.justPressed;

		didPress = didPress || FlxG.mouse.justPressed;

		return didPress;
	}

	static function get_kbP():Bool {
		var didPress:Bool = FlxG.keys.anyJustPressed(["SPACE", "C"]);

		if (FlxG.gamepads.lastActive != null)
			didPress = didPress || FlxG.gamepads.lastActive.anyJustPressed(["A"]);

		return didPress;
	}

	static function get_kaR():Bool {
		var didPress:Bool = FlxG.keys.anyJustReleased(["X", "TAB"]);

		if (FlxG.gamepads.lastActive != null)
			didPress = didPress || FlxG.gamepads.lastActive.anyJustReleased(["B"]);

		if (FlxG.touches.list != null)
			didPress = didPress || FlxG.touches.getFirst()?.justReleased;

		didPress = didPress || FlxG.mouse.justReleased;

		return didPress;
	}

	static function get_kbR():Bool {
		var didPress:Bool = FlxG.keys.anyJustReleased(["SPACE", "C"]);

		if (FlxG.gamepads.lastActive != null)
			didPress = didPress || FlxG.gamepads.lastActive.anyJustReleased(["A"]);

		return didPress;
	}
}
