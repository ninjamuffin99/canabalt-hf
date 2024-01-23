package;

import flixel.tile.FlxTilemap;
import flixel.tile.FlxTileblock;


class CBlock extends FlxTilemap
{
    public function new(X:Int, Y:Int, Width:Int, Height:Int, graphic:String, ?tileSize:Int = 16)
    {
        super();
        this.x = X;
        this.y = Y;
        

        exists = true;
        active = true;
        visible = true;
        alive = true;
        scrollFactor.set(1, 1);

        var _tileSize = tileSize ?? 16;

        var widthInTiles:Int = Math.ceil(Width / _tileSize);
        var heightInTiles:Int = Math.ceil(Height / _tileSize);

        //width = widthInTiles * _tileSize;
        //height = heightInTiles * _tileSize;

        var mapData:Array<Int> = [];
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

            mapData.push(index);
        }

        loadMapFromArray(mapData, widthInTiles, heightInTiles, graphic, tileSize, tileSize, null, 0, 0, 0);
    }
}