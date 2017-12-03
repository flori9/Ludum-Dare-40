package worldElements.creatures;

import worldElements.creatures.statusEffects.Poison;

class Rat extends Creature {
    public override function init() {
        super.init();

        color = 0xD9946A;
        character = "r";
        creatureTypeName = "rat";
        stats.setMaxHP(5);
        stats.setMaxAP(1);
        stats.setAttack(1);
        stats.speed = 50;
        actions.push(new worldElements.creatures.actions.AfflictStatusEffect(this, Poison, function(c) return new Poison(c), "{subject} poisoned {object}!", 1));
    }
}