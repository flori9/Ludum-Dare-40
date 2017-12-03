package worldElements.creatures;

@:keep
class ManeatingPlant extends Creature {
    public override function init() {
        super.init();

        color = 0x60ff60;
        character = "p";
        creatureTypeName = "man-eating plant";
        stats.setMaxHP(7);
        stats.setMaxAP(3);
        stats.setAttack(3);
        stats.speed = 100;

        creatureAttackVerb = "grabbed";
        creatureFullAttackVerb = "grab";
        aggressiveToPlayerIfNear = true;
        aggressiveNearDistance = 1;

        movement = new worldElements.creatures.movement.StillMovement();
    }
}