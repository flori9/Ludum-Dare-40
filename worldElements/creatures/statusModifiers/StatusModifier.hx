package worldElements.creatures.statusModifiers;

class StatusModifier {
    public var modifySpeed(get, never):Float;
    function get_modifySpeed() return 0.0;

    public function new() {
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