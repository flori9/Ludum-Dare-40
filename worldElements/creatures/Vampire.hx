package worldElements.creatures;

import worldElements.creatures.statusEffects.*;

class Vampire extends Creature {
    public override function init() {
        super.init();

        color = 0xff0000;
        character = "v";
        creatureTypeName = "vampire";
        stats.setMaxHP(17);
        stats.setMaxAP(9);
        stats.setAPRegen(5);
        stats.setAttack(5);
        stats.setSpeed(125);
        actions.push(new worldElements.creatures.actions.SpecialDirectionalAttack(this, 0.7, "",
            "{attacker} drank blood from {target} for {damage} damage, healing {attackerReference} by that amount.",
            "{attacker} tried to drink blood from {target}, {butDefended}",
            "Drink Blood", "Drink blood from an enemy, healing you for the damage done.", 5, true,
            function (dmg) stats.gainHP(dmg)));

        creatureAttackVerb = "bit";
        creatureFullAttackVerb = "bite";
        aggressiveToPlayerIfNear = true;
        aggressiveNearDistance = 10;
        initAsHumanoid();

        followTimeWithoutSee = 10;

        isUndead = true;
    }
}