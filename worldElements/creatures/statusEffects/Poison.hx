package worldElements.creatures.statusEffects;

class Poison extends StatusEffect {
    var hitEvery:Int;
    var hitInTurns:Int;
    var hitsUntilEnd:Int;

    public override function init() {
        name = "Poisoned";
        hitEvery = 3;
        hitInTurns = 1;
        hitsUntilEnd = 4;
    }

    public override function onTurn() {
        //Possibly does something to the creature
        if (hitInTurns <= 0) {
            hitsUntilEnd -= 1;
            hitInTurns = hitEvery;
            var interesting = creature.isInterestingForPlayer();
            if (interesting)
                creature.world.info.addInfo('Poison dealt 1 damage to ${creature.getNameToUse()}.');
        	creature.stats.hp -= 1;
            if (hitsUntilEnd <= 0) {
                ended = true;
                if (interesting)
                    creature.world.info.addInfo('Then, ${creature.getReferenceToUse()} ${creature.getWereOrWas()} no longer poisoned.');
            }
        }
        else
            hitInTurns -= 1;
    }

    public override function getText() {
        return 'Deals one damage every ${hitEvery + 1} turns. Next damage in ${hitInTurns + 1} turns. Ends after $hitsUntilEnd more hits.';
    }
}