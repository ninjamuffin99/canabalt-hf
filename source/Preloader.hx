package source;

import openfl.events.MouseEvent;
import openfl.display.SimpleButton;
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
        _text.text = "Loading Canabalt...";
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

        genNoise(Percent * Percent);

        if (noise.alpha < 1)
            noise.alpha = (Percent / 1) + 0.2;

		if (Percent > 0.9)
		{
			//_buffer.alpha = 1 - (Percent - 0.9) / 0.1;
		}

        if (Percent == 1 && swag == null)
        {   
            swag = new Sprite();
            swag.graphics.beginFill(0xFFFFFF, 1);
            swag.graphics.drawRect(0, 0, 180, 50);
            swag.graphics.endFill();
            swag.graphics.beginFill(0x000000, 1);
            swag.graphics.drawRect(4, 4, 172, 42);
            swag.graphics.endFill();
            swag.buttonMode = true;
            swag.x = (stage.stageWidth - swag.width) / 2;
            swag.y = (stage.stageHeight - swag.height) / 2;
            swag.addEventListener(MouseEvent.MOUSE_DOWN, this.forceLoad);
            swag.addEventListener(MouseEvent.MOUSE_OVER, this.hoverPlay);
            swag.addEventListener(MouseEvent.MOUSE_OUT, this.hoverOut);
            addChild(swag);

            var play:TextField = new TextField();
            play.text = "Play Canabalt";
            play.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 16, 0xFFFFFF);
            play.embedFonts = true;
            play.selectable = false;
            play.multiline = false;
            play.x = (swag.width - play.textWidth) / 2;
            play.y = (swag.height - play.textHeight) / 2;
            play.width = 150;
            play.height = 50;
            swag.addChild(play);
 
        }

        super.update(Percent);
	}

    var swag:Sprite;

    function hoverPlay(e:MouseEvent)
    {
        swag.y += 2;
        swag.alpha = 0.8;
    }

    function hoverOut(e:MouseEvent)
    {
        swag.y -= 2;
        swag.alpha = 1;
    }

    function forceLoad(_) {
        // only force fullscreen on mobile
        if (FlxG.onMobile)
            Lib.current.stage.displayState = FULL_SCREEN;
        doForceLoad = true;
        Lib.application.window.fullscreen = true;
        swag.removeEventListener(MouseEvent.CLICK, forceLoad);
        
        Timer.delay(() -> {onLoaded();}, 600);
        
        
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

        #if desktop
        doForceLoad = true;
        #end
        
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
