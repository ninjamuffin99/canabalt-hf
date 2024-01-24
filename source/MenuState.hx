package;

import flixel.system.scaleModes.PixelPerfectScaleMode;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class MenuState extends FlxState
{
    var _title:FlxSprite;
    var _title2:FlxSprite;
    var _title3:FlxSprite;

    override public function create()
    {   
        FlxG.fixedTimestep = false;
        FlxG.camera.bgColor = 0xff35353d;
        FlxSprite.defaultAntialiasing = false;
        FlxG.mouse.load("assets/images/cursor.png", 2);
        FlxG.sound.playMusic("assets/music/title" + Main.SOUND_EXT +  "");

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

        Assets.getSound("assets/music/run" + Main.SOUND_EXT +  "");

        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if ((_title.velocity.y >= 0) && (_title2.alpha < 1))
            _title2.alpha += elapsed;

        if((_title.velocity.y == 0) && (_title2.alpha < 1))
            _title2.alpha += FlxG.elapsed;

        if((_title2.alpha >= 1) && (_title3.alpha < 1))
            _title3.alpha += FlxG.elapsed/2;

        if (Controls.kb || Controls.ka)
        {
            FlxG.switchState(new PlayState());
            FlxG.sound.playMusic("assets/music/run" + Main.SOUND_EXT +  "");
        }
    }
}