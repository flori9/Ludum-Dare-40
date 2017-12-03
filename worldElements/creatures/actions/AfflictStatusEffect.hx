package worldElements.creatures.actions;

import worldElements.creatures.statusEffects.StatusEffect;

using StringTools;

class AfflictStatusEffect extends DirectionAction {
    var statusEffectType:Class<StatusEffect>;
    var makeStatusEffect:Creature->StatusEffect;
    var onAfflictText:String;
    var ap:Int;
    override function get_actionPoints() return ap;

    public function new(creature, statusEffectType:Class<StatusEffect>, makeStatusEffect:Creature->StatusEffect, onAfflictText /*{subject} poisoned {object}!*/:String,
        ap:Int) {
        super(creature);

        this.statusEffectType = statusEffectType;
        this.makeStatusEffect = makeStatusEffect;
        this.onAfflictText = onAfflictText;
        this.ap = ap;
    }

    public override function canUseOnElement(elementHere:WorldElement) {
        return Std.is(elementHere, Creature) && !(cast elementHere:Creature).statusEffects.any(function (se) return Std.is(se, statusEffectType));
    }

    public override function useOnElement(elementHere:WorldElement) {
        var creatureHere:Creature = cast elementHere;
        creatureHere.addStatusEffect(makeStatusEffect(creatureHere));
        if (creature.isInterestingForPlayer() || creatureHere.isInterestingForPlayer()) {
            creature.world.info.addInfo(onAfflictText.replace("{subject}", creature.getNameToUse()).replace("{object}", creatureHere.getNameToUse()).firstToUpper());
        }
    }
}