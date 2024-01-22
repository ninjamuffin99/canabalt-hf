package;

import flixel.FlxG;
import flixel.FlxSprite;

class Dove extends FlxSprite
{   
    private var _player:Player;
    private var _radius:Int = 128;
    private var _trigger:Int;

    public function new(X:Float, Y:Float, player:Player, trigger:Int)
    {
        super(X, Y);
        loadGraphic("assets/images/dove.png", true, 8, 8);
        _player = player;
        _trigger = Std.int(trigger + Math.random() * (X - trigger) * 0.5);
        animation.add("idle", [3]);
        var start:Int = FlxG.random.int(0, 3);
        animation.add("fly", [start, (start + 1) % 3, (start + 2) % 3], 15);
        facing = FlxG.random.bool() ? LEFT : RIGHT;
        setFacingFlip(LEFT, false, false);
        setFacingFlip(RIGHT, true, false);
        animation.play("idle");        
    }

    override function update(elapsed:Float) {
        if (_player.x > _trigger)
        {
            if (velocity.y == 0)
            {
                if (Math.random() < 0.5) FlxG.sound.play("assets/sounds/flap" + FlxG.random.int(1, 3) + ".ogg");
                animation.play("fly");
                velocity.y = -50 - Math.random() * 50;
                acceleration.y = -50 - Math.random() * 300;
                var v:Int = FlxG.random.int(0, 300);
                acceleration.x = (facing == LEFT ? v:-v);
            }
        }
        
        super.update(elapsed);
    }
}