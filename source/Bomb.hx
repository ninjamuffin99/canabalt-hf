package;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxSprite;

class Bomb extends FlxSprite
{
	private var _y:Int;
	private var _p:Player;
	private var _e:FlxEmitter;
	private var _s:Sequence;

	public function new(x:Int, y:Int, P:Player, S:Sequence)
	{
		super(x, -64);
		loadGraphic("assets/images/bomb.png");
		_y = y - 24;
		_p = P;
		_s = S;
		x -= Std.int(width / 2);
		height = 48;
		offset.y = 16;
		velocity.y = 800;
		FlxG.sound.play("assets/sounds/bomb_launch" + Main.SOUND_EXT + "", 0.35);
	}

	public function addEmitter(E:FlxEmitter)
	{
		_e = E;
	}

	override function update(elapsed:Float)
	{
		if (y <= -64)
		{
			if (_p.x > x - 480)
				FlxG.sound.play("assets/sounds/bomb_pre" + Main.SOUND_EXT + "");
		}

		if (_p.x > x - 480)
			super.update(elapsed);

		if (velocity.y > 0)
		{
			if (y > _y)
			{
				velocity.y = 0;
				y = _y;
				angularVelocity = FlxG.random.float(-60, 60);
				angularDrag = Math.abs(angularVelocity);
				// figure out the hf equivalent
				FlxG.camera.shake(0.065, 0.15);
				_e.x = _s.x;
				_e.width = _s.width;
				_e.y = _y;
				_e.height = FlxG.random.float(12, 20);

				_e.start(true);

				FlxG.sound.play("assets/sounds/bomb_hit" + Main.SOUND_EXT);
			}
		}
		else if (overlaps(_p))
		{
			FlxG.sound.play("assets/sounds/bomb_explode" + Main.SOUND_EXT);
			_p.y = 400;
			_p.epitaph = "turning into a fine mist.";
			_s.aftermath();
		}
	}
}
