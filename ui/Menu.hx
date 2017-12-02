package ui;

class Menu extends Focusable {
    var drawer:Drawer;
    static inline var drawY = 2;
    static inline var maxDrawY = Drawer.height - 2;

    var items:Array<MenuItem>;
    var innerFocusable:Focusable;
    var title:String;

    var info:InfoDisplay;
    var extraCloseKey:Int;
    var selectedItem = 0;
    var scrollTop = 0;

    public function new(drawer:Drawer, keyboard:Keyboard, world:World, game:Game, innerFocusable:Focusable,
        title:String, items:Array<MenuItem>, ?extraCloseKey:Int) {
        this.drawer = drawer;
        super(keyboard, world, game);
        
        this.title = title;
        this.items = items;
        this.extraCloseKey = extraCloseKey;
        this.innerFocusable = innerFocusable;
        info = new InfoDisplay(keyboard, world, game, this);

        game.focus(this);
        
        draw();
    }

    public override function update() {
        if (keyboard.anyBack() || (extraCloseKey != null && keyboard.pressed[extraCloseKey])) {
            game.focus(innerFocusable);
        } else {
            var down = keyboard.downKey() && ! keyboard.upKey();
            var up = keyboard.upKey() && ! keyboard.downKey();

            if (down && selectedItem < items.length - 1) {
                selectedItem += 1;
                draw();
            }
            else if (up && selectedItem > 0) {
                selectedItem -= 1;
                draw();
            }
            else if (keyboard.anyConfirm()) {
                if (items[selectedItem].onUse != null)
                    items[selectedItem].onUse();
            }
        }
    }

    public function draw() {
        drawer.clear();
        drawer.setMultiBackground(0, drawY, title.length, Drawer.colorToInt(DarkGray));
        drawer.drawText(0, drawY, title);

        var menuHeight = 0;
        var selectedAt = 0;
        var upperLimit = drawY + 1;

        //First, let's check the ideal scroll top
        for (i in 0...items.length) {
            var item = items[i];
            if (selectedItem == i) {
                selectedAt = menuHeight;
            }
            menuHeight += item.getHeight(drawer);
        }
        scrollTop = Math.iclamp(selectedAt - Math.div(maxDrawY - upperLimit, 2), 0, menuHeight - maxDrawY + upperLimit);

        var yy = upperLimit - scrollTop;

        for (i in 0...items.length) {
            var item = items[i];
            item.draw(drawer, yy, upperLimit, maxDrawY, selectedItem == i);
            
            yy += item.getHeight(drawer);
        }
    }

    function getMenuHeight() {
        var menuHeight = 0;
        for (item in items) {
            menuHeight += item.getHeight(drawer);
        }
        return menuHeight;
    }
}