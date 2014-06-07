package ;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class HUD extends FlxTypedGroup<FlxSprite> {
    private var _sprBack:FlxSprite;
    private var _txtHealth:FlxText;
    private var _txtMoney:FlxText;
    private var _sprHealth:FlxSprite;
    private var _sprMoney:FlxSprite;

    public function new() {
        super();
        _sprBack = new FlxSprite().makeGraphic(FlxG.width, 15, FlxColor.BLACK);
        _sprBack.drawRect(0, 15 - 1, FlxG.width, 1, FlxColor.WHITE);
        _txtHealth = new FlxText(16, 1, 0, "3 / 3", 7);
        _txtHealth.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _txtMoney = new FlxText(0, 1, 0, "0", 7);
        _txtMoney.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
        _sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 5, AssetPaths.health__png);
        _sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 5, AssetPaths.coin__png);
        _txtMoney.alignment = "right";
        _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
        add(_sprBack);
        add(_sprHealth);
        add(_sprMoney);
        add(_txtHealth);
        add(_txtMoney);
        forEach(function(spr:FlxSprite) {
            spr.scrollFactor.set();
        });
    }

    public function updateHUD(Health:Int = 0, Money:Int = 0):Void {
        _txtHealth.text = Std.string(Health) + " / 3";
        _txtMoney.text = Std.string(Money);
        _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
    }
}