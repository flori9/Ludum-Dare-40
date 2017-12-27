package ui;

class InfoDisplay extends Focusable {
    override function get_showsWorld() return innerFocusable.showsWorld;

    var info = "";
    var currentLine = 0;
    var currentLines:Array<String>;
    var innerFocusable:Focusable;

    public function new(keyboard:Keyboard, world:World, game:Game, innerFocusable:Focusable) {
        this.innerFocusable = innerFocusable;

        super(keyboard, world, game);
    }

    public function clear() {
        info = "";
    }
    
    public function addInfo(info:String) {
        if (this.info != "") this.info += " ";
        this.info += info;
    }

    public override function draw() {
        drawCurrentLines(game.drawer);
    }

    /**
     *  Show info, possibly taking focus
     */
    public function processInfo(drawer:Drawer) {
        var addToLast = " [more...]";

        var lines = drawer.splitIntoLines(0, 0, info, function(orig, ln) return ln % 2 == 1 ? orig - addToLast.length : orig);
        if (lines.length > 2) {
            for (i in 0...lines.length - 1) {
                if (i % 2 == 1) {
                    // if (lines[i].charAt(lines[i].length - 1) != ".")
                    //     lines[i] += ".";
                    // lines[i] += "..";
                    lines[i] += addToLast;
                }
            }

            game.focus(this);
        }

        currentLines = lines;
        currentLine = 0;
        drawCurrentLines(drawer);
    }

    public override function update() {
        if (keyboard.anyKey()) {
            currentLine += 2;

            if (currentLine >= currentLines.length - 2) {
                game.focus(innerFocusable, false);
            }

            drawCurrentLines(game.drawer);
        }
    }

    function drawCurrentLines(drawer:Drawer) {
        drawer.clearLines(0, 2);

        if (currentLines.length > currentLine)
            drawer.drawText(0, 0, currentLines[currentLine]);
        if (currentLines.length > currentLine + 1)
            drawer.drawText(0, 1, currentLines[currentLine + 1]);
    }
}