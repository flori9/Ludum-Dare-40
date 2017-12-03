package worldElements.creatures.actions;

class Dash extends DirectionAction {
    override function get_actionPoints() return 2;

    public function new(creature) {
        super(creature);
        
        this.abilityName = "Dash";
        this.abilityDescription = "Move up to three spaces in one direction. If you hit an enemy, attack it.";
    }

    public override function canUse() {
        return creature.world.noBlockingElementsAt(creature.world.positionInDirection(creature.position, direction), false);
    }

    public override function canUseOnElement(elementHere:WorldElement) {
        return true;
    }

    public override function canUseOnCreatureFrom(creatures:Array<Creature>) {
        if (! canUse()) return false;
        var pos = creature.position;
        for (i in 0...4) {
            pos = creature.world.positionInDirection(pos, direction);
            if (canUseOnAnyCreatureFromElements(creature.world.elementsAtPosition(pos), creatures))
                return true;
            if (! creature.world.noBlockingElementsAt(pos, false))
                break;
        }
        return false;
    }

    public override function use() {
        var pos = creature.position, moveToPos = creature.position;
        var attacked = false;
        for (i in 0...4) {
            pos = creature.world.positionInDirection(pos, direction);
            var elems = creature.world.elementsAtPosition(pos);
            for (elem in elems) {
                if (Std.is(elem, Creature)) {
                    var creatureHere:Creature = cast elem;
                    var result = AttackCalculator.basicAttack(creature, creatureHere);
                    if (creature.isInterestingForPlayer() || creatureHere.isInterestingForPlayer()) {
                        var text = switch (result) {
                            case Critical(damage): '${creature.getNameToUse()} dashed into ${creatureHere.getNameToUse()}. It\'s a critical hit for $damage damage!'.firstToUpper();
                            case Damage(damage): '${creature.getNameToUse()} dashed into ${creatureHere.getNameToUse()} for $damage damage.'.firstToUpper();
                            case Block: '${creature.getNameToUse()} tried to dash into ${creatureHere.getNameToUse()}, but ${creatureHere.getReferenceToUse()} defended ${creatureHere.getReferenceToUse(true)}.'.firstToUpper();
                        }
                        creature.world.info.addInfo(text);
                    }
                    attacked = true;
                    break;
                }
            }

            if (attacked) break;

            if (! creature.world.noBlockingElementsAt(pos, false))
                break;
            if (i != 3)
                moveToPos = pos;
        }

        //Move to the position
        creature.position = moveToPos;
    }
}