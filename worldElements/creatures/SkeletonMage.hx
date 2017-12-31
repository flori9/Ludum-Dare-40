package worldElements.creatures;

import worldElements.creatures.statusEffects.*;

class SkeletonMage extends Skeleton {
    public override function init() {
        super.init();

        color = 0xC299D8;
        creatureTypeName = "skeleton mage";
        stats.setMaxHP(14);
        stats.setMaxAP(7);
        stats.setAttack(4);
        stats.setSpeed(66);
        actions = [];
        actions.push(new worldElements.creatures.actions.AfflictStatusEffect(this, Blinded, function(c) return new Blinded(c),
            "{subject} temporarily blinded {object} with a magical flash of light!", 2,
            "Flash of Light", "Blind an enemy next to you."));
        actions.push(new worldElements.creatures.actions.RangedSpecialDirectionalAttack(this, 1.2,
            "{attacker} pushed a magical bolt to {target}. It was a critical hit for {damage} damage.",
            "{attacker} pushed a magical bolt to {target} for {damage} damage.",
            "{attacker} pushed a magical bolt to {target}, {butDefended}",
            "Magical Bolt", "Push a magical bolt in a direction, dealing damage from up to six squares away from an enemy.", 3, 6));
        aggressiveToPlayerIfNear = true;
        aggressiveNearDistance = 8;
        followTimeWithoutSee = 5;
    }
}