package;

import flixel.FlxBasic;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

class DemoMgr extends FlxObject
{
	private var _c:FlxGroup;
	private var _p:Player;
	private var _go:Bool;
	private var emitter:FlxEmitter;

	public function new(X:Int, P:Player, Children:FlxGroup)
	{
		super(X, 0, 1, 1);
		this.x = X;
		_p = P;
		_c = new FlxGroup();

		for (i in 0...Children.length)
		{
			_c.add(Children.members[i]);
		}

		maxVelocity.y = 300;
		velocity.y = 60;
		acceleration.y = 40;
		_go = false;
	}

	public function add(Child:FlxObject)
	{
		_c.add(Child);
	}

	public function addEmitter(Child:FlxEmitter)
	{
		emitter = Child;
	}

	override function update(elapsed:Float)
	{
		if (!_go)
		{
			if (_p.x > x)
			{
				_go = true;
				FlxG.sound.play("assets/sounds/crumble" + Main.SOUND_EXT);
				FlxG.camera.shake(0.005, 3, null, true, Y);
				// var c:FlxObject = cast _c.members[_c.length - 1];
				// _c.members[_c.length - 1].reset();
				emitter.start(false, emitter.frequency);
			}
		}

		if (_go)
		{
			var oy:Float = y;
			super.update(elapsed);

			for (i in 0..._c.length)
			{
				var c:FlxObject = cast _c.members[i];
				c.moves = true;
				c.active = true;
				c.velocity.y = velocity.y;
				// c.y += (y - oy) * (elapsed / (1 / 60)); // 144fps fix
			}
		}
	}
}
