package worldElements.creatures.movement;

class BasicMovement extends Movement {
    public function new() {

    }

    public override function move(world:World, creature:Creature) {
        var aggressiveToCreatures = creature.attackedBy.copy();
        if (creature.aggressiveToPlayer && !aggressiveToCreatures.contains(world.player.ownBody))
            aggressiveToCreatures.push(world.player.ownBody);
        for (worldCreature in world.creatures) {
            if (worldCreature.makesCreatureAggressive(creature))
                aggressiveToCreatures.push(worldCreature);
        }

        function isAggressiveToThis(elem)
            return Std.is(elem, Creature) && aggressiveToCreatures.contains(cast elem);

        var toTargets = world.pathfinder.find(creature.position, function(pos)
            return world.elementsAtPosition(pos).any(isAggressiveToThis), true);

        var nearestTarget = null, nearestTargetInfo = null, nearestTargetDistance = 1000000;

        for (toTarget in toTargets) {
            var target:Creature = cast world.elementsAtPosition(toTarget.point).filter(isAggressiveToThis)[0];
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
            if (canUseAnyAbility(creature, aggressiveToCreatures)) {
                //We did an ability!
            }
            else
                moveInDirection(world, creature, nearestTargetInfo.inDirection);
        } else {
            if (creature.wanderTo == null) {
                var wanderToOptions = world.pathfinder.find(creature.position, function(p) return world.noBlockingElementsAt(p), true);
                if (wanderToOptions.length > 0)
                    creature.wanderTo = common.Random.fromArray(wanderToOptions).point;
            }
            
            if (creature.wanderTo != null) {
                var wanderInfo = world.pathfinder.find(creature.position, function(p) return p.equals(creature.wanderTo), false);
                if (wanderInfo.length > 0) {
                    moveInDirection(world, creature, wanderInfo[0].inDirection);
                    if (creature.position == creature.wanderTo)
                        creature.wanderTo = null;
                } else creature.wanderTo = null;
            }
        }
    }

    public function canUseAnyAbility(creature:Creature, aggressiveToCreatures:Array<Creature>):Bool {
        //getPriority
        var sortedActions = creature.actions.copy();
        sortedActions.sort(function (x, y) return y.getPriority() - x.getPriority());
        for (ability in sortedActions) {
            if (creature.stats.ap >= ability.actionPoints && ability.getPriority() >= 0) {
                if (ability.tryPossibleParameters(aggressiveToCreatures)) {
                    creature.stats.ap -= ability.actionPoints;
                    return true;
                }
            }
        }
        return false;
    }
}