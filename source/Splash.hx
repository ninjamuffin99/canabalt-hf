package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.typeLimit.NextState;
import flixel.system.FlxAssets;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Transform;
import openfl.geom.ColorTransform;

/**
 * A special recreation of the OG Flixel splash screen using the HaxeFlixel Logo
 */
class Splash extends FlxState
{
	static inline var BG_COLOR:FlxColor = 0xFF35353d;
	static inline var GREEN:FlxColor = 0xFF00b922;
	static inline var YELLOW:FlxColor = 0xFFffc132;
	static inline var RED:FlxColor = 0xFFf5274e;
	static inline var BLUE:FlxColor = 0xFF3641ff;
	static inline var CYAN:FlxColor = 0xFF04cdfb;

	static final colors = [GREEN, YELLOW, RED, BLUE, CYAN];
	static final shapes = [MIDDLE, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT];

	var _logoTimer:Float = 0;

	var _sprites:Array<LogoSprite>;
	var _camFade:Bitmap;
	var _nextState:NextState;

	var _updateFunc:() -> Void;

	public function new(nextState:NextState)
	{
		_nextState = nextState;
		super();
	}

	override function create()
	{
		FlxG.cameras.bgColor = BG_COLOR;
		FlxG.mouse.visible = false;
		FlxG.autoPause = false;
		FlxG.fixedTimestep = true;

		_sprites = [];

		for (shape in shapes)
		{
			final sprite = new LogoSprite();
			_sprites.push(sprite);
			sprite.drawShape(shape);
			FlxG.stage.addChild(sprite);
		}

		final poweredBy = new FlxSprite(0, 0);
		poweredBy.loadGraphic("assets/images/poweredby.png");
		poweredBy.x = FlxG.width / 2 - poweredBy.width / 2;
		poweredBy.y = (FlxG.height / 2 - 32 * 2) + 32 * 3;
		add(poweredBy);

		_camFade = new Bitmap(new BitmapData(1, 1, true, 0xFFffffff));
		_camFade.smoothing = false;
		_camFade.width = Lib.current.stage.stageWidth;
		_camFade.height = Lib.current.stage.stageHeight;
		FlxG.stage.addChild(_camFade);
		introFade(0xff000000, 0.2);

		resizeShit(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);

		#if FLX_SOUND_SYSTEM
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel")).play();
		#end

		_updateFunc = updateColors;

		super.create();
	}

	override function destroy()
	{
		FlxG.stage.removeChild(_camFade);
		for (sprite in _sprites)
			FlxG.stage.removeChild(sprite);

		_sprites = null;
		_nextState = null;
		_camFade = null;

		super.destroy();
	}

	function resizeShit(Width:Int, Height:Int)
	{
		for (spr in _sprites)
		{
			spr.x = (Width / 2);
			spr.y = (Height / 2) - 20 * FlxG.game.scaleY;

			spr.scaleX = FlxG.game.scaleX * 1.2;
			spr.scaleY = FlxG.game.scaleY * 1.2;
		}
	}

	function introFade(color:FlxColor, time:Float, ?onComplete:(FlxTween) -> Void)
	{
		setColor(_camFade.transform, color);
		_camFade.alpha = 1;
		FlxTween.tween(_camFade, {alpha: 0}, time, {onComplete: onComplete, onUpdate: (_) -> trace(_camFade.alpha)});
	}

	function outroFade(color:FlxColor, time:Float, ?onComplete:(FlxTween) -> Void)
	{
		setColor(_camFade.transform, color);
		_camFade.alpha = 0;
		FlxTween.tween(_camFade, {alpha: 1}, time, {onComplete: onComplete});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		_logoTimer += elapsed;
		if (_updateFunc != null)
			_updateFunc();
	}

	static final times = [0.0, 0.2, 0.4, 0.6, 0.8, 1.5];

	/** When to change colors, in seconds, last is all white */
	function updateColors()
	{
		if (_logoTimer >= times[times.length - 1])
		{
			// set full white, last call
			mixSpriteColors(times.length - 1, 1.0);
			_updateFunc = updateEnd;
			return;
		}

		// find the prev and next step
		for (step in 1...times.length)
		{
			final nextT = times[step];
			if (nextT > _logoTimer)
			{
				final prevT = times[step - 1];
				final mix = (_logoTimer - prevT) / (nextT - prevT);
				mixSpriteColors(step, mix);
				break;
			}
		}
	}

