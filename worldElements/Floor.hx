package worldElements;

class Floor extends WorldElement {
    override function get_isBlocking() return false;
    override function get_isViewBlocking() return false;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return false;

    override function init() {
        color = 0x202020;
    }

    override function draw(drawer:Drawer, notInView:Bool) {
        drawer.setWorldWall(position.x, position.y, color, notInView);
    }
    
    public override function getInfo():String {
        return "";
    }
}