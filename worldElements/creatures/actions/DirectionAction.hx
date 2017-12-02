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

    public function canUseOnElement(elementHere:WorldElement) {
        return false;
    }

    public override function use() {
        //Nothing by default
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