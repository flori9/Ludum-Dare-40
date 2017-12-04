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
    public var info:ui.InfoDisplay;

    var focusedElement:Focusable;
    public var finished = false;

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
        
        world.generateLevel();

        drawWorld();
    }

    public function restartGame() {
        drawer.destroy();
        application.startGame();
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

        //Quick info always
        updateQuickInfo();
    }

    public function nextFocus(redrawWorld = false) {
        focus(player);

        drawWorld();

        //Quick info always
        updateQuickInfo();
    }

    public function drawWorld() {
        drawer.clear();
        world.draw();

        updateQuickInfo();
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

    public function updateQuickInfo() {
        if (finished)
            return;

        var quickInfoText = 'Floor ${world.floor}/${world.floorAmount}.';
        if (player.ownBody.stats.hp <= 0)
            quickInfoText += " You're dead!";
        else
            quickInfoText += " " + player.controllingBody.stats.getInfo();
        if (player.ownBody != player.controllingBody)
            quickInfoText += '; Ctrl: ${player.loseMindControlIn}';
        drawer.setQuickInfo(quickInfoText);
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
        updateQuickInfo();
    }
}