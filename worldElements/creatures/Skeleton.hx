package worldElements.creatures;

import worldElements.creatures.statusEffects.*;

class Skeleton extends Creature {
    public override function init() {
        super.init();

        color = 0xd0d0d0;
        character = "s";
        creatureTypeName = "skeleton";
        stats.setMaxHP(12);
        stats.setMaxAP(5);
        stats.setAttack(5);
        stats.setSpeed(50);
        actions.push(new worldElements.creatures.actions.RangedSpecialDirectionalAttack(this, 0.6, "{attacker} threw a bone at {target}. It was a critical hit for {damage} damage.",
            "{attacker} threw a bone at {target} for {damage} damage.", "{attacker} threw a bone at {target}, {butDefended}", "Throw Bone", "Throw a bone in a direction, dealing damage from up to five squares away from an enemy.", 2, 5));
        actions.push(new worldElements.creatures.actions.AfflictStatusEffect(this, Slowed, function(c) return new Slowed(c), "{subject} slowed {object} with its deadly breath!", 3,
            "Breathe Death", "Slow an enemy next to you."));

        creatureAttackVerb = "hit";
        creatureFullAttackVerb = "hit";
        aggressiveToPlayerIfNear = true;
        aggressiveNearDistance = 5;
        initAsHumanoid();
        isUndead = true;
    }
}