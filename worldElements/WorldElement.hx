package worldElements;

class WorldElement {
    public var isBlocking(get, never):Bool;
    function get_isBlocking() return false;
    public var isViewBlocking(get, never):Bool;
    function get_isViewBlocking() return false;
    public var isStatic(get, never):Bool;
    function get_isStatic() return false;
    /** Whether the object is easier visible, like a wall
     *  This means it's visible when any adjecent empty square is visible.
     */
    public var isEasierVisible(get, never):Bool;
    function get_isEasierVisible() return false;
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
    /** Whether the player has seen this */
    public var seenByPlayer:Bool = false;

    /**
     *  Whether the player can see this, either gray or not
     */
    public var isCurrentlyVisible:Bool = false;

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

    public function postUpdate() {
        
    }

    public function update(isExtra = false) {

    }

    public function draw(drawer:Drawer, notInView:Bool) {
        drawer.setWorldCharacter(position.x, position.y, character, color, notInView);
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
    public function isInterestingForPlayer(controllingOnly = true) {
        return false;
    }
}