package worldElements.creatures;

import worldElements.creatures.statusEffects.SplitOnByGoblin;

class Goblin extends Creature {
    public override function init() {
        super.init();

        color = 0x818F28;
        character = "g";
        creatureTypeName = "goblin";
        stats.setMaxHP(8);
        stats.setMaxAP(3);
        stats.setAttack(2);
        actions.push(new worldElements.creatures.actions.AfflictStatusEffect(this, SplitOnByGoblin,
            function(c) return new SplitOnByGoblin(c), "{subject} spit on {object}, making all goblins aggressive to {shortObject}!", 3,
            "Spit", "Spit on an enemy next to you, making all goblins aggressive to it."));

        creatureAttackVerb = "hit";
        creatureFullAttackVerb = "hit";
        aggressiveToPlayerIfNear = true;
        initAsHumanoid();
    }
}