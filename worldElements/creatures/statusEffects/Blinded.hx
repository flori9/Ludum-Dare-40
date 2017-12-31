package worldElements.creatures.statusEffects;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;

class Blinded extends StatusEffect {
    var goesAwayAfter:Int;

    override function get_modifiersWhileActive() return [Blinded];

    public override function init() {
        name = "Blinded";
        goesAwayAfter = 15;
    }

    public override function onTurn() {
        if (goesAwayAfter <= 0) {
            if (creature.isInterestingForPlayer())
                creature.world.info.addInfo('${creature.getNameToUse()} ${creature.getWereOrWas()} no longer blinded.'.firstToUpper());
            ended = true;
        }
        else
            goesAwayAfter -= 1;
    }

    public override function getText() {
        return 'You can see much less far. Ends after $goesAwayAfter turns.';
    }
}