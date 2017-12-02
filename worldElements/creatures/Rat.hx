package worldElements.creatures;

class Rat extends Creature {
    public override function init() {
        super.init();

        color = 0xD9946A;
        character = "r";
        creatureTypeName = "rat";
        stats.setMaxHP(5);
        stats.setMaxAP(1);
        stats.setAttack(1);
    }
}