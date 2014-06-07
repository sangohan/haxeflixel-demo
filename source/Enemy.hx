package ;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;

/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite {
    public var speed:Float = Player.speed - 10;
    public var etype(default, null):Int;
    public var seesPlayer:Bool = false;
    public var playerPos(default, null):FlxPoint;

    private var _brain:FSM;
    private var _idleTmr:Float;
    private var _moveDir:Float;

    public function new(X:Float=0, Y:Float=0, etype:Int) {
        super(X, Y);
        this.etype = etype;
        switch (etype) {
            case 0:
		        loadGraphic(AssetPaths.enemy_0__png, true, 16, 16);
            case 1:
		        loadGraphic(AssetPaths.enemy_1__png, true, 16, 16);
            default:
                throw "unknown enemy type " + etype;
        }
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add("lr", [3, 4, 3, 5], 6, false);
        animation.add("d", [0, 1, 0, 2], 6, false);
        animation.add("u", [6, 7, 6, 8], 6, false);
        drag.x = drag.y = 1600;
        setSize(8, 14);
        offset.set(4, 2);

        _brain = new FSM(idle);
        _idleTmr = 0;
        playerPos = FlxPoint.get();
    }

    override public function update():Void  {
		_brain.update();
		super.update();
	}

    public function idle():Void {
		if (seesPlayer) {
			_brain.activeState = chase;
		} else if (_idleTmr <= 0) {
			if (FlxRandom.chanceRoll(1)) {
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			} else {
				_moveDir = FlxRandom.intRanged(0, 8) * 45;
				FlxAngle.rotatePoint(speed * .5, 0, 0, 0, _moveDir, velocity);

			}
			_idleTmr = FlxRandom.intRanged(1, 4);
		} else {
			_idleTmr -= FlxG.elapsed;
        }

	}

    public function chase():Void {
        if (!seesPlayer) {
            _brain.activeState = idle;
        } else {
            FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
        }
    }

    override public function draw():Void {
        if ((velocity.x != 0 || velocity.y != 0 ) && touching == FlxObject.NONE) {
            if (Math.abs(velocity.x) > Math.abs(velocity.y)) {
                if (velocity.x < 0)
                    facing = FlxObject.LEFT;
                else
                    facing = FlxObject.RIGHT;
            } else {
                if (velocity.y < 0)
                    facing = FlxObject.UP;
                else
                    facing = FlxObject.DOWN;
            }

            switch(facing)
            {
                case FlxObject.LEFT, FlxObject.RIGHT:
                    animation.play("lr");

                case FlxObject.UP:
                    animation.play("u");

                case FlxObject.DOWN:
                    animation.play("d");
            }
        }
        super.draw();
    }

}