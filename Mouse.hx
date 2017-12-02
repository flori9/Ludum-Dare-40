using pixi.core.display.Container;
import pixi.interaction.InteractionEvent;

class Mouse {
    public var mouseRawPosition:Point = new Point(-1, -1);
    public var mousePosition:Point = new Point(-1, -1);

    public function new(stage:Container, world:World) {
        stage.interactive = true;
        stage.on("pointermove", function(e:InteractionEvent) {
            mouseRawPosition = Point.fromPixiPoint(e.data.getLocalPosition(stage));
            mousePosition = new Point(Math.div(mouseRawPosition.x, Drawer.singleWidth),
                Math.div(mouseRawPosition.y, Drawer.singleHeight));
        }); 
    }
}