package items;

import worldElements.creatures.Creature;

class WolfMilk extends Item {
    override function get_name() return "Milk of a Wolf";
    override function get_description() return "Drink to fully restore your health. " + super.description;
    override function get_value() return 5;
    override function get_color() return 0xF6F7F4;
    override function get_consumable() return true;
    override function get_useable() return true;
    override function get_character() return "%";
    override function get_aOrAnOrThe() return "the";
    
    public override function use(creature:Creature) {
        if (creature.isInterestingForPlayer())
            creature.world.info.addInfo('${creature.getNameToUse()} drank the milk of a wolf to restore ${creature.getOwnerReference()} health.'.firstToUpper());
        
        creature.stats.hp = creature.stats.maxHP;
    }
}