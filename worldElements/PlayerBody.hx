package worldElements;

class PlayerBody extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return true;

    override function init() {
        super.init();

        color = Drawer.colorToInt(DarkLightBlue);
        character = "@";
    }

    public override function getInfo():String {
        return "Your body!";
    }
}