package worldElements.creatures.movement;

class StillMovement extends BasicMovement {
    public override function canMove(world:World, creature:Creature, direction:Direction) {
        var newPosition = world.positionInDirection(creature.position, direction);

        if (newPosition != null) {
            var elementsHere = world.elementsAtPosition(newPosition);

            if (elementsHere.any(function (e) return e.hasActionFor(creature)))
                return true;
        }

        return false;
    }

    public override function move(world:World, creature:Creature) {
        var aggressiveToCreatures = getAggresiveTo(world, creature);
        canUseAnyAbility(creature, aggressiveToCreatures);
    }
}