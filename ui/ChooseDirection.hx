package ui;

class ChooseDirection extends Focusable {
    override function get_showsWorld() return true;

    var info = "";
    var chooseFunction:Direction->Void;
    var innerFocusable:Focusable;

    public function new(keyboard:Keyboard, world:World, game:Game, info:String, chooseFunction:Direction->Void, innerFocusable:Focusable) {
        super(keyboard, world, game);
        this.info = info;
        this.chooseFunction = chooseFunction;
        this.innerFocusable = innerFocusable;

        draw();
    }

    public override function update() {
        if (keyboard.leftKey()) {
            chooseFunction(Left);
            return;
        }
        if (keyboard.rightKey()) {
            chooseFunction(Right);
            return;
        }
        if (keyboard.upKey()) {
            chooseFunction(Up);
            return;
        }
        if (keyboard.downKey()) {
            chooseFunction(Down);
            return;
        }
        if (keyboard.anyBack()) {
            game.focus(innerFocusable, false);
        }
    }

    public override function draw() {
        var drawer = game.drawer;
        drawer.clearLines(0, 2);
        drawer.drawText(0, 0, info);
    }
}