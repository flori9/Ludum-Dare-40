import pixi.core.display.Container;
import pixi.extras.BitmapText;
import pixi.core.graphics.Graphics;

class Drawer {
    var stage:Container;
    var bitmaps:Array<Array<BitmapText>>;
    var wallGraphics:Graphics;
    
    public static inline var width = 50;
    public static inline var height = 24;
    
    public static inline var singleWidth = 15;
    public static inline var singleHeight = 25;
    
    public function new(stage:Container) {
        this.stage = stage;
        
        wallGraphics = new Graphics();
        stage.addChild(wallGraphics);
        
        //Start the game
        bitmaps = new Array<Array<BitmapText>>();
        for (i in 0...height)
        {
            bitmaps[i] = new Array<BitmapText>();
            for (j in 0...width)
            {
                var bitmap = new BitmapText("", {font:"font", tint: 0xffffff});
                bitmaps[i][j] = bitmap;
                bitmap.position.set(8 + j * singleWidth, i * singleHeight);
                stage.addChild(bitmap);
            }
        }
    }
    
    public function clear() {
        for (i in 0...height) {
            for (j in 0...width) {
                bitmaps[i][j].text = "";
            }
        }
        
        wallGraphics.clear();
    }
    
    public function setCharacter(x, y, character, color = 0xffffff) {
        bitmaps[y][x].text = character;
        bitmaps[y][x].tint = color;
    }
    
    public function setWall(x, y, color = 0xffffff) {
        wallGraphics.beginFill(color);
        wallGraphics.drawRect(x * singleWidth + 8, y * singleHeight + 5, singleWidth, singleHeight);
        wallGraphics.endFill();
    }
}