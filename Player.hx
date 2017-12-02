class Player extends Focusable {
    public var ownBody:worldElements.creatures.Human;
    public var controllingBody:worldElements.creatures.Creature;

    override function get_showsWorld() return true;

    public function new(keyboard:Keyboard, world:World, game:Game) {
        super(keyboard, world, game);

        ownBody = new worldElements.creatures.Human(world, new Point(1, 1));
        world.addElement(ownBody);
        controllingBody = ownBody;
    }

    public override function update() {
        var xMove = 0, yMove = 0;

        if (keyboard.pressed[Keyboard.arrowLeft] || keyboard.pressed[Keyboard.getLetterCode('A')])
            xMove -= 1;
        if (keyboard.pressed[Keyboard.arrowRight] || keyboard.pressed[Keyboard.getLetterCode('D')])
            xMove += 1;
        if (keyboard.pressed[Keyboard.arrowUp] || keyboard.pressed[Keyboard.getLetterCode('W')])
            yMove -= 1;
        if (keyboard.pressed[Keyboard.arrowDown] || keyboard.pressed[Keyboard.getLetterCode('S')])
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
        }
    }
}