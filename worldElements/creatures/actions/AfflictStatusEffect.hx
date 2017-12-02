package worldElements.creatures.actions;

import worldElements.creatures.statusEffects.StatusEffect;

using StringTools;

class AfflictStatusEffect extends DirectionAction {
    var statusEffectType:Class<StatusEffect>;
    var makeStatusEffect:Void->StatusEffect;
    var onAfflictText:String;

    public function new(creature, statusEffectType:Class<StatusEffect>, makeStatusEffect:Void->StatusEffect, onAfflictText /*{subject} poisoned {object}!*/:String) {
        super(creature);

        this.statusEffectType = statusEffectType;
        this.makeStatusEffect = makeStatusEffect;
        this.onAfflictText = onAfflictText;
    }

    public override function canUseOnElement(elementHere:WorldElement) {
        return Std.is(elementHere, Creature) && !(cast elementHere:Creature).statusEffects.any(function (se) return Std.is(se, statusEffectType));
    }

    public override function useOnElement(elementHere:WorldElement) {
        var creatureHere:Creature = cast elementHere;
        if (creature.isInterestingForPlayer() || creatureHere.isInterestingForPlayer()) {
            creatureHere.addStatusEffect(makeStatusEffect());
            creature.world.info.addInfo(onAfflictText.replace("{subject}", creature.getNameToUse()).replace("object", creatureHere.getNameToUse()).firstToUpper());
        }
    }
}