	function mixSpriteColors(step:Int, mix:Float)
	{
		for (i => sprite in _sprites)
		{
			final prevColor = getStepColor(step, i);
			final nextColor = getStepColor(step + 1, i);
			sprite.setColorMix(prevColor, nextColor, mix);
		}
	}

	inline function getStepColor(step:Int, colorIndex:Int)
	{
		return if (step >= times.length) FlxColor.WHITE; else colors[(step + colorIndex) % colors.length];
	}

	static inline var END_TIME = 2.0;

	function updateEnd()
	{
		// wait til the end and fade out
		if (_logoTimer >= END_TIME)
		{
			_updateFunc = null;
			outroFade(BG_COLOR, 0.8, (_) -> FlxG.switchState(_nextState));
		}
	}
}

enum abstract LogoShape(Int)
{
	var MIDDLE = 0;
	var TOP_LEFT = 1;
	var TOP_RIGHT = 2;
	var BOTTOM_LEFT = 3;
	var BOTTOM_RIGHT = 4;
}

/** used to update each instances color without creating a new instance every time */
var _transform = new ColorTransform();

function setColor(transform:Transform, color:FlxColor)
{
	_transform.redMultiplier = color.redFloat;
	_transform.greenMultiplier = color.greenFloat;
	_transform.blueMultiplier = color.blueFloat;
	transform.colorTransform = _transform;
}

@:forward
abstract LogoSprite(Sprite) to Sprite
{
	inline public function new()
	{
		this = new Sprite();
	}

	public function setColorMix(color1:FlxColor, color2:FlxColor, mix:Float)
	{
		setColor(this.transform, FlxColor.interpolate(color1, color2, mix));
	}

	public function drawShape(shape:LogoShape):Void
	{
		this.graphics.beginFill(0xFFffffff);
		switch shape
		{
			case MIDDLE:
				drawMiddle();
			case TOP_LEFT:
				drawTopLeft();
			case TOP_RIGHT:
				drawTopRight();
			case BOTTOM_LEFT:
				drawBottomLeft();
			case BOTTOM_RIGHT:
				drawBottomRight();
		}
		this.graphics.endFill();
	}

	inline function drawMiddle():Void
	{
		this.graphics.moveTo(-1, -37);
		this.graphics.lineTo(1, -37);
		this.graphics.lineTo(37, -1);
		this.graphics.lineTo(37, 1);
		this.graphics.lineTo(1, 37);
		this.graphics.lineTo(-1, 37);
		this.graphics.lineTo(-37, 1);
		this.graphics.lineTo(-37, -1);
		this.graphics.lineTo(-1, -37);
	}

	inline function drawTopLeft():Void
	{
		this.graphics.moveTo(-50, -50);
		this.graphics.lineTo(-25, -50);
		this.graphics.lineTo(0, -37);
		this.graphics.lineTo(-37, 0);
		this.graphics.lineTo(-50, -25);
		this.graphics.lineTo(-50, -50);
	}

	inline function drawTopRight():Void
	{
		this.graphics.moveTo(50, -50);
		this.graphics.lineTo(25, -50);
		this.graphics.lineTo(0, -37);
		this.graphics.lineTo(37, 0);
		this.graphics.lineTo(50, -25);
		this.graphics.lineTo(50, -50);
	}

	inline function drawBottomLeft():Void
	{
		this.graphics.moveTo(-50, 50);
		this.graphics.lineTo(-25, 50);
		this.graphics.lineTo(0, 37);
		this.graphics.lineTo(-37, 0);
		this.graphics.lineTo(-50, 25);
		this.graphics.lineTo(-50, 50);
	}

	inline function drawBottomRight():Void
	{
		this.graphics.moveTo(50, 50);
		this.graphics.lineTo(25, 50);
		this.graphics.lineTo(0, 37);
		this.graphics.lineTo(37, 0);
		this.graphics.lineTo(50, 25);
		this.graphics.lineTo(50, 50);
	}
}
