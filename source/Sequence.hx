package;

import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.tile.FlxTileblock;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;

class Sequence extends FlxObject {
	public var blocks:FlxGroup;
	public var roof:Bool = false;

	private var _tileSize:Int = 16;
	private var _layer:FlxGroup;
	private var _seq:Sequence;
	private var _player:Player;
	private var _shardsA:FlxTypedGroup<Shard>;
	private var _shardsB:FlxTypedGroup<Shard>;

	public static var nextIndex:Int = 0;
	public static var nextType:Int = 0;
	public static var curIndex:Int = 0;

	public function new(player:Player, shardsA:FlxTypedGroup<Shard>, shardsB:FlxTypedGroup<Shard>) {
		super();

		_player = player;
		_shardsA = shardsA;
		_shardsB = shardsB;
		x = 0;
		y = 0;
		width = 0;
		height = 0;

		_layer = new FlxGroup();
		blocks = new FlxGroup();
		roof = false;
	}

	public function init(seq:Sequence):Void {
		_seq = seq;
		resetSeq();
	}

	override function update(elapsed:Float) {
		if (getScreenPosition().x + width < 0)
			resetSeq();

		super.update(elapsed);
		_layer.update(elapsed);
	}

	override function draw() {
		super.draw();
		blocks.draw();
		_layer.draw();
	}

