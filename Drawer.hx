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
    DarkGray;
    LightGray;
}

class Drawer {
    var stage:Container;
    var bitmaps:Array<Array<BitmapText>>;
    var wallGraphics:Graphics;
    
    public static inline var width = 50;
    public static inline var height = 24;
    
    public static inline var singleWidth = 15;
    public static inline var singleHeight = 25;
    
    public static inline var mouseHelpY = height - 2;

    static inline var leftPadding = 0;
    static inline var topRemove = 5;

    static inline var notVisibleAlpha = 0.5;

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
        clearLines(0, height);
        
        wallGraphics.clear();
    }
    
    public function clearLines(start:Int, amount:Int) {
        for (i in start...start + amount) {
            for (j in 0...width) {
                bitmaps[i][j].text = "";
            }
        }
    }

    /**
     *  The last 2 lines while playing in a world are reserved for mouse help.
     *  Change this with this function
     */
    public function setMouseHelp(text:String) {
        clearLines(mouseHelpY, height - mouseHelpY);

        var yy = mouseHelpY;
        if (getAmountOfLines(0, mouseHelpY, "Examine: " + text) == 1)
            yy += 1;

        var col = 0x000000;
        if (text != "")
            col = colorToInt(DarkGray);

        setMultiBackground(0, yy, "Examine:".length, col);
        setMultiBackground(0, yy == mouseHelpY ? mouseHelpY + 1 : mouseHelpY, "Examine:".length, 0x000000);
        
        if (text != "")
            drawText(0, yy, "Examine: " + text);
    }

    public function setMultiBackground(x, y, width, col) {
        for (i in x...x + width)
            setBackground(i, y, col);
    }

    public function setWorldView(screenX, screenY, worldX, worldY, width, height) {
        this.screenX = screenX;
        this.screenY = screenY;
        this.worldX = worldX;
        this.worldY = worldY;
        this.worldWidth = width;
        this.worldHeight = height;
    }

    public function setWorldCharacter(x, y, character, color = 0xffffff, notInView = false) {
        if (x >= worldX && y >= worldY && x < worldX + worldWidth && y < worldY + worldHeight) {
            setCharacter(x - worldX + screenX, y - worldY + screenY, character, color, notInView ? notVisibleAlpha : 1);
        }
    }

    public function setWorldWall(x, y, color = 0xffffff, notInView = false) {
        if (x >= worldX && y >= worldY && x < worldX + worldWidth && y < worldY + worldHeight) {
            setBackground(x - worldX + screenX, y - worldY + screenY, color, notInView ? notVisibleAlpha : 1);
        }
    }
    
    public function setCharacter(x, y, character, color = 0xffffff, alpha = 1.0) {
        if (x < 0 || y < 0 || x >= width || y >= height)
            return;

        bitmaps[y][x].text = character;
        bitmaps[y][x].tint = color;
        bitmaps[y][x].alpha = alpha;
    }
    
    public function setBackground(x, y, color = 0xffffff, alpha = 1.0) {
        if (x < 0 || y < 0 || x >= width || y >= height)
            return;

        wallGraphics.beginFill(color, alpha);
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
    public function drawText(x, y, text:String, color = 0xffffff, wrap = true, maxWidth = -1, ?getMaxX:Int->Int->Int):Int {
        var lines = splitIntoLines(x, y, text, wrap, maxWidth, getMaxX);
        var minX = x;
        
        for (line in lines) {
            for (i in 0...line.length) {
                setCharacter(x, y, line.charAt(i), color);
                x += 1;
            }

            y += 1;
            x = minX;
        }

        return lines.length;
    }

    //getMaxX: normal max x -> lineNumber -> max x
    public function splitIntoLines(x, y, text:String, wrap = true, maxWidth = -1, ?getMaxX:Int->Int->Int) {
        var minX = x, maxX /*x after max*/ = maxWidth == -1 ? width : Math.imin(width, x + maxWidth);
        if (getMaxX == null)
            getMaxX = function(i, j) return i;
        var lines = text.split("\n");
        var finalLines = [];
        var finalLine = "";
        for (line in lines) {
            var words = line.split(" ");
            for (word in words) {
                if (x + word.length >= getMaxX(maxX, finalLines.length)) {
                    finalLines.push(finalLine);
                    finalLine = "";

                    x = minX;
                    y += 1;
                }
                
                if (finalLine != "")
                    finalLine += " ";
                finalLine += word;

                x += word.length + 1;
            }

            finalLines.push(finalLine);
            finalLine = "";
            y += 1;
            x = minX;
        }

        return finalLines;
    }

    public function getAmountOfLines(x, y, text:String, wrap = true, maxWidth = -1, ?getMaxX:Int->Int->Int) {
        return splitIntoLines(x, y, text, wrap, maxWidth, getMaxX).length;
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
            case DarkGray: 0x404040;
            case LightGray: 0xb0b0b0;
        }
    }
}