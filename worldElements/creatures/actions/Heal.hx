package worldElements.creatures.actions;

class Heal extends CreatureAction {
    override function get_actionPoints() return 4;

    var amount:Int;

    public function new(creature, amount:Int) {
        super(creature);
        
        this.abilityName = "Magical Healing";
        this.abilityDescription = 'Heal $amount HP.';
        this.amount = amount;
    }

    public override function canUse() {
        return true;
    }

    public override function use() {
        if (creature.isInterestingForPlayer())
            creature.world.info.addInfo('${creature.getNameToUse()} magically healed $amount HP.'.firstToUpper());
        creature.stats.gainHP(amount);
    }
}