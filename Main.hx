import pixi.core.*;
import pixi.plugins.app.Application;
import js.Browser;

class Main extends Application {
	var loader:GameLoader; //The loader
	var game:Game; //The game. Can be null, while the game is being loaded.

	//The game width and height
	static inline var gameWidth = 960;
	static inline var gameHeight = 600;
	
	//Vars about how large/where we should draw to pass on to the game
	var gameRect:Rectangle;
    
	//Interaction
	var interact:pixi.interaction.InteractionManager;

	public function new() {
		super();

		init();
	}

	/** Initialize the display and game. */
	function init() {
		//Set parent vars
        autoResize = false;
		onUpdate = update;
		backgroundColor = 0x000000;
		clearBeforeRender = true;

		width = gameWidth;
		height = gameHeight;

		//Get config vars
		initConfig();
		
		//Finish init and start updating
		super.start();
	
        gameRect = new Rectangle(0, 0, gameWidth, gameHeight);
        
		//Load and then start the game
		loader = new GameLoader(function() {
			loader = null;
			game = new Game(this, stage, gameRect);
		});
		
		//Prevent right clicking from showing a context menu
		canvas.addEventListener("contextmenu", function(ev) {
			ev.preventDefault();
			return false;
		});
	}
	
	/**
	  Init some game configuration
	 */
	function initConfig() {
		try {
			var params = haxe.web.Request.getParams();
			
		} catch (e:Any) {}
	}
	
	/**
	  Update the game
	  @param elapsedTime - The number of 1/60 seconds timesteps that elapsed. Ideally, this would always be one, but
	  	if the game lags or is run on a non 60-hz display, it won't be.
	 */
	function update(elapsedTime:Float) {
		if (game != null)
			game.update(elapsedTime);
		else if (loader != null)
			loader.update();
	}

	/** Main entry point of the application, simply create this class. */
	static function main() {
		new Main();
	}
}