	public function resetSeq():Void {
		clearSeq();

		var wallPath:String = "assets/images/wall" + FlxG.random.int(1, 4) + ".png";
		var windowPath:String = "assets/images/window" + FlxG.random.int(1, 4) + ".png";

		var type:StructureType = ROOF;
		var types:Array<StructureType> = [HALLWAY, CRANE];

		if (curIndex == nextIndex) {
			type = types[nextType];
			nextIndex += FlxG.random.int(3, 8);
			nextType = FlxG.random.int(0, types.length - 1);
		}
		type = CRANE; // DEBUG: force all buildings to specific type

		// The first two buildings are special
		if (curIndex == 0) {
			x = -4 * _tileSize;
			y = 5 * _tileSize;
			width = 60 * _tileSize;
			height = 320 - y;
			type = HALLWAY;
		} else if (curIndex == 1) {
			x = _seq.x + _seq.width + 8 * _tileSize;
			y = 15 * _tileSize;
			height = 320 - y;
			width = 42 * _tileSize;
		}

		// Calculate a base hallheight (useful for stuff later)
		var hallHeight:Int = 0;
		if (type == HALLWAY) {
			if (_player.velocity.x > 640)
				hallHeight = 6;
			else if (_player.velocity.x > 480)
				hallHeight = 5;
			else if (_player.velocity.x > 320)
				hallHeight = 4;
			else
				hallHeight = 3;
		}

		// Figure out building position and dimensions
		var mainBlock:FlxTileblock;
		var screenTiles:Int = Std.int(FlxG.width / _tileSize + 2);
		var maxGap:Int = Std.int(((_player.velocity.x * 0.75) / _tileSize) * 0.75);
		var minGap:Int = Std.int(maxGap * 0.4);
		var fg:Float = FlxG.random.float(0, 1);
		var gap:Int = Std.int(minGap + fg * (maxGap - minGap));

		if ((type == HALLWAY) && (gap > 12))
			gap = 12;

		var minW:Int = screenTiles - gap;
		if ((_player.velocity.x < _player.maxVelocity.x * 0.8) && (minW < 12))
			minW = 12;
		else if (minW < 6)
			minW = 6;

		var maxW:Int = minW * 2;
		var maxJ:Int = Std.int(_seq.y / _tileSize - 2 - hallHeight);
		var mpj:Int = Std.int(6 * _player.jumpLimit / 0.35);

		if (maxJ > mpj)
			maxJ = mpj;
		if (maxJ > 0)
			maxJ = Math.ceil(maxJ * (1 - fg));

		var maxDrop:Int = Std.int(_seq.height / _tileSize - 1);
		if (maxDrop > 10)
			maxDrop = 10;

		if (curIndex > 1) {
			x = _seq.x + _seq.width + gap * _tileSize;
			var drop:Int = FlxG.random.int(0, Std.int(maxDrop - maxJ));
			if (drop == 0)
				drop--;
			y = _seq.y + drop * _tileSize;
			height = 320 - y;
			width = Math.floor(FlxG.random.float(minW, maxW + minW)) * _tileSize;
		}

		// 1 - If collapsing is likely going to kill the player, just don't do it
		// 2 - Only bomb roofs that are pretty wide
		// 3 - Don't put cranes right on the very bottom, that's dumb
		if (((type == COLLAPSE) && (width / height > _player.velocity.x / 75))
			|| ((type == BOMB) && (width < _player.velocity.x))
			|| ((type == CRANE) && ((height < 32) || (width < 400)))) {
			type = ROOF;
			nextIndex = curIndex + 1;
		}

		// Make sure crane is on 32s
		if (type == CRANE) {
			width = Std.int(width / 32); // round it to 32s
			width *= 32;
		}

		mainBlock = new FlxTileblock(Std.int(x), Std.int(y), Std.int(width + 8), Std.int(height));
		mainBlock.makeGraphic(Std.int(mainBlock.width), Std.int(mainBlock.height), 0xff000000);
		blocks.add(mainBlock);

		var b:Bomb;
		var f:FlxEmitter;

		if ((type == ROOF) || (type == COLLAPSE) || (type == BOMB)) {
			if (y > _seq.y) {
				var antenna:FlxSprite = new FlxSprite(x + _tileSize, y - 128);
				antenna.loadGraphic("assets/images/antenna" + FlxG.random.int(0, 6) + ".png");
				_layer.add(antenna);
			}

			var rt:Float = FlxG.random.float();
			var rw:Int;
			var rh:Int;
			if (rt < 0.2)
				decorate(Std.int(x), Std.int(y), Std.int(width));
			else if (rt < 0.6) {
				// BLOCK ROOF:
				var indent:Int = Std.int(2 + FlxG.random.float(0, (width / _tileSize) / 4));
				rw = Std.int(width / _tileSize - indent * 2);
				rh = FlxG.random.int(1, 5);

				if (rh > 2) {
					var block:FlxTileblock = new FlxTileblock(Std.int(x + indent * _tileSize), Std.int(y - rh * _tileSize), Std.int(rw * _tileSize),
						Std.int((rh - 1) * _tileSize));
					block.loadTiles("assets/images/block.png", _tileSize, _tileSize);
					_layer.add(block);

					var block1:FlxTileblock = new FlxTileblock(Std.int(x + (indent + 1) * _tileSize), Std.int(y - _tileSize), Std.int((rw - 2) * _tileSize),
						Std.int(_tileSize));
					block1.loadTiles("assets/images/block.png", _tileSize, _tileSize);
					_layer.add(block1);
				} else {
					var block:FlxTileblock = new FlxTileblock(Std.int(x + indent * _tileSize), Std.int(y - rh * _tileSize), Std.int(rw * _tileSize),
						Std.int(rh * _tileSize));
					block.loadTiles("assets/images/block.png", _tileSize, _tileSize);
					_layer.add(block);
				}
				decorate(Std.int(x + indent * _tileSize), Std.int(y - rh * _tileSize), Std.int(rw * _tileSize));
			} else {
				// SLOPE ROOF
				rh = FlxG.random.int(1, 5);
				if (width < 12 * _tileSize)
					rh = 1;

				for (i in 0...Std.int(rh))
					_layer.add(new CBlock(Std.int(x + (1 + i) * _tileSize), Std.int(y - (i + 1) * _tileSize), Std.int(width - 2 * (i + 1) * _tileSize),
						_tileSize, "assets/images/slope.png"));

				decorate(Std.int(x + rh * _tileSize), Std.int(y - rh * _tileSize), Std.int(width - 2 * (rh + 1) * _tileSize));
			}
		}

		// Add graphics for the wall and roof
		if (type == CRANE) {
			_layer.add(new CraneTrigger(x, y - 32, width, 32, _player));
			_layer.add(new CBlock(Std.int(x), Std.int(y), Std.int(width), 32, "assets/images/crane1.png", 32));
			var left:Bool = FlxG.random.bool();
			var cx:Int = Std.int(width * 0.35);
			if (cx < 128)
				cx = 128;

			if (left) {
				_layer.add(new FlxTileblock(Std.int(x + cx), Std.int(y + 32), 32, Std.int(height - 32)).loadTiles("assets/images/crane2.png", 32, 32));
				_layer.add(new FlxSprite(x + 8, y + 4).loadGraphic("assets/images/crane3.png"));
				// antennas
				_layer.add(new FlxSprite(x - 8, y - 128).loadGraphic("assets/images/antenna5.png"));
				_layer.add(new FlxSprite(x + cx - 8, y - 128).loadGraphic("assets/images/antenna5.png"));
				_layer.add(new FlxSprite(x + width - 24, y - 128).loadGraphic("assets/images/antenna5.png"));

				_layer.add(new FlxSprite(x + cx - 8, y - 9).loadGraphic("assets/images/crane4.png")); // cabin
				_layer.add(new FlxSprite(x + cx + FlxG.random.float(0, width - cx - 64), y + 20).loadGraphic("assets/images/crane5.png")); // pulley
			} else {

				_layer.add(new FlxTileblock(Std.int(x + width - cx - 32), Std.int(y + 32), 32, Std.int(height - 32)).loadTiles("assets/images/crane2.png", 32, 32)); // post
				_layer.add(new FlxSprite(x + width - 72, y + 4).loadGraphic("assets/images/crane3.png")); // counterweight
				// antennas
				_layer.add(new FlxSprite(x - 8, y - 128).loadGraphic("assets/images/antenna5.png"));
				_layer.add(new FlxSprite(x + width - cx - 24, y - 128).loadGraphic("assets/images/antenna5.png"));
				_layer.add(new FlxSprite(x + width - 24, y - 128).loadGraphic("assets/images/antenna5.png"));

				// cabin
				var cs:FlxSprite = new FlxSprite(x + width - cx - 40, y - 9);
				cs.loadGraphic("assets/images/crane4.png");
				cs.flipX = true;
				_layer.add(cs);

				_layer.add(new FlxSprite(x + FlxG.random.float(0, width - cx - 128), y + 20).loadGraphic("assets/images/crane5.png"));

			}
		} else {
			if (type == HALLWAY)
				_layer.add(new CBlock(Std.int(x), Std.int(y), Std.int(width), _tileSize, "assets/images/floor" + FlxG.random.int(1, 2) + ".png"));
			else
				_layer.add(new CBlock(Std.int(x), Std.int(y), Std.int(width), _tileSize, "assets/images/roof" + FlxG.random.int(1, 5) + ".png"));

			_layer.add(new CBlock(Std.int(x), Std.int(y + _tileSize), Std.int(width), Std.int(height - _tileSize), wallPath));

			// if collaps

			for (i in 0...Std.int((height / _tileSize - 1) / 2))
				_layer.add(new FlxTileblock(Std.int(x + _tileSize), Std.int(y + (2 + i * 2) * _tileSize), Std.int(width - 2 * _tileSize),
					_tileSize).loadTiles(windowPath, _tileSize, _tileSize));
		}

		if (type != HALLWAY) {
			// Doves!
			if (FlxG.random.bool(35)) {
				for (i in 0...Std.int((width / 120) * (FlxG.random.float(2, 14))))
					_layer.add(new Dove(x + FlxG.random.int(0, Std.int(width - 8)), y - 8, _player, Std.int(x)));
			}
		}

		if (type == BOMB) {}

		if (type == COLLAPSE) {} else if ((type == ROOF) && (curIndex > 1)) {
			// Normal rooftops should sometimes get some obstacles if you're not going too fast
			for (i in 0...3) {
				if (FlxG.random.bool(15))
					_layer.add(new Obstacle(x + width / 8 + FlxG.random.float(0, (width / 2)), y, _player, true));
			}
		}

		// Hallways get a lot of special treatment - special obstacles, doors, windows, etc.
		if (type == HALLWAY) {
			hallHeight *= _tileSize;
			var blockRoof:FlxTileblock = new FlxTileblock(Std.int(x), -128, Std.int(width), Std.int(y - hallHeight + 128));
			blockRoof.makeGraphic(Std.int(blockRoof.width), Std.int(blockRoof.height), 0xffCC00CC);
			blocks.add(blockRoof);

			_layer.add(new CBlock(Std.int(x), 0, Std.int(width), Std.int(y - hallHeight), wallPath));

			_layer.add(new CBlock(Std.int(x), Std.int(y - _tileSize), Std.int(width), _tileSize, "assets/images/hall1.png"));
			_layer.add(new CBlock(Std.int(x), Std.int(y - 2 * _tileSize), Std.int(width), _tileSize, "assets/images/hall2.png"));
			_layer.add(new FlxSprite(x, y - hallHeight).makeGraphic(Std.int(width), Std.int(hallHeight - 2 * _tileSize), 0xFF35353d));

			_layer.add(new Window(x + width - Window.w - 1, y, hallHeight, _layer, _player, _shardsA));
			_layer.add(new Window(x + 1, y, hallHeight, _layer, _player, _shardsB));

			for (i in 1...Std.int((width / _tileSize - 3) / 4)) {
				if (FlxG.random.bool(65)) {
					var door:FlxSprite = new FlxSprite(x + i * _tileSize * 4 - _tileSize, y - 19).loadGraphic("assets/images/doors.png", true, 12, 19);
					door.frame = door.frames.frames[FlxG.random.int(0, 3)];
					_layer.add(door);
				}
			}

			if (curIndex == 0) {
				_layer.add(new Obstacle(32 * _tileSize, y, _player));
				_layer.add(new Obstacle(48 * _tileSize, y, _player));
			} else {
				for (i in 0...3) {
					if (FlxG.random.bool(65))
						_layer.add(new Obstacle(x + width / 8 + FlxG.random.float(0, (width / 2)), y, _player));
				}
			}
		}

		curIndex++;
	}

