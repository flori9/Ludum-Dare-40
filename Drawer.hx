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
    
    static inline var leftPadding = 5;

    var screenX:Int;
    var screenY:Int;
    var worldX:Int;
    var worldY:Int;
    var worldWidth:Int;
    var worldHeight:Int;

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
                bitmap.position.set(leftPadding + j * singleWidth, i * singleHeight);
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
    
    public function setWorldView(screenX, screenY, worldX, worldY, width, height) {
        this.screenX = screenX;
        this.screenY = screenY;
        this.worldX = worldX;
        this.worldY = worldY;
        this.worldWidth = width;
        this.worldHeight = height;
    }

    public function setWorldCharacter(x, y, character, color = 0xffffff) {
        if (x >= worldX && y >= worldY && x < worldX + worldWidth && y < worldY + worldHeight) {
            setCharacter(x - worldX + screenX, y - worldY + screenY, character, color);
        }
    }

    public function setWorldWall(x, y, color = 0xffffff) {
        if (x >= worldX && y >= worldY && x < worldX + worldWidth && y < worldY + worldHeight) {
            setWall(x - worldX + screenX, y - worldY + screenY, color);
        }
    }
    
    public function setCharacter(x, y, character, color = 0xffffff) {
        bitmaps[y][x].text = character;
        bitmaps[y][x].tint = color;
    }
    
    public function setWall(x, y, color = 0xffffff) {
        wallGraphics.beginFill(color);
        wallGraphics.drawRect(x * singleWidth + leftPadding, y * singleHeight + 5, singleWidth, singleHeight);
        wallGraphics.endFill();
    }
}