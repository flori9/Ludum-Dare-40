package worldElements.creatures.movement;

import worldElements.creatures.Creature;

/**
 *  The way things move.
 */
class Movement {
    public var autoMove = true;

    public function canMove(world:World, creature:Creature, direction:Direction) {
        //Whether the given creature could move in the given direction
        var newPosition = world.positionInDirection(creature.position, direction);

        if (newPosition != null) {
            var elementsHere = world.elementsAtPosition(newPosition);

            if (! isBlockingElementIn(world, elementsHere))
                return true;
            if (elementsHere.any(function (e) return e.hasActionFor(creature)))
                return true;
        }

        return false;
    }

    function isBlockingElementIn(world:World, elementsHere:Array<WorldElement>) {
        if (! elementsHere.any(function(e) return e.isBlocking))
            return false;
        return true;
    }

    public function move(world:World, creature:Creature) {

    }

    /**
     *  Returns the creatures the given creature is aggresive to
     *  @param world The world
     *  @param creature The creature
     */
    public function getAggresiveTo(world:World, creature:Creature) {
        return [];
    }

    public function moveInDirection(world:World, creature:Creature, direction:Direction) {
        var newPosition = world.positionInDirection(creature.position, direction);
        if (newPosition != null) {
            var elementsHere = world.elementsAtPosition(newPosition);

            //Move
            if (! isBlockingElementIn(world, elementsHere))
                creature.position = newPosition;

            //Perform any actions
            for (elem in elementsHere) {
                if (elem != creature && elem.hasActionFor(creature)) {
                    elem.performActionFor(creature);

                    //Still move if the item wants that to happen
                    var elementsHere2 = elementsHere.copy();
                    elementsHere2.remove(elem);
                    if (elem.moveAfterActionsForThis && !isBlockingElementIn(world, elementsHere2))
                        creature.position = newPosition;
                    break;
                }
            }
        }
    }
}