package worldElements.creatures.statusEffects;

import worldElements.creatures.statusModifiers.SimpleStatusModifier;

class StatusEffect extends worldElements.creatures.statusModifiers.StatusModifier {
    public var name = "";
    public var ended = false;
    /**
     *  Whether the status effect is seen as negative
     */
    public var negative = true;
    var creature:Creature;
    public var modifiersWhileActive(get, never):Array<SimpleStatusModifier>;
    function get_modifiersWhileActive() return [];
    
    public function new(creature:Creature) {
        this.creature = creature;

        super();
    }

    public function getText() {
        return "";
    }
}