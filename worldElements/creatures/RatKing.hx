package worldElements.creatures;

class RatKing extends Rat {
    public override function init() {
        super.init();

        color = 0xD34D00;
        character = "r";
        creatureTypeName = "rat king";
        stats.setMaxHP(10);
        stats.setMaxAP(3);
        stats.setAPRegen(50);
        stats.setAttack(2);
        stats.setSpeed(120);
        
        aggressiveToPlayerIfNear = false;
        aggressiveNearDistance = 10;
        basePoint = position;
        maxWanderDistance = 5;
    }
    
    public override function postDungeonInit() {
        for (worldCreature in world.creatures) {
            if (Std.is(worldCreature, Rat) && worldCreature != this) {
                worldCreature.leaderCreatures.push(this);
            }
        }
    }
}