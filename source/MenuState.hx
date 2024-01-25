package;

import haxe.macro.Compiler;
import haxe.macro.ExprTools;
import haxe.macro.Context;
import io.newgrounds.objects.events.Outcome;
import io.newgrounds.NGLite.LoginOutcome;
import io.newgrounds.NG;
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
        FlxG.mouse.visible = false;
        FlxG.sound.playMusic("assets/music/title" + Main.SOUND_EXT +  "");

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

        Assets.getSound("assets/music/run" + Main.SOUND_EXT +  "");

        super.create();
    }

    function initNG()
    {   

        // somewhat gracefully fallback if there's no API keys stuff
        var api:String = "";
        var enc:String = "";

        var assetList:Array<String> = Assets.list();
        if (assetList.contains("assets/data/ngapi.txt"))
            api = Assets.getText("assets/data/ngapi.txt");

        if (assetList.contains("assets/data/ngenc.txt"))
            enc = Assets.getText("assets/data/ngenc.txt");

        if (api == "" || enc == "")
            return;

        NG.createAndCheckSession(api, true, null);
        NG.core.setupEncryption(enc);

        var notifString:String = "Connected to Newgrounds";

        if (!NG.core.loggedIn)
            notifString += ". Press N to login";

        Notification.instance.genTexts(notifString);
    }
    

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!NG.core?.loggedIn && FlxG.keys.justPressed.N)
        {
            NG.core.requestLogin((callback) -> {
                var notifText:String = callback.getName();
                if (callback.match(Outcome.SUCCESS))
                {
                    notifText = "Connected user: " + NG.core.user.name;
                }
                Notification.instance.genTexts(notifText, 3);
            });
        }

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