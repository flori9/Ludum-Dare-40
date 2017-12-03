package worldElements.creatures.actions;

class CreatureAction {
    var creature:Creature;
    public var actionPoints(get, never):Int;
    function get_actionPoints() return 0;

    public function new(creature:Creature) {
        this.creature = creature;
    }

    public function canUse() {
        return false;
    }

    public function canUseOnCreatureFrom(creatures:Array<Creature>) {
        return false;
    }

    public function use() {
        //Nothing by default
    }

    public function tryPossibleParameters(targets:Array<Creature>):Bool {
        //Tries for all possible parameters whether they would work, returns whether one succeeded
        return false;
    }

    public function getPriority() {
        return actionPoints;
    }
}