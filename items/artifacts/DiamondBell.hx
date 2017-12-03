package items.artifacts;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;

class DiamondBell extends Artifact {
    override function get_name() return "Diamond Bell";
    override function get_description() return "All creatures will be aggresive to you. " + super.description;
    override function get_value() return 500;
    override function get_color() return 0xffff00;
    override function makesCreatureAggressive(cr) {
        return true;
    }
}