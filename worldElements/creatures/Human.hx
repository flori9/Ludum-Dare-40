package worldElements.creatures;

class Human extends Creature {
    public override function init() {
        super.init();

        color = Drawer.colorToInt(LightBlue);
        character = "@";
        creatureTypeName = "human";
        stats.setMaxHP(10);
        stats.setMaxAP(5);
        stats.setAttack(4);
        stats.setCritChance(0.05);

        creatureAttackVerb = "hit";
        creatureFullAttackVerb = "hit";
        initAsHumanoid();
    }
}