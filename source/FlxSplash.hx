package;

import flixel.FlxSprite;
import openfl.display.Bitmap;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Graphics;
import flixel.util.FlxColor;
import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxState;
import openfl.display.BitmapData;

class FlxSplash extends FlxState
{   
    var _logoTimer:Float = 0;

    var _gfx:Graphics;
    var _camFade:Bitmap;

    var _gfxMid:Graphics;
    var _gfxTopLeft:Graphics;
    var _gfxTopRight:Graphics;
    var _gfxBottomLeft:Graphics;
    var _gfxBottomRight:Graphics;

    var drawFuncs:Array<Int->Graphics->Void>;
    var cols:Array<Int>;
    var _layers:Array<Sprite>;
    var _whiteSpr:Array<Sprite>;
    var _curLayerBatch:Int = 0;
    var poweredBy:FlxSprite;

    override function create() {
        FlxG.cameras.bgColor = 0xff35353d;
        FlxG.mouse.visible = false;
        FlxG.autoPause = false;
        FlxG.fixedTimestep = false;
        
        var stageWidth:Int = Lib.current.stage.stageWidth;
        var stageHeight:Int = Lib.current.stage.stageHeight;

        cols = [colGreen, colYellow, colRed, colBlue, colLightBlue];
        drawFuncs = [drawMiddle, drawTopLeft, drawTopRight, drawBottomLeft, drawBottomRight];
        _layers = [];
        _whiteSpr = [];
        
        for (fun in drawFuncs)
        {
            var spr:Sprite = new Sprite();
            _whiteSpr.push(spr);
            _gfx = spr.graphics;
            fun(0xFFFFFFFF, _gfx);
            FlxG.stage.addChild(spr);
        }

        for (i in 0...cols.length)
        {
            for (j in 0...drawFuncs.length)
            {
                var spr:Sprite = new Sprite();
                _layers.push(spr);
                _gfx = spr.graphics;
                var indOffset:Int = (i + j) % cols.length;
                drawFuncs[j](cols[indOffset], _gfx);
                FlxG.stage.addChild(spr);
            }
        }
        
        _curLayerBatch = _layers.length;
        layerCounter = 0;

        poweredBy = new FlxSprite(0, 0);
        poweredBy.loadGraphic("assets/images/poweredby.png");
        poweredBy.x = FlxG.width / 2 - poweredBy.width / 2;
        poweredBy.y = (FlxG.height / 2 - 32 * 2) + 32 * 3;
        add(poweredBy);
        
        // drawMiddle(colGreen);
        // drawTopLeft(colYellow);
        // drawTopRight(colRed);
        // drawBottomLeft(colBlue);
        // drawBottomRight(colLightBlue);

        _camFade = new Bitmap(new BitmapData(stageWidth, stageHeight, true, 0xff000000));
        FlxG.stage.addChild(_camFade);

        // onResize(stageWidth, stageHeight);
        resizeShit(stageWidth, stageHeight);


        #if FLX_SOUND_SYSTEM
			FlxG.sound.load(FlxAssets.getSound("flixel/sounds/flixel")).play();
		#end

        super.create();
    }

    override function destroy() {
        _gfx = null;
        _layers = null;
        cols = null;
        _camFade = null;
        //_curLayerBatch = null;
        //layerCounter = null;
        poweredBy = null;
        drawFuncs = null;

        super.destroy();
    }

    function resizeShit(Width:Int, Height:Int) {
        // super.onResize(Width, Height);

        for (_sprite in _layers)
        {
            _sprite.x = (Width / 2);
            _sprite.y = (Height / 2) - 20 * FlxG.game.scaleY;

            _sprite.scaleX = FlxG.game.scaleX * 1.2;
            _sprite.scaleY = FlxG.game.scaleY * 1.2;
        }

        for (spr in _whiteSpr)
        {
            spr.x = (Width / 2);
            spr.y = (Height / 2) - 20 * FlxG.game.scaleY;

            spr.scaleX = FlxG.game.scaleX * 1.2;
            spr.scaleY = FlxG.game.scaleY * 1.2;
        }
        
    }

    var layerCounter:Int = 0;

    override function update(elapsed:Float) {
        
        if (_curLayerBatch >= 0)
        {
            for (curLayer in Std.int(Math.max(0, _curLayerBatch - 5))..._curLayerBatch)
            {   
                if (_layers[curLayer].alpha > 0.1)
                    _layers[curLayer].alpha -= 0.1 * (elapsed / (1 / 60));
                else
                {
                    _layers[curLayer].alpha = 0;
                    layerCounter++;
                }
            }

            if (layerCounter >= 5)
            {
                layerCounter = 0;
                _curLayerBatch -= 5;
            }
        }

        _logoTimer += elapsed;

        if (_camFade.alpha > 0)
            _camFade.alpha -= elapsed * 0.5;
        

        if (_logoTimer > 2)
        {
            // FlxG.stage.removeChild(_sprite);
            
            poweredBy.kill();

            for (spr in _whiteSpr)
                FlxG.stage.removeChild(spr);

            for (spr in _layers)
                FlxG.stage.removeChild(spr);

            FlxG.stage.removeChild(_camFade);

            FlxG.switchState(new MenuState());
        }

        super.update(elapsed);
    }

    var colGreen:Int = 0xFF00b922;
    var colYellow:Int = 0xFFffc132;
    var colRed:Int = 0xFFf5274e;
    var colBlue:Int = 0xFF3641ff;
    var colLightBlue:Int = 0xFF04cdfb;

    private function drawMiddle(col:Int, gfx:Graphics):Void
    {
        gfx.beginFill(col);
        gfx.moveTo(-1, -37);
        gfx.lineTo(1, -37);
        gfx.lineTo(37, -1);
        gfx.lineTo(37, 1);
        gfx.lineTo(1, 37);
        gfx.lineTo(-1, 37);
        gfx.lineTo(-37, 1);
        gfx.lineTo(-37, -1);
        gfx.lineTo(-1, -37);
        gfx.endFill();
    }

    private function drawTopLeft(col:Int, gfx:Graphics):Void
    {
        gfx.beginFill(col);
        gfx.moveTo(-50, -50);
        gfx.lineTo(-25, -50);
        gfx.lineTo(0, -37);
        gfx.lineTo(-37, 0);
        gfx.lineTo(-50, -25);
        gfx.lineTo(-50, -50);
        gfx.endFill();
    }

    private function drawTopRight(col:Int, gfx:Graphics):Void
    {
        gfx.beginFill(col);
        gfx.moveTo(50, -50);
        gfx.lineTo(25, -50);
        gfx.lineTo(0, -37);
        gfx.lineTo(37, 0);
        gfx.lineTo(50, -25);
        gfx.lineTo(50, -50);
        gfx.endFill();
    }

    private function drawBottomLeft(col:Int, gfx:Graphics):Void
    {
        gfx.beginFill(col);
        gfx.moveTo(-50, 50);
        gfx.lineTo(-25, 50);
        gfx.lineTo(0, 37);
        gfx.lineTo(-37, 0);
        gfx.lineTo(-50, 25);
        gfx.lineTo(-50, 50);
        gfx.endFill();
    }

    private function drawBottomRight(col:Int, gfx:Graphics):Void
    {
        gfx.beginFill(col);
        gfx.moveTo(50, 50);
        gfx.lineTo(25, 50);
        gfx.lineTo(0, 37);
        gfx.lineTo(37, 0);
        gfx.lineTo(50, 25);
        gfx.lineTo(50, 50);
        gfx.endFill();
    }

}