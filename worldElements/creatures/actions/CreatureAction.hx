package worldElements.creatures.actions;

class CreatureAction {
    var creature:Creature;

    public function new(creature:Creature) {
        this.creature = creature;
    }

    public function canUse() {
        return false;
    }

    public function use() {
        //Nothing by default
    }
}