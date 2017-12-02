package worldElements.creatures;

class Human extends Creature {
    public override function init() {
        super.init();

        color = Drawer.colorToInt(LightBlue);
        character = "@";
    }
}