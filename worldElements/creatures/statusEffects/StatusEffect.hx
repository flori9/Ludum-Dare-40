package worldElements.creatures.statusEffects;

class StatusEffect {
    var creature:Creature;
    public var name = "";
    public var ended = false;

    public function new(creature:Creature) {
        this.creature = creature;

        init();
    }

    public function init() {

    }

    public function onTurn() {
        //Possibly does something to the creature
    }

    public function getText() {
        return "";
    }
}