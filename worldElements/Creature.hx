package worldElements;
import worldElements.movement.*;

class Creature extends WorldElement {
    public var movement:Movement;
    override function get_isBlocking() return true;

    public override function update() {
        super.update();

        movement.move(world, this);
    }
}