import pixi.core.display.Container;
import pixi.extras.BitmapText;
import pixi.core.graphics.Graphics;

enum Color {
    Red;
    Green;
    Blue;
    Black;
    White;
    Gray;
    LightBlue;
    Purple;
    Yellow;
}

class Drawer {
    var stage:Container;
    var bitmaps:Array<Array<BitmapText>>;
    var wallGraphics:Graphics;
    
    public static inline var width = 50;
    public static inline var height = 24;
    
    public static inline var singleWidth = 15;
    public static inline var singleHeight = 25;
    
    static inline var leftPadding = 0;
    static inline var topRemove = 5;

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
                bitmap.position.set(leftPadding + j * singleWidth, i * singleHeight - topRemove);
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
            setBackground(x - worldX + screenX, y - worldY + screenY, color);
        }
    }
    
    public function setCharacter(x, y, character, color = 0xffffff) {
        if (x < 0 || y < 0 || x >= width || y >= height)
            return;

        bitmaps[y][x].text = character;
        bitmaps[y][x].tint = color;
    }
    
    public function setBackground(x, y, color = 0xffffff) {
        if (x < 0 || y < 0 || x >= width || y >= height)
            return;

        wallGraphics.beginFill(color);
        wallGraphics.drawRect(x * singleWidth + leftPadding, y * singleHeight, singleWidth, singleHeight);
        wallGraphics.endFill();
    }

    /**
     *  Draw the given text. Returns the number of lines used
     *  @param x - 
     *  @param y - 
     *  @param text - 
     *  @param color = 0xffffff - 
     *  @param wrap = true - 
     *  @param maxWidth = 0
     */
    public function drawText(x, y, text:String, color = 0xffffff, wrap = true, maxWidth = -1):Int {
        var numberOfLines = 0;
        var minX = x, maxX /*x after max*/ = maxWidth == -1 ? width : Math.min(width, x + maxWidth);

        var lines = text.split("\n");
        for (line in lines) {
            var words = line.split(" ");
            for (word in words) {
                if (x + word.length >= maxX) {
                    x = minX;
                    y += 1;
                    numberOfLines += 1;
                }

                for (i in 0...word.length) {
                    setCharacter(x, y, word.charAt(i), color);
                    x += 1;
                }

                x += 1;
            }

            numberOfLines += 1;
            y += 1;
            x = minX;
        }

        return numberOfLines;
    }

    public static function colorToInt(color:Color) {
        return switch (color) {
            case Black: 0x000000;
            case White: 0xffffff;
            case Gray: 0x808080;
            case Green: 0x00ff00;
            case Blue: 0x0000ff;
            case Red: 0xff0000;
            case Yellow: 0xffff00;
            case LightBlue: 0x42c5f4;
            case Purple: 0x8a3fc6;
        }
    }
}