package;

import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite {
	
    private var _jump:Float;
	public var jumpLimit:Float;
	public var _onFloor:Bool;
	public var _stumble:Bool;
	private var _my:Float = 0;

	private var _ft:Float;
	private var _fc:Float;
	private var _craneFeet:Bool;

	public var epitaph:String;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/player.png", true, 24, 24);
		width = 12;
		height = 14;

		offset.x = 4;
		offset.y = 10;

		animation.add("run1", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 15);
		animation.add("run2", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 28);
		animation.add("run3", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 40);
		animation.add("run4", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 60);
		animation.add("jump", [16, 17, 18, 19], 12, false);
		animation.add("fall", [20, 21, 22, 23, 24, 25, 26], 14);
		animation.add("stumble1", [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37], 14);
		animation.add("stumble2", [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37], 21);
		animation.add("stumble3", [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37], 28);
		animation.add("stumble4", [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37], 35);

		drag.x = 640;
		acceleration.x = 1;
		acceleration.y = 1200;
		maxVelocity.x = 800;
		velocity.x = 100;
		maxVelocity.y = 300;

        jumpLimit = 0;

		_my = 0;
		_fc = 0;
		_craneFeet = false;

		epitaph = "falling to your death.";

        FlxG.debugger.addTrackerProfile(new TrackerProfile(Player, ["_jump", "jumpLimit", "_onFloor", "_stumble", "_my", "touching"]));
        FlxG.debugger.track(this);
        FlxG.debugger.addTrackerProfile(new TrackerProfile(Controls, ["ka", "kb"]));
        FlxG.debugger.track(Controls);
	}

	override function update(elapsed:Float) {
		
        FlxG.watch.addQuick("touching", touching.toString());
        if (y > 340) {
			alive = false;
			return;
		}

		// Walldeath
		if (acceleration.x <= 0) {
			maxVelocity.y = 1000;
			super.update(elapsed);
			return;
		}

		if (isTouching(FLOOR)) {
			_onFloor = true;
			if (_my > 0.235)
				stumble();

			if (!Controls.ka && !Controls.kb)
                _jump = 0;
            
			    
			_my = 0;
		}
        else 
            _onFloor = false;

        if (isTouching(WALL))
        {
            acceleration.x = velocity.x = 0;
            FlxG.sound.play("assets/sounds/wall.ogg");
            epitaph = "hitting a wall and tumbling to your death.";
        }

		// Speed & acceleration
		if (velocity.x < 0)
			velocity.x = 0;
		if (velocity.x < 100)
			acceleration.x = 50;
		if (velocity.x < 250)
			acceleration.x = 30;
		else if (velocity.x < 400)
			acceleration.x = 20;
		else if (velocity.x < 600)
			acceleration.x = 10;
		else
			acceleration.x = 4;

		// Jumping
		jumpLimit = velocity.x / (maxVelocity.x * 2.5);
		if (jumpLimit > 0.35)
			jumpLimit = 0.35;
		if ((_jump >= 0) && (Controls.ka || Controls.kb)) {
			if (_jump == 0) {
				var rs:Int = FlxG.random.int(0, 3);
				if (rs != 0) {
					FlxG.sound.play("assets/sounds/jump" + rs + ".ogg");
				}
			}
			_jump += elapsed;
			if (_jump > jumpLimit)
				_jump = -1;
		} 
        
        if (Controls.kbR || Controls.kaR)
            _jump = -1;
        
			

		if (_jump > 0) {
            _onFloor = false;
			_craneFeet = false;
			if (_jump < 0.08)
				velocity.y = -maxVelocity.y * 0.65;
			else
				velocity.y = -maxVelocity.y;
		}

		// Animation
		if (_onFloor) {
			// Footsteps
			_ft = (1 - velocity.x / maxVelocity.x) * 0.35;
			if (_ft < 0.15)
				_ft = 0.15;
			_fc += elapsed;
			if (_fc > _ft) {
				_fc = 0;
				if (_craneFeet) {
					FlxG.sound.play("assets/sounds/footc" + FlxG.random.int(1, 4) + ".ogg");
					_craneFeet = false;
				} else
					FlxG.sound.play("assets/sounds/foot" + FlxG.random.int(1, 4) + ".ogg");
			}

			// Stumble / run animations
			if (_stumble && animation.finished)
				_stumble = false;
			if (!_stumble) {
				if (velocity.x < 150)
					animation.play("run1");
				else if (velocity.x < 300)
					animation.play("run2");
				else if (velocity.x < 600)
					animation.play("run3");
				else
					animation.play("run4");
			}
		} else if (velocity.y < -140)
			animation.play("jump");
		else if (velocity.y > -140) {
			animation.play("fall");
			_stumble = false;
		}

		// Update
		if (_onFloor)
			velocity.y = 300;
		// just hit floor?
		super.update(elapsed);
		if (_onFloor)
			velocity.y = 0;

		if (velocity.y == maxVelocity.y)
			_my += FlxG.elapsed;
	}

	public function stumble():Void {
		FlxG.sound.play("assets/sounds/tumble.ogg");
		_stumble = true;
		if (velocity.x > 500)
			animation.play("stumble4", true);
		else if (velocity.x > 300)
			animation.play("stumble3", true);
		else if (velocity.x > 150)
			animation.play("stumble2", true);
		else
			animation.play("stumble1", true);
	}

	public function craneFeet():Void {
		_craneFeet = true;
	}
}
