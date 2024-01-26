package source; // need source here since it's run from the main directory!

import flixel.system.FlxBasePreloader;

class Preloader extends FlxBasePreloader
{
    override public function new()
    {
        super(5);
    }

    override function create():Void
    {
        super.create();
    }
}