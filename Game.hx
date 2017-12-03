import pixi.core.display.Container;

class Game {
	public var rect:Rectangle; //The game rectangle
    public var keyboard:Keyboard;
    public var mouse:Mouse;
	public var application:Main;
    
	public var scaling:Int;
	
	var stage:Container;
    public var drawer:Drawer;
    public var player:Player;
    var world:World;
    var info:ui.InfoDisplay;

    var focusedElement:Focusable;

	public function new(application, stage, gameRect) {
		this.application = application;
		this.stage = stage;
        this.rect = gameRect;
        this.drawer = new Drawer(stage);
        this.keyboard = new Keyboard();
        this.world = new World(drawer);
        this.mouse = new Mouse(stage, world);

        player = new Player(keyboard, world, this);
        world.player = player;
        focusedElement = player;

        info = new ui.InfoDisplay(keyboard, world, this, player);
        world.info = info;

        drawWorld();
    }
	
	public function update(timeMod:Float) {
        // Do a game update
        keyboard.update();

        focusedElement.update();

        postUpdate();
	}

    public function focus(element:Focusable, redrawIfWorld:Bool = true) {
        focusedElement = element;

        if (element.showsWorld && redrawIfWorld) {
            drawWorld();
        }

        focusedElement.draw();
    }

    public function nextFocus(redrawWorld = false) {
        focus(player);

        drawWorld();
    }

    public function drawWorld() {
        drawer.clear();
        world.draw();
    }

    public function postUpdate() {
        keyboard.postUpdate();

        if (focusedElement.showsWorld) {
            //Mouse help if in world
            var mouseWorldPos = world.toWorldPoint(mouse.mousePosition);
            if (mouseWorldPos != null)
                drawer.setMouseHelp(world.getQuickExamine(mouseWorldPos));
            else
                drawer.setMouseHelp("");
        }
    }

    /**
     *  Before a player step
     */
    public function beforeStep() {
        drawer.clear();
        info.clear();
        world.preUpdate();
    }

    /**
     *  After a player step
     */
    public function afterStep() {
        world.update();

        info.processInfo(drawer);
    }
}