package worldElements.creatures.statusModifiers;

class StatusModifier {
    var creature:Creature;

    public function new(creature:Creature) {
        this.creature = creature;

        init();
    }

    public function init() {

    }

    public function onTurn() {
        //Possibly does something to the creature
    }

    public function makesCreatureAggressive(creature:Creature) {
        return false;
    }
}