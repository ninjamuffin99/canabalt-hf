package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	// Why can't Safari play .ogg in 2024.... :(
	public static var SOUND_EXT:String = #if web ".mp3" #else ".ogg" #end;

	#if web
	var framerate:Int = 60;
	#else
	var framerate:Int = 144;
	#end

	public function new()
	{
		super();
		addChild(new FlxGame(480, 160, MenuState, framerate, framerate));
	}
}
