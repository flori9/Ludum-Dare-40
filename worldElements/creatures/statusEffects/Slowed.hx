package worldElements.creatures.statusEffects;

class Slowed extends StatusEffect {
    var goesAwayAfter:Int;
    override function get_modifySpeed() return -0.25;

    public override function init() {
        name = "Slowed";
        goesAwayAfter = 30;
    }

    public override function onTurn() {
        if (goesAwayAfter <= 0) {
            if (creature.isInterestingForPlayer())
                creature.world.info.addInfo('${creature.getNameToUse()} ${creature.getWereOrWas()} no longer slowed.'.firstToUpper());
            ended = true;
        }
        else
            goesAwayAfter -= 1;
    }

    public override function getText() {
        return 'You are 25% slower. Ends after $goesAwayAfter turns.';
    }

    public override function makesCreatureAggressive(creature:Creature) {
        return Std.is(creature, Goblin);
    }
}