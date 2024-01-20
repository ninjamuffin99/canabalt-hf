package;

import flixel.FlxG;

/**
 * Old AS3 flixel had `FlxG.kb` and `FlxG.ka` for keyboard A and B.
 * This is a bit of a "port" of that convention, without touching FlxG!
 */
class Controls
{
    public static var ka(get, default):Bool = false;
    public static var kb(get, default):Bool = false;

    static function get_ka():Bool
    {
        return FlxG.keys.anyJustPressed(["X", "TAB"]);
    }

    static function get_kb():Bool
    {
        return FlxG.keys.anyJustPressed(["SPACE", "C"]);
    }


}