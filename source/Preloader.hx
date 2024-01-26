package source;

import haxe.Timer;
import openfl.display.BitmapDataChannel;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.FlxG;
import flixel.system.FlxBasePreloader;

@:keep @:bitmap("assets/images/preloader/light.png")
private class GraphicLogoLight extends BitmapData {}

@:keep @:bitmap("assets/images/preloader/corners.png")
private class GraphicLogoCorners extends BitmapData {}

// A copy of FlxPreloader, but loads nicer with lerp, and PLAY button
class Preloader extends FlxBasePreloader
{
	var _buffer:Sprite;
	var _bmpBar:Bitmap;
	var _text:TextField;

    var noiseOverlay:BitmapData;
    var noise:Bitmap;


	override public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>):Void
	{
		super(MinDisplayTime, AllowedURLs);
	}

	override function create():Void
	{
		_buffer = new Sprite();
		_buffer.scaleX = _buffer.scaleY = 2;
		addChild(_buffer);
		_width = Std.int(Lib.current.stage.stageWidth / _buffer.scaleX);
		_height = Std.int(Lib.current.stage.stageHeight / _buffer.scaleY);
		_buffer.addChild(new Bitmap(new BitmapData(_width, _height, false, 0xff35353d)));

		_bmpBar = new Bitmap(new BitmapData(_width, 7, false, 0xFFFFFFFF));
		_bmpBar.x = 4;
		_bmpBar.y = _height - 11;
        _bmpBar.scaleX = 0;
		_buffer.addChild(_bmpBar);

		_text = new TextField();
		_text.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 8, 0xFFFFFFFF);
		_text.embedFonts = true;
		_text.selectable = false;
		_text.multiline = false;
		_text.x = 2;
		_text.y = _bmpBar.y - 11;
		//_text.width = 300;
		_buffer.addChild(_text);

        noiseOverlay = new BitmapData(_width, _height, false);
        // noiseOverlay.noise(200, 0, 255, 7, true);
        
        noise = new Bitmap(noiseOverlay);
        noise.blendMode = BlendMode.MULTIPLY;
        noise.alpha = 0.7;
        
        _buffer.addChild(noise);

		super.create();
	}

	/**
	 * Cleanup your objects!
	 * Make sure you call super.destroy()!
	 */
	override function destroy():Void
	{
		if (_buffer != null)
		{
			removeChild(_buffer);
		}
		_buffer = null;
		_bmpBar = null;
		_text = null;
        
		super.destroy();
	}

    var prevPercentage:Float = 0;

	/**
	 * Update is called every frame, passing the current percent loaded. Use this to change your loading bar or whatever.
	 * @param	Percent	The percentage that the project is loaded
	 */
	override public function update(Percent:Float):Void
	{
		_bmpBar.scaleX = lerp(_bmpBar.scaleX, Percent, 0.1);
        prevPercentage = lerp(prevPercentage, Percent, 0.1);
		_text.text = "Loading Canabalt";
        //_text.width = _width;
        //noiseOverlay.noise(Std.int(Percent * 1000), 0, 255, 7, true);
        genNoise(Percent * Percent);

        if (noise.alpha < 1)
            noise.alpha = (Percent / 1) + 0.2;

		if (Percent > 0.9)
		{
			//_buffer.alpha = 1 - (Percent - 0.9) / 0.1;
		}

        if (Percent == 1)
        {
            swag = new TextField();
            swag.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xFFFFFFFF);
            swag.embedFonts = true;
            swag.selectable = false;
            swag.multiline = false;
            swag.width = _width;
            swag.text = "click anywhere, to begin your daring escape";
            swag.x = _width / 2 - swag.textWidth / 2;
            swag.y = _height / 2 - swag.textHeight / 2;
            addChild(swag);

            Lib.current.stage.addEventListener("click", forceLoad);    
        }

        super.update(Percent);
	}

    var swag:TextField;

    function forceLoad(_) {
        Lib.current.stage.displayState = FULL_SCREEN;
        doForceLoad = true;
        removeEventListener("click", forceLoad);
        
        haxe.Timer.delay(function() {
            onLoaded();
        }, 100); 
    }

    function genNoise(Percent:Float):Void
    {
        noiseOverlay.lock();
        for (i in 0...noiseOverlay.width)
        {
            for (j in 0...noiseOverlay.height)
            {   
                var invPercent:Float = 1 - Percent;

                var darkPix:Bool = Math.random() * 1 < Percent;

                var hexColor:Int = 0xFFFFFFF;
                if (darkPix)
                    hexColor = 0x000000;

                noiseOverlay.setPixel(i, j, hexColor);
                
            }
        }
        noiseOverlay.unlock();
    }
    var doForceLoad:Bool = false;
    override public function onLoaded() {
        //super.onLoaded();
        if (doForceLoad)
        {
            super.onLoaded();
        }
            
    }

    function lerp(a:Float, b:Float, ratio:Float):Float
    {
        return a + ratio * (b - a);
    }
}
