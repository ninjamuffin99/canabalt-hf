package;

import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;

class Walker extends FlxSprite
{
	private var _firing:Bool;
	private var _walkTimer:Float;
	private var _idleTimer:Float;
	private var _smoke:FlxTypedGroup<FlxEmitter>;

	static private var _s:Int;

	public function new(Smoke:FlxTypedGroup<FlxEmitter>)
	{
		super(-500, FlxG.random.float(16, 20));
		loadGraphic("assets/images/walker.png", true, 96, 64);
		_smoke = Smoke;
		scrollFactor.x = 0.1;
		scrollFactor.y = 0.05;

		animation.add("idle", [0]);
		animation.add("walk", [0, 1, 2, 3, 4, 5], 8);
		animation.add("fire", [6, 7, 8, 9, 10, 11], 8, false);
		animation.play("idle");

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
	}

	override function update(elapsed:Float)
	{
		if (_walkTimer > 0)
		{
			_walkTimer -= elapsed;
			if (_walkTimer <= 0)
			{
				animation.play("fire");
				_firing = true;
				velocity.x = 0;
				if (++_s >= _smoke.length)
					_s = 0;
				_smoke.members[_s].x = x + ((facing == LEFT) ? (width - 22) : 10);
				_smoke.members[_s].y = y + height;
				_smoke.members[_s].start(false, _smoke.members[_s].frequency);
			}
		}
		else if (_firing)
		{
			if (animation.finished)
			{
				_firing = false;
				_idleTimer = FlxG.random.float(1, 3);
				animation.play("idle");
			}
		}
		else if (_idleTimer > 0)
		{
			_idleTimer -= elapsed;
			if (_idleTimer <= 0)
			{
				if (FlxG.random.bool())
				{
					_walkTimer = FlxG.random.float(2, 6);
					animation.play("walk");
					velocity.x = (facing == LEFT) ? 40 : -40;
				}
				else
				{
					animation.play("fire");
					_firing = true;

					if (++_s >= _smoke.length)
						_s = 0;
					_smoke.members[_s].x = x + ((facing == LEFT) ? (width - 22) : 10);
					_smoke.members[_s].y = y + height;
					_smoke.members[_s].start(false, _smoke.members[_s].frequency);
				}
			}
		}

		if (getScreenPosition().x + width < 0)
		{
			_walkTimer = FlxG.random.float(0, 2);
			facing = FlxG.random.bool() ? LEFT : RIGHT;
			x += FlxG.width + width + FlxG.random.float(0, FlxG.width);
		}

		super.update(elapsed);
	}
}
