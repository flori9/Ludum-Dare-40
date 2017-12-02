package worldElements;

class WorldElement {
    public var isBlocking(get, never):Bool;
    function get_isBlocking() return false;
    public var position(default, set):Point;
    function set_position(newPosition:Point) {
        world.removeFromElementsAtPosition(this);
        position = newPosition;
        world.addToElementsAtPosition(this);
        return position;
    }

    var world:World;

    public function new(world:World, position:Point) {
        this.world = world;
        this.position = position;
    }

    public function update() {

    }

    public function draw(drawer:Drawer) {

    }
}