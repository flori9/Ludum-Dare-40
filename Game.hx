import pixi.core.display.Container;

class Game {
	public var rect:Rectangle; //The game rectangle
    public var keyboard:Keyboard;
	public var application:Main;
    
	public var scaling:Int;
	
//	public var mouse:Mouse;

	var stage:Container;
    var drawer:Drawer;
    var player:Player;
    var world:World;

	public function new(application, stage, gameRect) {
		this.application = application;
		this.stage = stage;
        this.rect = gameRect;
        this.drawer = new Drawer(stage);
        this.keyboard = new Keyboard();
        this.world = new World(drawer);

        player = new Player(keyboard, world, this);

        drawer.clear();
        world.draw();
    }
	
	public function update(timeMod:Float) {
        // Do a game update
        keyboard.update();
        
        player.update();

        postUpdate();
	}

    public function postUpdate() {
        keyboard.postUpdate();
    }

    /**
     *  Before a player step
     */
    public function beforeStep() {
        drawer.clear();
    }

    /**
     *  After a player step
     */
    public function afterStep() {
        world.update();
    }
}