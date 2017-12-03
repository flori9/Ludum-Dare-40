package items.artifacts;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;

class BeltOfSlowness extends Artifact {
    override function get_name() return "Belt of Slowness";
    override function get_description() return "You will be 20% slower. " + super.description;
    override function get_value() return 500;
    override function get_color() return 0x87C2C4;
    override function get_modifySpeed() return -0.2;
}