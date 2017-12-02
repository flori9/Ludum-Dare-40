import pixi.interaction.InteractionEvent;
import pixi.core.display.Container;
import pixi.extras.BitmapText;

import js.Browser;

class Game {
	public var rect:Rectangle; //The game rectangle
	
	public var application:Main;
    
	public var scaling:Int;
	
//	public var mouse:Mouse;

	var stage:Container;
    var drawer:Drawer;

	public function new(application, stage, gameRect) {
		this.application = application;
		this.stage = stage;
        this.rect = gameRect;
        this.drawer = new Drawer(stage);
        drawer.clear();
        drawer.setCharacter(0, 0, "&", 0xffff00);
        drawer.setCharacter(1, 1, "@", 0xffff00);
        drawer.setCharacter(2, 1, "*", 0x00ff00);
        drawer.setCharacter(3, 2, "!", 0x00ff00);
        drawer.setWall(0, 1);
        drawer.setWall(1, 0);
        drawer.setWall(2, 0);
        drawer.setWall(3, 0);
        drawer.setWall(3, 1);
    }
	
	public function update(timeMod:Float) {
        // Do a game update
        
	}
}