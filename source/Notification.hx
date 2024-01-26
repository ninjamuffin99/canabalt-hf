package;

import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class Notification extends FlxTypedGroup<FlxText>
{
    public static var instance(get, default):Notification;

    static function get_instance():Notification
    {   
        if (instance == null)
        {
            instance = new Notification();
        }

        if (!FlxG.state.members.contains(instance))
        {
            FlxG.state.add(instance);
        }
        else
        {
            FlxG.state.members.remove(instance);
            FlxG.state.add(instance); // always move it to the top?
        }
        
        return instance;
    }

    public function new()
    {
        super();
    }

    override function update(elapsed:Float) {
        
        if (FlxG.state.members[FlxG.state.members.length - 1] != this)
        {
            FlxG.state.members.remove(this);
            FlxG.state.add(this);
        }

        super.update(elapsed);
    }

    public function genTexts(text:String, notifTime:Float = 1.2, location:NotificationLocation = TOP_LEFT)
    {   

        var txt:FlxText = new FlxText(2, 1, 0, text, 8);
        txt.color = 0xFF35353d;
        // txt.alignment = CENTER;
        txt.scrollFactor.x = txt.scrollFactor.y = 0;
        add(txt);

        var txt2:FlxText = new FlxText(1, 1, 0, text, 8);
        txt2.color = 0xFF35353d;
        // txt2.alignment = CENTER;
        txt2.scrollFactor.x = txt2.scrollFactor.y = 0;
        add(txt2);

        var txt3:FlxText = new FlxText(2, 0, 0, text, 8);
        // txt3.alignment = CENTER;
        txt3.scrollFactor.x = txt3.scrollFactor.y = 0;
        add(txt3);

        for (i in members.length - 3...members.length)
        {   
            var txtMember:FlxText = members[i];
            txtMember.y = switch(location)
            {
                case TOP_LEFT:
                    -8 + txtMember.y;
                case BOTTOM_LEFT:
                    FlxG.height + txtMember.y;
                case _:
                    -8 + txtMember.y;
            
            }

            var tweenLocation:Float = switch(location)
            {
                case TOP_LEFT:
                    txtMember.y + 10;
                case BOTTOM_LEFT:
                    txtMember.y - 2 - txtMember.height;
                case _:
                    txtMember.y + 10;
            
            }

            FlxTween.tween(txtMember, {y: tweenLocation}, notifTime, {ease: FlxEase.quartOut, onComplete: _ -> {
                txtMember.kill();
                remove(txtMember, true);
                txtMember.destroy();
            }});
        }
        
    }
}

enum NotificationLocation
{
    TOP_LEFT;
    BOTTOM_LEFT;
}