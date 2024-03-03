package;

import flixel.FlxG;
import flixel.FlxSprite;

class Jet extends FlxSprite
{
	private var _timer:Float;
	private var _limit:Float;

	public function new()
	{
		super(-500);
		loadGraphic("assets/images/jet.png");
		scrollFactor.set(0, 0.3);
		_timer = 0;

		_limit = FlxG.random.float(12, 16);
		velocity.x = -1200;
	}

	override function update(elapsed:Float)
	{
		_timer += elapsed;

		if (_timer > _limit)
		{
			x = 960;
			y = FlxG.random.float(-20, 60);
			FlxG.camera.shake(0.015, 1.4, null, true, Y);
			FlxG.sound.play("assets/sounds/flyby" + Main.SOUND_EXT + "");
			_timer = 0;
			_limit = FlxG.random.float(10, 30);
		}

		if (x < -width)
			return;
		super.update(elapsed);
	}
}
