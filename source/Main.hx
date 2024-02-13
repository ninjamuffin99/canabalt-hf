package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyList;
import flixel.system.FlxSplash;
import lime.app.Event;
import lime.app.Application;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;


class Main extends Sprite {
	// Why can't Safari play .ogg in 2024.... :(
	public static var SOUND_EXT:String = #if web ".mp3" #else ".ogg" #end;

	#if web
	var framerate:Int = 60;
	#else
	var framerate:Int = 144;
	#end

	public function new() {
		super();

		#if web
		// pixel perfect render fix!
		Application.current.window.element.style.setProperty("image-rendering", "pixelated");
		#end

		addChild(new FlxGame(480, 160, ()->new Splash(MenuState.new), framerate, framerate, true));

		Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (e:KeyboardEvent) -> {
			if (e.keyCode == FlxKey.F) {
				Lib.application.window.fullscreen = !Lib.application.window.fullscreen;
			}
		});
	}
}

class Splash extends FlxSplash
{
	override function create()
	{
		// set bgColor before and after `super.create()` otherwise it will set it to black for a frame
		FlxG.cameras.bgColor = 0xff35353d;
		FlxSplash.muted = false;
		
		super.create();
		
		FlxG.cameras.bgColor = 0xff35353d;
	}
}
