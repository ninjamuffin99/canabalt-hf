package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{   

    private var _my:Float = 0;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic("assets/images/player.png", true, 24, 24);
        width = 12;
        height = 14;

        offset.x = 4;
        offset.y = 10;

        animation.add("run1",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],15);
        animation.add("run2",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],28);
        animation.add("run3",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],40);
        animation.add("run4",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],60);
        animation.add("jump",[16,17,18,19],12,false);
        animation.add("fall",[20,21,22,23,24,25,26],14);
        animation.add("stumble1",[27,28,29,30,31,32,33,34,35,36,37],14);
        animation.add("stumble2",[27,28,29,30,31,32,33,34,35,36,37],21);
        animation.add("stumble3",[27,28,29,30,31,32,33,34,35,36,37],28);
        animation.add("stumble4",[27,28,29,30,31,32,33,34,35,36,37],35);
        
        drag.x = 640;
        acceleration.x = 1;
        acceleration.y = 1200;
        maxVelocity.x = 800;
        velocity.x = 100;
        maxVelocity.y = 300;

        _my = 0;

    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (velocity.y == maxVelocity.y) _my += FlxG.elapsed;
    }
}