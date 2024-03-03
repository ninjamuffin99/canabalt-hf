package;

import flixel.FlxG;
import flixel.FlxSprite;

class BG extends FlxSprite
{
	private var _r:Bool;

	public function new(img:String, X:Int, Y:Int, Random:Bool = false)
	{
		super(X, Y);
		loadGraphic(img);
		_r = Random;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (getScreenPosition().x + width < 0)
		{
			if (_r)
			{
				x += FlxG.random.int(FlxG.width * 10, FlxG.width * 20);
				scrollFactor.x = FlxG.random.float(2, 5);
			}
			else x += width * 2;
		}
	}
}
