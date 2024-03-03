package;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

class Window extends FlxSprite
{
	public static final w:Int = 2;

	private var _shards:FlxEmitter;
	private var _player:Player;

	public function new(X:Float, Y:Float, Height:Int, Layer:FlxGroup, player:Player, shards:FlxTypedGroup<Shard>)
	{
		super(X, Y - Height);
		makeGraphic(w, Height, 0xFFFFFFFF);
		width = 32;
		_player = player;
		_shards = new FlxEmitter(x, y, 50);
		_shards.allowCollisions = ANY;
		_shards.width = w;
		_shards.height = height;
		_shards.angularVelocity.set(-720, 720);
		_shards.acceleration.set(0, 500);
		_shards.particleClass = Shard;
		_shards.launchMode = FlxEmitterMode.SQUARE;
		_shards.elasticity.set(0.35);
		_shards.lifespan.set(3, 6);

		for (shard in shards.members)
			_shards.add(shard);

		Layer.add(_shards);
		// _shards = Layer.add(new FlxEmitter(x, y))
	}

	override function update(elapsed:Float)
	{
		if (overlaps(_player))
		{
			FlxG.sound.play("assets/sounds/window" + FlxG.random.int(1, 2) + "" + Main.SOUND_EXT + "", 0.35);

			exists = false;
			_shards.velocity.start.min.x = _player.velocity.x / 2;
			_shards.velocity.start.max.x = _shards.velocity.start.min.x * 3;

			_shards.velocity.start.min.y = _player.velocity.y / 2 - FlxG.random.float(0, 40);
			_shards.velocity.start.max.y = _shards.velocity.start.min.y * 3;

			_shards.velocity.end = _shards.velocity.start;

			_shards.start();
		}
		super.update(elapsed);
	}
}
