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
    public static var kaP(get, default):Bool = false;
    public static var kbP(get, default):Bool = false;
    public static var kbR(get, default):Bool = false;
    public static var kaR(get, default):Bool = false;

    static function get_ka():Bool
    {
        return FlxG.keys.anyPressed(["X", "TAB"]);
    }

    static function get_kb():Bool
    {
        return FlxG.keys.anyPressed(["SPACE", "C"]);
    }

    static function get_kaP():Bool
    {
        return FlxG.keys.anyJustPressed(["X", "TAB"]);
    }

    static function get_kbP():Bool
    {
        return FlxG.keys.anyJustPressed(["SPACE", "C"]);
    }

    static function get_kaR():Bool
    {
        return FlxG.keys.anyJustReleased(["X", "TAB"]);
    }

    static function get_kbR():Bool
    {
        return FlxG.keys.anyJustReleased(["SPACE", "C"]);
    }


}