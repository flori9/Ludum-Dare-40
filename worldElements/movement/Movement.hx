package worldElements.movement;

/**
 *  The way things move.
 */
class Movement {
    public function canMove(world:World, creature:Creature, direction:Direction) {
        //Whether the given creature could move in the given direction
        var newPosition = world.positionInDirection(creature.position, direction);

        if (newPosition != null) {
            var elementsHere = world.elementsAtPosition(newPosition);
            return ! elementsHere.any(function(e) return e.isBlocking);
        }
        
        return false;
    }

    public function move(world:World, creature:Creature) {
        //Do a single movement step for the given creature
        
    }

    public function moveInDirection(world:World, creature:Creature, direction:Direction) {
        var newPosition = world.positionInDirection(creature.position, direction);
        if (newPosition != null) {
            creature.position = newPosition;
        }
    }
}