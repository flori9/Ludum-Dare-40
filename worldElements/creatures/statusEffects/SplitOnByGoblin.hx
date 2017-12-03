package worldElements.creatures.statusEffects;

class SplitOnByGoblin extends StatusEffect {
    var goesAwayAfter:Int;

    public override function init() {
        name = "Spit on by a goblin";
        goesAwayAfter = 50;
    }

    public override function onTurn() {
        if (goesAwayAfter <= 0) {
            if (creature.isInterestingForPlayer())
                creature.world.info.addInfo('It was no longer possible to see or smell the goblin spit on ${creature.getReferenceToUse()}.');
            ended = true;
        }
        else
            goesAwayAfter -= 1;
    }

    public override function getText() {
        return 'All goblins are aggressive to you! Ends after $goesAwayAfter turns.';
    }

    public override function makesCreatureAggressive(creature:Creature) {
        return Std.is(creature, Goblin);
    }
}