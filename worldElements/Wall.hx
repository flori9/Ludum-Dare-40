package worldElements;

class Wall extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return true;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return true;

    override function draw(drawer:Drawer, notInView:Bool) {
        drawer.setWorldWall(position.x, position.y, color, notInView);
    }
    
    public override function getInfo():String {
        return "A wall.";
    }
}