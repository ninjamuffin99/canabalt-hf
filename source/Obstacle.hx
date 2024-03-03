package;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;

class Obstacle extends FlxSprite
{
	private var _p:Player;

	public function new(X:Float, Y:Float, P:Player, Alt:Bool = false)
	{
		super(X, Y);
		loadGraphic(Alt ? "assets/images/obstacles2.png" : "assets/images/obstacles.png", true, 14, 14);
		frame = frames.frames[FlxG.random.int(0, frames.numFrames - 1)];
		width = 12;
		height = 2;
		offset.x = 1;
		offset.y = 12;
		y -= height;
		_p = P;
	}

	override function update(elapsed:Float)
	{
		if (alive && overlaps(_p))
		{
			_p.stumble();
			_p.velocity.x *= 0.7;

			// Double check to see if this is meant to randomly NOT play a sound
			// or if my math is just fuckie!
			var rs:Int = FlxG.random.int(0, 3);
			if (rs != 0)
				FlxG.sound.play("assets/sounds/obstacle" + rs + "" + Main.SOUND_EXT + "");

			velocity.x = _p.velocity.x + FlxG.random.float(-50, 50);
			velocity.y = -120;
			acceleration.y = 320;
			kill();
		}

		super.update(elapsed);
	}

	override function kill()
	{
		alive = false;
		FlxFlicker.flicker(this, 0);
		angularVelocity = FlxG.random.float(-360, 360);
	}
}