	private function decorate(seqX:Int, seqY:Int, seqWidth:Int):Void {
		var s:Int;

		// AC boxes
		s = 40;
		for (i in 0...Std.int(seqWidth / s)) {
			if (FlxG.random.bool(30)) {
				var ac:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - _tileSize);
				ac.loadGraphic("assets/images/ac.png");
				_layer.add(ac);
			}
		}

		if (FlxG.random.bool()) {
			// Pipes roof
			s = 100;
			for (i in 0...Std.int(seqWidth / s)) {
				if (FlxG.random.bool(35)) {
					var pipe1:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - _tileSize);
					pipe1.loadGraphic("assets/images/pipe1.png");
					_layer.add(pipe1);
				}
			}

			s = 70;
			for (i in 0...Std.int(seqWidth / s)) {
				if (FlxG.random.bool(35)) {
					var pipe2:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - _tileSize * 2);
					pipe2.loadGraphic("assets/images/pipe2.png");
					_layer.add(pipe2);
				}
			}

			if (FlxG.random.bool()) {
				// Antennas!!
				s = 16;
				for (i in 0...Std.int((seqWidth - 32) / s)) {
					if (FlxG.random.bool(30)) {
						var antenna:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - 128);
						antenna.loadGraphic("assets/images/antenna" + FlxG.random.int(0, 6) + ".png");
						_layer.add(antenna);
					}
				}
			}
		} else {
			// Skylights, rooft access + reservoirs
			s = 140;
			var n:Int = Std.int(seqWidth / s);

			for (i in 0...n) {
				if (FlxG.random.bool()) {
					var skylight:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - _tileSize + 1);
					skylight.loadGraphic("assets/images/skylight.png");
					_layer.add(skylight);
				}
			}

			s = 200;
			n = Std.int(seqWidth / s);

			for (i in 0...n) {
				if (FlxG.random.bool(25)) {
					var access:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - 24);
					access.loadGraphic("assets/images/access.png");
					_layer.add(access);
				}
			}

			s = 200;
			n = Std.int(seqWidth / s);

			for (i in 0...n) {
				if (FlxG.random.bool()) {
					var reservoir:FlxSprite = new FlxSprite(seqX + _tileSize + s * i, seqY - _tileSize * 6);
					reservoir.loadGraphic("assets/images/reservoir.png");
					_layer.add(reservoir);
				}
			}
		}

		if (FlxG.random.bool(40)) {
			// Add chainlink fences
			var fence:FlxTileblock = new FlxTileblock(seqX + 32, seqY - 32, Std.int((seqWidth / 32 - 1) * 32), 32);
			fence.loadTiles("assets/images/fence.png", 32, 32);
			_layer.add(fence);
		}
	}

	public function clearSeq():Void {
		_layer.clear();
		blocks.clear();
	}
}

enum abstract StructureType(String) {
	var ROOF = "roof";
	var HALLWAY = "hallway";
	var COLLAPSE = "collapse";
	var BOMB = "bomb";
	var CRANE = "crane";
}
