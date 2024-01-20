package;

import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;

	private var _smoke:FlxGroup;

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



		_player = new Player(0, 80-14);
		// Infinite level sequence objects

		add(_player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
