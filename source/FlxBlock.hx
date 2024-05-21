package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;

class FlxBlock extends FlxTilemap
{
	public function new(X:Float, Y:Float, Width:Float, Height:Float)
	{
		super();
		x = X;
		y = Y;
		width = Width;
		height = Height;
	}

	public function loadTiles(graphic:String, TileWidth:Int, TileHeight:Int, Empties:Int = 0, AutoTile:Int = 0):FlxBlock
	{
		widthInTiles = Math.floor(width / TileWidth);
		heightInTiles = Math.floor(height / TileHeight);
		var spr:FlxSprite = new FlxSprite().loadGraphic(graphic);
		var diffTiles:Int = Std.int(spr.width / TileWidth) * Std.int(spr.height / TileHeight);
		var numTiles:Int = widthInTiles * heightInTiles;
		var mapData:Array<Int> = [for (i in 0...numTiles) FlxG.random.int(0, diffTiles - 1)];

		loadMapFromArray(mapData, widthInTiles, heightInTiles, graphic, TileWidth, TileHeight, null, 0, 0, 0);

		return this;
	}
}
