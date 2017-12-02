package worldElements.creatures.movement;

class BasicMovement extends Movement {
    public function new() {

    }

    public override function move(world:World, creature:Creature) {
        var toPlayer = world.pathfinder.find(creature.position, function(pos)
            return world.elementsAtPosition(pos).contains(world.player.controllingBody), false);
        if (toPlayer.length > 0) {
            if (toPlayer[0].distance == 1)
                creature.attack(world.player.controllingBody);
            else
                moveInDirection(world, creature, toPlayer[0].inDirection);
        }
    }
}