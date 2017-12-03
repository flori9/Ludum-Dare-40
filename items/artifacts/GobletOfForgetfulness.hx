package items.artifacts;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;

class GobletOfForgetfulness extends Artifact {
    override function get_name() return "Goblet of Forgetfulness";
    override function get_description() return "You won't remember what previously visited parts of the dungeon look like. " + super.description;
    override function get_value() return 200;
    override function get_color() return 0xC6841F;
    override function get_modifiersWhileInInventory() return [Forgetfullness];
}