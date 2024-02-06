package;

import lime.app.Application;
import flixel.ui.FlxSpriteButton;
import flixel.ui.FlxButton;
import flixel.text.FlxBitmapText;
import openfl.Assets;
import flixel.graphics.frames.FlxBitmapFont;
import openfl.events.ProgressEvent;
import openfl.net.URLRequest;
import openfl.net.URLLoader;
import io.newgrounds.Call.CallError;
import io.newgrounds.objects.events.Outcome.TypedOutcome;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
	private var _player:Player;
	private var _focus:FlxObject;

	private var _font:FlxBitmapFont;
	private var _distText:FlxBitmapText;
	private var _distText2:FlxBitmapText;
	private var _distText3:FlxBitmapText;

	private var _shardsA:FlxTypedGroup<Shard>;
	private var _shardsB:FlxTypedGroup<Shard>;
	private var _seqA:Sequence;
	private var _seqB:Sequence;
	private var _smoke:FlxTypedGroup<FlxEmitter>;
	private var _gameover:Float;
	private var _epitaph:String;

	// used for overlap checks with mouse
	private var buttons:FlxGroup;

	override public function create() {
		super.create();

		_font = FlxBitmapFont.fromAngelCode("assets/data/nokia/nokia.png", Xml.parse(Assets.getText("assets/data/nokia/nokia.fnt")));

		FlxG.mouse.visible = false;

		var s:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xffb0b0bf);
		s.scrollFactor.set();
		add(s);

		var mothership:FlxSprite = new FlxSprite(800, 0).loadGraphic("assets/images/mothership.png");
		mothership.scrollFactor.set(0.01, 0);
		add(mothership);

		_smoke = new FlxTypedGroup<FlxEmitter>();

		for (i in 0...5) {
			var e:FlxEmitter = new FlxEmitter(0, 0, 50);
			e.launchMode = SQUARE;
			e.frequency = 0.15;
			e.maxSize = 50;
			e.velocity.start.min.x = -2;
			e.velocity.start.max.x = 1;
			e.velocity.start.min.y = -18;
			e.velocity.start.max.y = -6;

			e.velocity.end = e.velocity.start;

			e.lifespan.set(10, 20);

			// e.angularVelocity.set(-18, 0);
			e.loadParticles("assets/images/smoke.png", 50, 0);

			for (p in e.members)
				p.scrollFactor.set(0.1, 0.05);

			add(e);
			_smoke.add(e);
		}

		add(new Walker(_smoke));
		add(new Walker(_smoke));

		var bg:BG = new BG("assets/images/background.png", 0, 12);
		bg.scrollFactor.set(0.15, 0.1);
		add(bg);

		var bg2:BG = new BG("assets/images/background.png", 480, 12);
		bg2.scrollFactor.set(0.15, 0.1);
		add(bg2);

		var mid:BG = new BG("assets/images/midground1.png", 0, 42);
		mid.scrollFactor.set(0.4, 0.2);
		add(mid);

		var mid2:BG = new BG("assets/images/midground2.png", 480, 42);
		mid2.scrollFactor.set(0.4, 0.2);
		add(mid2);

		add(new Jet());

		// camera settings
		_focus = new FlxObject(0, 0, 1, 1);
		add(_focus);
		FlxG.camera.follow(_focus, NO_DEAD_ZONE, 15 / 60);
		FlxG.camera.setScrollBounds(0, null, 0, 320);
		FlxG.camera.followLead.set(1.5, 0);

		_player = new Player(0, 80 - 14);
		// Infinite level sequence objects
		var numShards:Int = 50;

		_shardsA = new FlxTypedGroup<Shard>();
		_shardsB = new FlxTypedGroup<Shard>();
		for (i in 0...numShards) {
			_shardsA.add(new Shard(_shardsA));
			_shardsB.add(new Shard(_shardsB));
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

		var girder:BG = new BG("assets/images/girder.png", 3000, 0, true);
		girder.scrollFactor.set(3, 1.5);
		add(girder);

		var girder2:BG = new BG("assets/images/girder2.png", 3000, 0, true);
		girder2.scrollFactor.set(4, 1.5);
		add(girder2);

		_distText2 = new FlxBitmapText(FlxG.width - 4, 1, "", _font);
		_distText2.color = 0xFF35353d;
		_distText2.autoSize = false;
		_distText2.alignment = RIGHT;
		_distText2.scrollFactor.set();
		_distText2.width = 80;
		add(_distText2);

		_distText3 = new FlxBitmapText(FlxG.width - 3, 1, "", _font);
		_distText3.color = 0xFF35353d;
		_distText3.autoSize = false;
		_distText3.alignment = RIGHT;
		_distText3.scrollFactor.set();
		_distText3.width = 80;
		add(_distText3);

		_distText = new FlxBitmapText(FlxG.width - 4, 0, "", _font);
		_distText.autoSize = false;
		_distText.alignment = RIGHT;
		_distText.scrollFactor.set();
		_distText.width = 80;
		add(_distText);

		FlxG.camera.shake(0.01, 3, null, true, Y);
		FlxG.sound.play("assets/sounds/crumble" + Main.SOUND_EXT + "");

		_gameover = 0;

		// Pings every 3 minutes to keep session alive
		// Hashlink isn't threaded / async! it stutters funny!
		if (NG.core.loggedIn) {
			new FlxTimer().start(180, _ -> {
				if (NG.core.loggedIn)
					NG.core.calls.gateway.ping().send();
			}, 0);
		}

		buttons = new FlxGroup();
	}

	override public function update(elapsed:Float) {
		if (_gameover > 0)
			_gameover += elapsed;
		if ((_gameover > 0.35) && (Controls.ka || Controls.kb) && !FlxG.mouse.overlaps(buttons))
			FlxG.switchState(new PlayState());

		FlxG.worldBounds.set(camera.scroll.x
			- FlxG.width, camera.scroll.y
			- FlxG.height, camera.width
			+ FlxG.width * 2, camera.height
			+ FlxG.height * 2);

		var wasDead:Bool = !_player.alive;
		super.update(elapsed);

		_focus.x = _player.x + FlxG.width * 0.5;
		_focus.y = _player.y + FlxG.height * 0.18 + (_player._onFloor ? 0 : 20);

		FlxG.collide(_seqA.blocks, _player);
		FlxG.collide(_seqB.blocks, _player);

		FlxG.collide(_seqA.blocks, _shardsA);
		FlxG.collide(_seqA.blocks, _shardsB);
		FlxG.collide(_seqB.blocks, _shardsA);
		FlxG.collide(_seqB.blocks, _shardsB);

		var hud:String = Std.int(_player.x / 10) + "m";

		Application.current.window.title = "Canabalt - " + hud;

		_distText.text = hud;
		_distText2.text = hud;
		_distText3.text = hud;

		if (!_player.alive && !wasDead) {
			if (!FlxG.onMobile) {
				FlxG.mouse.visible = true;
			}

			_gameover = 0.01;
			var h:Int = 42;

			var s:FlxSprite = new FlxSprite(0, h + 35).makeGraphic(FlxG.width, 32, 0xff35353d);
			s.scrollFactor.set();
			add(s);

			var s = new FlxSprite(0, h + 67).makeGraphic(FlxG.width, 1);
			s.scrollFactor.set();
			add(s);

			var s = new FlxSprite(0, FlxG.height - 18).makeGraphic(FlxG.width, 18, 0xff35353d);
			s.scrollFactor.set();
			add(s);

			var s = new FlxSprite((FlxG.width - 390) / 2, h).loadGraphic("assets/images/gameover.png");
			s.scrollFactor.set();
			add(s);

			var t:FlxBitmapText;
			var distance:Int = Std.int(_player.x / 10);
			_epitaph = "You ran " + distance + "m before " + _player.epitaph;

			t = new FlxBitmapText(0, h + 50, _epitaph, _font);
			t.screenCenter(X);
			t.scrollFactor.set();
			add(t);

			var t = new FlxBitmapText(FlxG.width - 200, FlxG.height - 15, "Jump to retry your daring escape.", _font);
			t.autoSize = true;
			t.alignment = RIGHT;
			t.wordWrap = false;
			t.scrollFactor.set();
			t.x = FlxG.width - t.width - 4;
			add(t);

			_distText.visible = false;
			_distText2.visible = false;
			_distText3.visible = false;

			var support:FlxButton = new FlxButton(4, FlxG.height - 15, "", () -> {
				FlxG.openURL("https://finji.co");
			});
			support.scrollFactor.set();
			support.loadGraphic("assets/images/panel_support_finji.png");
			add(support);
			buttons.add(support);

			var github:FlxButton = new FlxButton(support.x + support.width + 2, FlxG.height - 14, "", () -> {
				FlxG.openURL("https://github.com/ninjamuffin99/canabalt-hf");
			});
			github.scrollFactor.set();
			github.loadGraphic("assets/images/panel_github.png");

			add(github);
			buttons.add(github);

			postScore(distance);
		}
	}

	function postScore(distance:Int) {
		if (!NG.core.loggedIn)
			return;

		if (NG.core.scoreBoards.state == Loaded)
			NG.core.scoreBoards.get(12451).postScore(distance, _player.epitaph);
		else {
			NG.core.scoreBoards.loadList(outcum -> {
				switch (outcum) {
					case SUCCESS:
						NG.core.scoreBoards.get(13451).postScore(distance, _player.epitaph);
					case FAIL(error):
						trace("Failed to load scoreboards: " + error);
				}
			});
		}
	}
}
