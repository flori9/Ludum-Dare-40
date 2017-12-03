package items.artifacts;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;
import worldElements.creatures.Creature;

class WingsOfPeace extends Artifact {
    override function get_name() return "Wings of Peace";
    override function get_description() return "They won't let you fly, but you do feel a bit more peaceful. As a result, you lost 1 attack. " + super.description;
    override function get_value() return 700;
    override function get_color() return 0x1DB6C1;

    public override function onTake(creature:Creature) {
        creature.stats.setAttack(creature.stats.attack - 1);
    }
}