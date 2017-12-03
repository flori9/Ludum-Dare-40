package items.artifacts;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;

class UnclearGlasses extends Artifact {
    override function get_name() return "Unclear Glasses";
    override function get_description() return "You'll be able to see less far. " + super.description;
    override function get_value() return 300;
    override function get_color() return 0xe0e0e0;
    override function get_modifiersWhileInInventory() return [WorseSight];
}