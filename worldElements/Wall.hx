package worldElements;

class Wall extends WorldElement {
    override function get_isBlocking() return true;

    override function draw(drawer:Drawer) {
        drawer.setWorldWall(position.x, position.y, color);
    }
    
    public override function getInfo():String {
        return "A wall.";
    }
}