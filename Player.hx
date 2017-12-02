class Player {
    var keyboard:Keyboard;
    var world:World;
    var game:Game;
    var ownBody:worldElements.creatures.Human;
    var controllingBody:worldElements.Creature;

    public function new(keyboard:Keyboard, world:World, game:Game) {
        this.keyboard = keyboard;
        this.world = world;
        this.game = game;

        ownBody = new worldElements.creatures.Human(world, new Point(1, 1));
        world.addElement(ownBody);
        controllingBody = ownBody;
    }

    public function update() {
        var xMove = 0, yMove = 0;

        if (keyboard.pressed[Keyboard.arrowLeft])
            xMove -= 1;
        if (keyboard.pressed[Keyboard.arrowRight])
            xMove += 1;
        if (keyboard.pressed[Keyboard.arrowUp])
            yMove -= 1;
        if (keyboard.pressed[Keyboard.arrowDown])
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