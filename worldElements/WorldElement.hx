package worldElements;

class WorldElement {
    public var isBlocking(get, never):Bool;
    function get_isBlocking() return false;
    public var position(default, set):Point;
    function set_position(newPosition:Point) {
        if (position != null)
            world.removeFromElementsAtPosition(this, position);
        position = newPosition;
        world.addToElementsAtPosition(this, newPosition);
        return position;
    }

    var world:World;
    var character:String;
    var color:Int;

    public function new(world:World, position:Point) {
        this.world = world;
        this.position = position;
        character = "";
        color = Drawer.colorToInt(White);

        init();
    }

    public function init() {

    }

    public function preUpdate() {

    }

    public function update() {

    }

    public function draw(drawer:Drawer) {
        drawer.setWorldCharacter(position.x, position.y, character, color);
    }
}