package worldElements.creatures;

import worldElements.creatures.statusEffects.*;

class FlyingEye extends Creature {
    public override function init() {
        super.init();

        color = 0xffc0c0;
        character = "e";
        creatureTypeName = "flying eye";
        stats.setMaxHP(16);
        stats.setMaxAP(10);
        stats.setAttack(4);
        stats.setSpeed(100);
        var text = "{attacker} looked deep into {target} for weaknesses, making {attackerReference} stronger.".firstToUpper();
        actions.push(new worldElements.creatures.actions.SpecialDirectionalAttack(this, 0.0, "",
            text,
            text,
            "Look for Weakness", "Look deep into an enemy for weaknesses. This increases your attack by 1.", 10, true,
            function (dmg) stats.setAttack(stats.attack + 1)));

        creatureAttackVerb = "hit";
        creatureFullAttackVerb = "hit";
        aggressiveToPlayerIfNear = true;
        aggressiveNearDistance = 100;

        followTimeWithoutSee = 10000;

        isUndead = false;
    }
}