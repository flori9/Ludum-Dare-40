package worldElements.creatures.actions;

class DirectionAction extends CreatureAction {
    var direction:Direction = null;

    public function setParameter(direction:Direction) {
        this.direction = direction;
    }

    public override function canUse() {
        //Default, could be different
        return elementsInDirection().any(function(elem) return canUseOnElement(elem));
    }

    public override function canUseOnCreatureFrom(creatures:Array<Creature>) {
        return canUseOnAnyCreatureFromElements(elementsInDirection(), creatures);
    }

    function canUseOnAnyCreatureFromElements(elements:Array<WorldElement>, creatures:Array<Creature>) {
        return elements.any(function(elem) return Std.is(elem, Creature) && creatures.contains(cast elem) && canUseOnElement(elem));
    }

    public override function tryPossibleParameters(targets:Array<Creature>):Bool {
        //Tries for all possible parameters whether they would work, returns whether one succeeded
        var options = [Left, Right, Up, Down];
        for (option in options) {
            setParameter(option);
            if (canUseOnCreatureFrom(targets)) {
                use();
                return true;
            }
        }
        return false;
    }

    function canUseOnElement(elementHere:WorldElement) {
        return false;
    }

    public override function use() {
        var elems = elementsInDirection();
        for (elem in elems) {
            if (canUseOnElement(elem)) {
                useOnElement(elem);

                break;
            }
        }
    }

    public function useOnElement(elementHere:WorldElement) {
        //Nothing by default
    }

    function elementsInDirection() {
        var positionHere = creature.world.positionInDirection(creature.position, direction);
        if (positionHere != null) {
            return creature.world.elementsAtPosition(positionHere);
        }
        return [];
    }
}