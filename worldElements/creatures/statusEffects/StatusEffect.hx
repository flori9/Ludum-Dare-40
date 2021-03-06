package worldElements.creatures.statusEffects;

class StatusEffect extends worldElements.creatures.statusModifiers.StatusModifier {
    public var name = "";
    public var ended = false;
    /**
     *  Whether the status effect is seen as negative
     */
    public var negative = true;
    var creature:Creature;
    
    public function new(creature:Creature) {
        this.creature = creature;

        super();
    }

    public function getText() {
        return "";
    }
}