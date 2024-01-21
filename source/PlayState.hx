package;

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _focus:FlxObject;

	private var _shardsA:FlxGroup;
	private var _shardsB:FlxGroup;
	private var _seqA:Sequence;
	private var _seqB:Sequence;
	private var _smoke:FlxGroup;
	private var _gameover:Float;
	private var _epitaph:String;

	override public function create()
	{
		super.create();

		var s:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height,0xffb0b0bf);
		s.scrollFactor.set();
		add(s);

		var mothership:FlxSprite = new FlxSprite(800, 0).loadGraphic("assets/images/mothership.png");
		mothership.scrollFactor.set(0.01, 0);
		add(mothership);

		
		_smoke = new FlxGroup();
		
		for (i in 0...5)
		{	
			var e:FlxEmitter = new FlxEmitter(0, 0);
			e.frequency = 0.15;
			e.maxSize = 100;
			e.velocity.set(-2, 1, 1, -6);
			e.angularVelocity.set(-18, 0);
			
			for (j in 0...100)
			{
				var smokeSpr:FlxParticle = new FlxParticle();
				smokeSpr.loadGraphic("assets/images/smoke.png");
				smokeSpr.scrollFactor.set(0.1, 0.05);
				e.add(smokeSpr);
			}
			
			add(e);
			_smoke.add(e);

		}

		var bg:BG = new BG("assets/images/background.png", 0, 12);
		bg.scrollFactor.set(0.15, 0.1);
		add(bg);

		var bg2:BG = new BG("assets/images/background.png", 480, 12);
		bg2.scrollFactor.set(0.15, 0.1);
		add(bg);

		var mid:BG = new BG("assets/images/midground1.png", 0, 42);
		mid.scrollFactor.set(0.4, 0.2);
		add(mid);

		var mid2:BG =  new BG("assets/images/midground2.png", 480, 42);
		mid2.scrollFactor.set(0.4, 0.2);
		add(mid2);


		// camera settings
		_focus = new FlxObject(0, 0, 1, 1);
		add(_focus);
		FlxG.camera.follow(_focus, LOCKON);
		FlxG.camera.setScrollBounds(0, null, 0, 320);
		FlxG.camera.followLead.set(15, 15);

		_player = new Player(0, 80-14);
		// Infinite level sequence objects
		var numShards:Int = 50;

		_shardsA = new FlxGroup();
		_shardsB = new FlxGroup();
		for (i in 0...numShards)
		{
			_shardsA.add(new Shard());
			_shardsB.add(new Shard());
		}
			

		Sequence.curIndex = 0;
		Sequence.nextIndex = FlxG.random.int(3, 6);
		Sequence.nextType = 1;
		_seqA = new Sequence(_player, _shardsA, _shardsB);
		_seqB = new Sequence(_player, _shardsA, _shardsB);
		add(_seqA);
		add(_seqB);
		_seqA.init(_seqB);
		_seqB.init(_seqA);

		add(_shardsA);
		add(_shardsB);

		add(_player);


		FlxG.camera.shake(0.01, 3, null, true, Y);
		FlxG.sound.play("assets/sounds/crumble.ogg");
	}

	
	override public function update(elapsed:Float)
	{	
		if (_gameover > 0) _gameover += elapsed;
		if ((_gameover > 0.35) && (Controls.ka || Controls.kb))
			FlxG.switchState(new PlayState());

		FlxG.worldBounds.set(camera.scroll.x, camera.scroll.y, camera.width, camera.height);
		
		var wasDead:Bool = !_player.alive;
		super.update(elapsed);

		_focus.x = _player.x + FlxG.width * 0.5;
		_focus.y = _player.y + FlxG.height * 0.18 + (_player._onFloor ? 0 : 20);

		FlxG.collide(_seqA.blocks, _player);
		FlxG.collide(_seqB.blocks, _player);

		if (!_player.alive && !wasDead)
		{
			_gameover = 0.01;
			var h:Int = 42;

			var t:FlxText;
			var distance:Int = Std.int(_player.x / 10);
			_epitaph = "You ran " + distance + "m before " + _player.epitaph;

			t = new FlxText(0, h + 50, FlxG.width, _epitaph, 8);
			t.alignment = CENTER;
			t.scrollFactor.set();
			add(t);
		}
		
	}
}
