package worldElements.creatures;

class Human extends Creature {
    public override function init() {
        super.init();

        color = Drawer.colorToInt(LightBlue);
        character = "@";
        creatureTypeName = "human";
        stats.setMaxHP(10);
        stats.setMaxAP(10);
        stats.setAttack(3);

        creatureAttackVerb = "hit";
        creatureFullAttackVerb = "hit";
        addStatusEffect(new worldElements.creatures.statusEffects.Poison(this));
    }
}