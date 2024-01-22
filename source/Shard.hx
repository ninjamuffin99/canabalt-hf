package;

import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;

class Shard extends FlxParticle
{   
    public function new()
    {
        super();
        x = -100;
        y = -100;
        makeGraphic(FlxG.random.int(1, 5), FlxG.random.int(1, 5));
    }

    override function update(elapsed:Float) {
        
        if (justTouched(FLOOR))
        {
            if ((width*height > 6) && (velocity.y > 150))
            {
                FlxG.sound.play("assets/sounds/glass" + FlxG.random.int(1, 2) + ".ogg", 0.5);
                velocity.y = -velocity.y * 0.35;
                velocity.x *= 0.65;

                // used in og canabalt source, 
                // I'm too lazy to figure out the FlxG.random math equivalent!
                angularVelocity = Math.random() * 1140 - 720; 
            }
        }

        if (y > FlxG.height * 2) exists = false;

        super.update(elapsed);
    }
}