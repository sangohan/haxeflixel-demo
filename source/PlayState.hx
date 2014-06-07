package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
    private var _player:Player;
    private var _map:FlxOgmoLoader;
    private var _mWalls:FlxTilemap;
    private var _grpCoins:FlxTypedGroup<Coin>;
    private var _grpEnemies:FlxTypedGroup<Enemy>;
    private var _hud:HUD;
    private var _money:Int = 0;
    private var _health:Int = 3;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void {
        _map = new FlxOgmoLoader(AssetPaths.room_002__oel);
        _mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
        _mWalls.setTileProperties(1, FlxObject.NONE);
        _mWalls.setTileProperties(2, FlxObject.ANY);
        add(_mWalls);
        _player = new Player();
        add(_player);
        _grpCoins = new FlxTypedGroup<Coin>();
        add(_grpCoins);
        _grpEnemies = new FlxTypedGroup<Enemy>();
        add(_grpEnemies);

        _map.loadEntities(placeEntities, "entities");

        FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, 1);

        _hud = new HUD();
        add(_hud);

        super.create();
	}

    private function placeEntities(entityName:String, entityData:Xml):Void {
        var x:Int = Std.parseInt(entityData.get("x"));
        var y:Int = Std.parseInt(entityData.get("y"));
        if (entityName == "player") {
            _player.x = x;
            _player.y = y;
        } else if (entityName == "coin") {
            _grpCoins.add(new Coin(x + 4, y + 4));
        } else if (entityName == "enemy") {
            _grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
        }
    }

    private function playerTouchCoin(P:Player, C:Coin):Void {
        if (P.alive && P.exists && C.alive && C.exists) {
            C.kill();
            _money++;
            _hud.updateHUD(_health, _money);
        }
    }

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
        FlxG.collide(_player, _mWalls);
        FlxG.overlap(_player, _grpCoins, playerTouchCoin);
        FlxG.collide(_grpEnemies, _mWalls);
        _grpEnemies.forEachAlive(checkEnemyVision);
	}

    private function checkEnemyVision(e:Enemy):Void {
        if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint())) {
            e.seesPlayer = true;
            e.playerPos.copyFrom(_player.getMidpoint());
        } else {
            e.seesPlayer = false;
        }
    }

}