package worldElements.movement;

class PlayerControlledMovement {
    var nextDirection:Direction;

    public function setDirection(direction:Direction) {
        nextDirection = direction;
    }

    public function move(world:World, creature:Creature) {
        //Do a single movement step for the given creature
        var newPosition = world.positionInDirection(creature.position, nextDirection);
        if (newPosition != null) {
            creature.position = newPosition;
        }
    }
}