package worldElements.creatures.movement;

class NoMovement extends Movement {
    public function new() {

    }

    public override function move(world:World, creature:Creature) {
        //Nothing!
    }
}