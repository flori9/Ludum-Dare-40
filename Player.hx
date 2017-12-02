class Player {
    var keyboard:Keyboard;
    var world:World;
    var ownBody:worldElements.creatures.Human;
    var controllingBody:worldElements.Creature;

    public function new(keyboard:Keyboard, world:World) {
        this.keyboard = keyboard;
        this.world = world;
        
        ownBody = new worldElements.creatures.Human(world, new Point(1, 1));
        controllingBody = ownBody;
    }

    public function update() {
        var xMove = 0, yMove = 0;

        if (keyboard.pressed[Keyboard.arrowLeft])
            xMove -= 1;
        if (keyboard.pressed[Keyboard.arrowRight])
            xMove += 1;
        if (keyboard.pressed[Keyboard.arrowLeft])
            yMove -= 1;
        if (keyboard.pressed[Keyboard.arrowRight])
            yMove += 1;
        
        var moveDirection = null;
        if (xMove == -1) {
            moveDirection = Left;
        } else if (xMove == 1) {
            moveDirection = Right;
        }

        //up down display

        if (moveDirection != null) {

        }
    }
}