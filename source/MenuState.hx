package;

import flixel.util.FlxTimer;
import io.newgrounds.objects.events.Outcome;
import io.newgrounds.NGLite.LoginOutcome;
import io.newgrounds.NG;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class MenuState extends FlxState {
	var _title:FlxSprite;
	var _title2:FlxSprite;
	var _title3:FlxSprite;

	var mouseTimer:Float = 0;

	override public function create() {
		FlxG.game.focusLostFramerate = 60;

		FlxG.fixedTimestep = !FlxG.onMobile; // fixed framerate on mobile
		FlxG.camera.bgColor = 0xff35353d;
		FlxSprite.defaultAntialiasing = false;
		FlxG.mouse.load("assets/images/cursor.png", 2);
		FlxG.mouse.visible = false;
		FlxG.sound.playMusic("assets/music/title" + Main.SOUND_EXT + "", 0);
		FlxG.sound.music.fadeIn(1);

		if (!NG.core?.loggedIn) // not already logged in, maybe preloader got skipped!
			initNG();

		_title = new FlxSprite(0, -FlxG.height, "assets/images/title.png");
		_title.velocity.y = 135;
		_title.drag.y = 60;
		add(_title);

		_title2 = new FlxSprite((FlxG.width - 341) / 2, 9, "assets/images/title2.png");
		_title2.alpha = 0;
		add(_title2);

		_title3 = new FlxSprite(FlxG.width - 204, FlxG.height - 12, "assets/images/title3.png");
		_title3.alpha = 0;
		add(_title3);

		Assets.getSound("assets/music/run" + Main.SOUND_EXT + "");

		super.create();
	}

	function initNG() {
		// somewhat gracefully fallback if there's no API keys stuff

		NG.createAndCheckSession(API.ngapi, true, null);
		NG.core.setupEncryption(API.ngenc);

		var notifString:String = "Connected to Newgrounds";

		if (!NG.core.loggedIn) {
			if (FlxG.onMobile)
				notifString += ". Tap here to login";
			else
				notifString += ". Press N to login";
		}

		new FlxTimer().start(4, _ -> {
			Notification.instance.genTexts(notifString, 4, BOTTOM_LEFT);
		});
	}

	function attemptLogin() {
		NG.core.requestLogin((callback) -> {
			var notifText:String = callback.getName();
			if (callback.match(Outcome.SUCCESS)) {
				notifText = "Connected user: " + NG.core.user.name;
			}
			Notification.instance.genTexts(notifText, 3, BOTTOM_LEFT);
		});
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		mouseTimer += elapsed;

		if (!NG.core?.loggedIn && FlxG.keys.justPressed.N) {
			attemptLogin();
		}

		if (FlxG.onMobile) {
			var firstTouch = FlxG.touches.getFirst();
			if (firstTouch?.justPressed) {
				if (firstTouch.y > FlxG.height - 20)
					attemptLogin();
			}
		}

		if ((_title.velocity.y == 0) && (_title2.alpha < 1))
			_title2.alpha += FlxG.elapsed;

		if ((_title2.alpha >= 1) && (_title3.alpha < 1))
			_title3.alpha += FlxG.elapsed / 2;

		if (Controls.kb || Controls.ka) {
			if (!FlxG.onMobile && FlxG.mouse.pressed && mouseTimer < 4)
				return; // wait a few seconds before accepting mouse input (unless on mobile!)
			if (FlxG.onMobile && FlxG.touches.getFirst()?.justPressedPosition.y > FlxG.height - 20)
				return;
			FlxG.switchState(new PlayState());
			FlxG.sound.playMusic("assets/music/run" + Main.SOUND_EXT + "");
		}
	}
}
