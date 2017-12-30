package items;

import worldElements.creatures.Creature;

class Item extends worldElements.creatures.statusModifiers.StatusModifier {
    public var name(get, never):String;
    function get_name() return "";
    public var aOrAnOrThe(get, never):String;
    function get_aOrAnOrThe() return "a";
    public var description(get, never):String;
    function get_description()
        return if (value != 0)
            'Value: $value gold.';
        else
            '';
    public var consumable(get, never):Bool;
    function get_consumable() return false;
    public var useable(get, never):Bool;
    function get_useable() return false;
    public var value(get, never):Int;
    function get_value() return 0;
    public var color(get, never):Int;
    function get_color() return 0xA78D3B;
    public var character(get, never):String;
    function get_character() return "$";
    public var modifiersWhileInInventory(get, never):Array<worldElements.creatures.statusModifiers.SimpleStatusModifier>;
    function get_modifiersWhileInInventory() return [];

    public function new() {
        super();
    }

    public function use(creature:Creature) {
        //No use by default
    }

    public function onTake(creature:Creature) {
        //Nothing by default
    }
}