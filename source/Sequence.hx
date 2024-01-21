package;

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
	private var _shardsA:FlxGroup;
	private var _shardsB:FlxGroup;

	public static var nextIndex:Int = 0;
	public static var nextType:Int = 0;
	public static var curIndex:Int = 0;

	public function new(player:Player, shardsA:FlxGroup, shardsB:FlxGroup) {
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
        if (_player.getScreenPosition().x + width < 0) resetSeq();

        super.update(elapsed);
        _layer.update(elapsed);
    }

    override function draw() {
        super.draw();
        _layer.draw();
        blocks.draw();
    }

	public function resetSeq():Void {
		clearSeq();
		_layer = new FlxGroup();

		var type:StructureType = ROOF;
		var types:Array<StructureType> = [HALLWAY, COLLAPSE, BOMB, CRANE];

		if (curIndex == nextIndex) {
			type = types[nextType];
			nextIndex += FlxG.random.int(3, 8);
			nextType = FlxG.random.int(0, types.length - 1);
		}
		// type = CRANE; // DEBUG: force all buildings to specific type

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
        if( ((type == COLLAPSE) && (width / height > _player.velocity.x / 75)) || ((type == BOMB) && (width < _player.velocity.x)) ||
            ((type == CRANE) && ((height < 32) || (width < 400))) )
        {
            type = ROOF;
            nextIndex = curIndex + 1;
        }

        // Make sure crane is on 32s
        if (type == CRANE)
        {
            width = Std.int(width * 32); // round it to 32s
            width *= 32;
        }

        mainBlock = new FlxTileblock(Std.int(x), Std.int(y), Std.int(width + 8), Std.int(height));
        mainBlock.makeGraphic(Std.int(mainBlock.width), Std.int(mainBlock.height), 0xff000000);
        blocks.add(mainBlock);
	}

	public function clearSeq():Void {
		_layer.kill();
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
