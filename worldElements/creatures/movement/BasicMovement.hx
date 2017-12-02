package worldElements.creatures.movement;

class BasicMovement extends Movement {
    public function new() {

    }

    public override function move(world:World, creature:Creature) {
        var aggresiveToCreatures = creature.attackedBy.copy();
        if (creature.aggresiveToPlayer && !aggresiveToCreatures.contains(world.player.ownBody))
            aggresiveToCreatures.push(world.player.ownBody);

        function isAggresiveToThis(elem)
            return Std.is(elem, Creature) && aggresiveToCreatures.contains(cast elem);

        var toTargets = world.pathfinder.find(creature.position, function(pos)
            return world.elementsAtPosition(pos).any(isAggresiveToThis), true);

        var nearestTarget = null, nearestTargetInfo = null, nearestTargetDistance = 1000000;

        for (toTarget in toTargets) {
            var target:Creature = cast world.elementsAtPosition(toTarget.point).filter(isAggresiveToThis)[0];
            var canSee = world.pathfinder.isVisible(creature.position, target.position);
            if (canSee)
                creature.lastSeenCreature[target] = 0;

            if (creature.lastSeenCreature[target] <= creature.followTimeWithoutSee) {
                nearestTarget = target;
                nearestTargetInfo = toTarget;
                nearestTargetDistance = toTarget.distance;
            }
        }

        if (nearestTarget != null) {
            if (nearestTargetInfo.distance == 1)
                creature.attack(nearestTarget);
            else
                moveInDirection(world, creature, nearestTargetInfo.inDirection);
        }
    }
}