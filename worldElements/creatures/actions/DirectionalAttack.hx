package worldElements.creatures.actions;

class DirectionalAttack extends DirectionAction {
    public override function canUseOnElement(elementHere:WorldElement) {
        return Std.is(elementHere, Creature);
    }

    public override function useOnElement(elementHere:WorldElement) {
        var creatureHere:Creature = cast elementHere;
        var result = AttackCalculator.basicAttack(creature, creatureHere);
        if (creature.isInterestingForPlayer() || elementHere.isInterestingForPlayer()) {
            var text = switch (result) {
                case Critical(damage): '${creature.getNameToUse()} ${creature.getAttackVerb()} ${creatureHere.getNameToUse()}. It\'s a critical hit for $damage damage!'.firstToUpper();
                case Damage(damage): '${creature.getNameToUse()} ${creature.getAttackVerb()} ${creatureHere.getNameToUse()} for $damage damage.'.firstToUpper();
                case Block: '${creature.getNameToUse()} tried to ${creature.creatureFullAttackVerb} ${creatureHere.getNameToUse()}, but ${creatureHere.getReferenceToUse()} defended ${creatureHere.getReferenceToUse(true)}.'.firstToUpper();
            }
            creature.world.info.addInfo(text);
        }
    }
}