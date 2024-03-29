package ;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
/**
 * ...
 * @author ...
 */
class Coin extends FlxSprite {

        public function new(X:Float=0, Y:Float=0) {
            super(X, Y);
            loadGraphic(AssetPaths.coin__png, false, 8, 8);
        }

        override public function kill():Void {
            alive = false;
            FlxTween.tween(this, { alpha:0, y:y - 16 }, .33, {type:FlxTween.ONESHOT,  ease:FlxEase.circOut, complete:finishKill } );
        }

        private function finishKill(_):Void {
            exists = false;
        }
}