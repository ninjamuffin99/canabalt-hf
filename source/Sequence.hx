package;

import flixel.group.FlxGroup;
import flixel.FlxObject;

class Sequence extends FlxObject
{
    public var blocks:FlxGroup;
    public var roof:Bool = false;

    private var _player:Player;
    private var _shardsA:FlxGroup;
    private var _shardsB:FlxGroup;
    

    public function new(player:Player, shardsA:FlxGroup, shardsB:FlxGroup)
    {
        super();

        _player = player;
        _shardsA = shardsA;
        _shardsB = shardsB;
        x = 0;
        y = 0;
        width = 0;
        height = 0;


        blocks = new FlxGroup();
        
    }
}