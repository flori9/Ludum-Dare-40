package worldElements.creatures;

import worldElements.creatures.statusEffects.Poison;

class Butterfly extends Creature {
    public override function init() {
        super.init();

        color = 0xAA21BC;
        character = "b";
        creatureTypeName = "gigantic butterfly";
        stats.setMaxHP(4);
        stats.setMaxAP(2);
        stats.setAttack(2);
        stats.setSpeed(125);
        stats.setCritChance(0.1);
        actions.push(new worldElements.creatures.actions.SpecialDirectionalAttack(this, 1.2,
            "",
            "{attacker} licked {target} with {owner} rough tongue for {damage} damage.",
            "{attacker} tried to lick {target} with {owner} rough tongue, {butDefended}",
            "Rough Tounge", "Lick a nearby enemy with your rough tongue.", 2, true));
    }
}