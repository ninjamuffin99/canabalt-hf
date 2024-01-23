package;

import flixel.tile.FlxTileblock;


class CBlock extends FlxTileblock
{
    public function new(X:Int, Y:Int, Width:Int, Height:Int, graphic:String, ?tileSize:Int = 16)
    {
        super(X, Y, Width, Height);
        exists = true;
        active = true;
        visible = true;
        alive = true;
        scrollFactor.set(1, 1);

        var _tileSize = tileSize ?? 16;
        loadTiles(graphic, _tileSize, _tileSize);

        var widthInTiles:Int = Math.ceil(width / _tileSize);
        var heightInTiles:Int = Math.ceil(height / _tileSize);
        width = widthInTiles * _tileSize;
        height = heightInTiles * _tileSize;
        var numTiles:Int = widthInTiles * heightInTiles;
        
        var index:Int;

        for (i in 0...numTiles)
        {
            if (i % widthInTiles == 0)
            {
                index = 0;
            }
            else if (i % widthInTiles == widthInTiles - 1)
            {
                index = 2;
            }
            else
                index = 1;

            setTile(i % widthInTiles, Math.floor(i / widthInTiles), index);
        }
    }
}