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

    public var world:World;
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

    public function getInfo():String {
        return "You don't know what this is!";
    }

    /**
     *  Whether the world element has an action (triggered by moving at it)
     *  when the given worldElement moves into it.
     *  @param worldElement - The world element that moves into the other one
     */
    public function hasActionFor(triggeringWorldElement:WorldElement) {
        return false;
    }

    public function performActionFor(triggeringWorldElement:WorldElement) {
        //Nothing by default
    }

    public function shouldRemove() {
        return false;
    }

    /**
     *  Whether the player wants to know everything that happens to this.
     */
    public function isInterestingForPlayer() {
        return false;
    }
}