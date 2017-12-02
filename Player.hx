class Player extends Focusable {
    public var ownBody:worldElements.creatures.Human;
    public var controllingBody:worldElements.creatures.Creature;

    var statusEffectsMenuKey:Int;

    override function get_showsWorld() return true;

    public function new(keyboard:Keyboard, world:World, game:Game) {
        super(keyboard, world, game);

        ownBody = new worldElements.creatures.Human(world, new Point(1, 1));
        world.addElement(ownBody);
        controllingBody = ownBody;

        statusEffectsMenuKey = Keyboard.getLetterCode("e");
    }

    public override function update() {
        var xMove = 0, yMove = 0;

        if (keyboard.leftKey())
            xMove -= 1;
        if (keyboard.rightKey())
            xMove += 1;
        if (keyboard.upKey())
            yMove -= 1;
        if (keyboard.downKey())
            yMove += 1;
        
        var moveDirection = null;
        if (xMove == -1) {
            moveDirection = Left;
        } else if (xMove == 1) {
            moveDirection = Right;
        } else if (yMove == -1)
            moveDirection = Up;
        else if (yMove == 1)
            moveDirection = Down;

        if (moveDirection != null) {
            if (controllingBody.movement.canMove(world, controllingBody, moveDirection)) {
                game.beforeStep();
                controllingBody.movement.moveInDirection(world, controllingBody, moveDirection);
                controllingBody.hasMoved = true;
                game.afterStep();
            }
        } else if (keyboard.pressed[statusEffectsMenuKey]) {
            showStatusEffects();
        }
    }

    function showStatusEffects() {
        game.focus(new ui.Menu(game.drawer, keyboard, world, game, this, "Status Effects", [
            new ui.MenuItem("Item 1", "Extra description", function() { trace("use item 1"); }),
            new ui.MenuItem("Item 2", "", function() { trace("use item 2"); }),
            new ui.MenuItem("Item 3", "Another Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 4", "dsf Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 5", "3e Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 6", "2 Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 3a", "Another Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 4a", "dsf Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 5a", "3e Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 6a", "2 Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 7a", "2 Extra description", function() { trace("use item 3"); }),
            new ui.MenuItem("Item 1", "Extra description", function() { trace("use item 1"); }),
            new ui.MenuItem("Item 2", "", function() { trace("use item 2"); }),
            new ui.MenuItem("Item 3", "Another Extra description", function() { trace("use item 3"); })
        ], statusEffectsMenuKey));
    }
}