package worldElements.creatures;

import worldElements.creatures.statusEffects.*;

class Wolf extends Creature {
    public override function init() {
        super.init();

        color = 0xABA7A3;
        character = "w";
        creatureTypeName = "wolf";
        stats.setMaxHP(12);
        stats.setMaxAP(6);
        stats.setAttack(5);
        stats.setSpeed(100);
        actions.push(new worldElements.creatures.actions.Dash(this, true));

        creatureAttackVerb = "bit";
        creatureFullAttackVerb = "bite";
        aggressiveToPlayerIfNear = true;
        aggressiveNearDistance = 5;

        followTimeWithoutSee = 5;
    }
}