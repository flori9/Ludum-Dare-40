package worldElements;
import worldElements.movement.*;

class Creature extends WorldElement {
    public var movement:Movement;
    override function get_isBlocking() return true;
    public var hasMoved:Bool = false;

    public override function init() {
        movement = new BasicMovement();
    }

    public override function preUpdate() {
        hasMoved = false;
    }

    public override function update() {
        super.update();

        if (!hasMoved) {
            movement.move(world, this);
            hasMoved = true;
        }
    }
}