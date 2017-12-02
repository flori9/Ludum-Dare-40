package ui;

class MenuItem {
    public var text:String;
    public var extraDescription:String;
    public var onUse:Void->Void;

    public function new(text, extraDescription, onUse) {
        this.text = text;
        this.extraDescription = extraDescription;
        this.onUse = onUse;
    }

    public function getHeight(drawer:Drawer) {
        return 1 + (extraDescription == "" ? 0 : drawer.getAmountOfLines(2, 0, extraDescription));
    }

    public function draw(drawer:Drawer, y:Int, minY:Int, maxY /*1 above maximum allowed y*/:Int, selected:Bool) {
        if (y >= maxY)
            return;

        if (y >= minY) {
            if (selected)
                drawer.drawText(0, y, ">");
            drawer.drawText(2, y, text);
        }
        var yy = y + 1;
        if (extraDescription != "") {
            var lines = drawer.splitIntoLines(2, y, extraDescription);
            for (line in lines) {
                if (yy < maxY && yy >= minY) {
                    drawer.drawText(2, yy, line, Drawer.colorToInt(LightGray));
                }
                yy += 1;
            }
        }
    }
}