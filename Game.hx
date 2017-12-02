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

	public function new(application, stage, gameRect) {
		this.application = application;
		this.stage = stage;
        this.rect = gameRect;
        
        //Start the game
        var txt = new BitmapText("hsdfad", {font:"font", tint: 0xffffff});
        stage.addChild(txt);
	}
	
	public function update(timeMod:Float) {
        // Do a game update
        
		// //Do mouse updates here
		// mouseBeginStep();
		
		// //Handle the mouse of the city
		// if (city != null)
		// 	city.handleMouse(mouse);
		
		// //Then, handle the update of the city
		// if (city != null)
		// 	city.update(timeMod);
		
		// mouseEndStep(timeMod);
	}
	
	// /** Set down and pressed vars. */
	// function mouseBeginStep() {
	// 	if (mouse.nextStepReleased) {
	// 		mouse.down = false;
	// 		mouse.nextStepReleased = false;
	// 		mouse.released = true;
	// 	}
	// 	if (mouse.nextStepDown) {
	// 		mouse.down = true;
	// 		mouse.pressed = true;
	// 		mouse.nextStepDown = false;
	// 	}
	// 	if (mouse.nextStepRightReleased) {
	// 		mouse.rightDown = false;
	// 		mouse.nextStepRightReleased = false;
	// 		mouse.rightReleased = true;
	// 	}
	// 	if (mouse.nextStepRightDown) {
	// 		mouse.rightDown = true;
	// 		mouse.rightPressed = true;
	// 		mouse.nextStepRightDown = false;
	// 	}
	// 	if (mouse.nextStepMiddleReleased) {
	// 		mouse.middleDown = false;
	// 		mouse.nextStepMiddleReleased = false;
	// 		mouse.middleReleased = true;
	// 	}
	// 	if (mouse.nextStepMiddleDown) {
	// 		mouse.middleDown = true;
	// 		mouse.middlePressed = true;
	// 		mouse.nextStepMiddleDown = false;
	// 	}
	// }
	
	// /** Mouse will no longer be pressed/released. */
	// function mouseEndStep(timeMod:Float) {
	// 	mouse.pressed = false;
	// 	mouse.released = false;
	// 	mouse.rightPressed = false;
	// 	mouse.rightReleased = false;
	// 	mouse.middlePressed = false;
	// 	mouse.middleReleased = false;
	// 	if (mouse.mouseDownTick > 0) {
	// 		mouse.mouseDownTick -= timeMod;
	// 	}
	// }
	
	// /**
	//  *  Handle all possible actions
	//  *  @param stage - The stage on which to handle those actions
	//  */
	// function initInteraction(stage:Container) {
	// 	function mouseUpFunc(e:InteractionEvent) {
	// 		var button = (cast e.data.originalEvent).button;
	// 		if (button == null)
	// 			button = 0;
	// 		if (button == 1) {
	// 			mouse.nextStepMiddleDown = false;
	// 			mouse.nextStepMiddleReleased = true;
	// 		} else if (button == 2) {
	// 			mouse.nextStepRightDown = false;
	// 			mouse.nextStepRightReleased = true;
	// 		} else if (button == 0) {
	// 			mouse.nextStepDown = false;
	// 			mouse.nextStepReleased = true;
	// 		}
	// 	}
		
	// 	function updatePointerPos(stageLocalPos:Point) {
	// 		mouse.position = stageLocalPos;
	// 		mouse.gamePosition = mouse.position.subtract(new Point(addX, addY));
	// 		if (city != null)
	// 			mouse.cityPosition = mouse.gamePosition.add(city.viewPos);
	// 	}
		
	// 	mouse = new Mouse();
		
	// 	stage.interactive = true;
	// 	stage.on("pointermove", function(e:InteractionEvent) {
	// 		updatePointerPos(Point.fromPixiPoint(e.data.getLocalPosition(stage)));
	// 	});
		
	// 	stage.on("pointerdown", function(e:InteractionEvent) {
	// 		var origev = cast e.data.originalEvent;

	// 		mouse.isTouch = (origev.pointerType == "touch" ||
	// 			(origev.touches != null && origev.touches.length > 0));
			
	// 		updatePointerPos(Point.fromPixiPoint(e.data.getLocalPosition(stage)));
			
	// 		var button = origev.button;
	// 		if (button == null)
	// 			button = 0;
	// 		if (button == 1) { //Middle mouse button
	// 			mouse.nextStepMiddleDown = true;
	// 			mouse.nextStepMiddleReleased = false;
	// 		} else if (button == 2) {
	// 			mouse.nextStepRightReleased = false;
	// 			mouse.nextStepRightDown = true;
	// 		} else if (button == 0) {
	// 			mouse.nextStepDown = true;
	// 			mouse.nextStepReleased = false;
	// 		}
	// 	});
		
	// 	stage.on("pointerup", mouseUpFunc);
	// 	stage.on("pointerupoutside", mouseUpFunc);
	// }
}