package;

import flixel.FlxObject;

class CraneTrigger extends FlxObject
{
    private var _p:Player;
    public function new(X:Float, Y:Float, Width:Float, Height:Float, P:Player)
    {
        super();
        x = X;
        y = Y;
        width = Width;
        height = Height;
        _p = P;
    }

    override public function update(elapsed:Float):Void
    {
        if (overlaps(_p))
        {
            _p.craneFeet();
        }

        super.update(elapsed);
    }
}