package worldElements.creatures.movement;

class BasicMovement extends Movement {
    public function new() {

    }

    public override function getAggresiveTo(world:World, creature:Creature) {
        var aggressiveToCreatures = creature.attackedBy.copy();
        
        if ((creature.aggressiveToPlayer || (creature.aggressiveToPlayerIfNear
                && creature.position.manhattanDistance(world.player.ownBody.position) <= creature.aggressiveNearDistance))
                && !aggressiveToCreatures.contains(world.player.ownBody))
            aggressiveToCreatures.push(world.player.ownBody);
        for (worldCreature in world.creatures) {
            if (aggressiveToCreatures.contains(worldCreature))
                continue;

            if (worldCreature.makesCreatureAggressive(creature))
                aggressiveToCreatures.push(worldCreature);
        }

        //Add any creatures leaders are aggresive to
        for (leader in creature.leaderCreatures) {
            var leaderAggro = leader.movement.getAggresiveTo(world, leader);
            for (worldCreature in leaderAggro) {
                if (aggressiveToCreatures.contains(worldCreature) || worldCreature == creature)
                    continue;

                aggressiveToCreatures.push(worldCreature);
            }
        }

        return aggressiveToCreatures;
    }

    public override function move(world:World, creature:Creature) {
        if (!autoMove) return;

        var aggressiveToCreatures = getAggresiveTo(world, creature);

        function isAggressiveToThis(elem)
            return Std.is(elem, Creature) && aggressiveToCreatures.contains(cast elem);

        var toTargets = world.pathfinder.find(creature.position, function(pos)
            return world.elementsAtPosition(pos).any(isAggressiveToThis), true);

        var nearestTarget = null, nearestTargetInfo = null, nearestTargetDistance = 1000000;

        var isBlinded = creature.hasSimpleStatusModifier(Blinded);
        //If we're blinded, we only attack if we can see the creature right now
        var currentFollowTimeWithoutSee = isBlinded ? 0 : creature.followTimeWithoutSee;
        
        for (toTarget in toTargets) {
            var target:Creature = cast world.elementsAtPosition(toTarget.point).filter(isAggressiveToThis)[0];
            var canSee = world.pathfinder.isVisible(creature.position, target.position);
            //If we're blinded, we can see much less far
            if (isBlinded && toTarget.distance > 1)
                canSee = false;
            if (canSee)
                creature.lastSeenCreature[target] = 0;

            if (creature.lastSeenCreature[target] <= currentFollowTimeWithoutSee && toTarget.distance < nearestTargetDistance) {
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
                var wanderToOptions = world.pathfinder.find(creature.position, function(p) return world.noBlockingElementsAt(p, false), true);
                
                //Maximum wander distance from base or current point
                if (creature.maxWanderDistance > -1) {
                    if (creature.basePoint == null)
                        wanderToOptions = wanderToOptions.filter(function (wp)
                            return wp.distance <= creature.maxWanderDistance);
                    else
                        wanderToOptions = wanderToOptions.filter(function (wp)
                            return wp.point.manhattanDistance(creature.basePoint) <= creature.maxWanderDistance);
                }
                
                if (wanderToOptions.length > 0)
                    creature.wanderTo = common.Random.fromArray(wanderToOptions).point;
            }
            
            if (creature.wanderTo != null) {
                var wanderInfo = world.pathfinder.find(creature.position, function(p)
                    return p.equals(creature.wanderTo) && world.noBlockingElementsAt(p, false), false);
                if (wanderInfo.length > 0) {
                    moveInDirection(world, creature, wanderInfo[0].inDirection);
                    if (creature.position == creature.wanderTo)
                        creature.wanderTo = null;
                } else creature.wanderTo = null;
            }
        }
    }

    /**
     *  Called can, but actually does the ability too. Oops.
     *  @param creature - 
     *  @param aggressiveToCreatures - 
     *  @return Bool
     */
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