package items.artifacts;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;
import worldElements.creatures.Creature;

using Lambda;

class RatThrone extends Artifact {
    override function get_name() return "Rat Throne";
    override function get_description() return "A tiny yet beautiful throne. You deal 50% less damage to rats. " + super.description;
    override function get_value() return 300;
    override function get_color() return 0xC4AD48;
    override function get_modifiersWhileInInventory() return [HalfDamageToRats];
    
    public override function onTake(creature:Creature) {
        //Make all rat kings aggresive
        creature.world.creatures
            .filter(function(c) return Std.is(c, worldElements.creatures.RatKing))
            .iter(function(ratKing) ratKing.aggressiveToPlayerIfNear = true);
    }
}