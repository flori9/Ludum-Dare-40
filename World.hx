import worldElements.*;

class World {
    public var elements:Array<WorldElement>;
    /**
     *  Allows quick retrieval of elements at a given position
     */
    public var elementsByPosition:Array<Array<Array<WorldElement>>>;
    var drawer:Drawer;

    public var info:ui.InfoDisplay;
    public var player:Player;

    static inline var screenX = 0;
    static inline var screenY = 2;

    public static inline var displayWidth = 50;
    public static inline var displayHeight = 20;
    public var width = displayWidth;
    public var height = displayHeight;
    public var viewX = 0;
    public var viewY = 0;

    public function new(drawer:Drawer) {
        this.drawer = drawer;

        elements = new Array<WorldElement>();
        elementsByPosition = [for (i in 0...width)
            [for (j in 0...height) []]];
        
        elements.push(new Wall(this, new Point(0, 0)));
        elements.push(new Wall(this, new Point(1, 0)));
        elements.push(new Wall(this, new Point(2, 0)));
        elements.push(new Wall(this, new Point(3, 0)));
        elements.push(new worldElements.creatures.Rat(this, new Point(5, 2)));
    }

    public function addElement(element:WorldElement) {
        elements.push(element);
    }

    /**
     *  After setting any position, do this
     *  @param element - 
     */
    public function addToElementsAtPosition(element:WorldElement, position:Point) {
        elementsByPosition[position.x][position.y].push(element);
    }

    /**
     *  Before anything can move, do this
     *  @param element - 
     */
    public function removeFromElementsAtPosition(element:WorldElement, position:Point) {
        elementsByPosition[position.x][position.y].remove(element);
    }

    /**
     *  Called after the player has done a move.
     *  Does enemy movement and draws
     */
    public function update() {
        removeElementsWhereNeeded();

        for (element in elements) {
            element.update();
        }

        removeElementsWhereNeeded();

        draw();
    }

    public function removeElementsWhereNeeded() {
        var i = elements.length - 1;

        while (i >= 0) {
            var element = elements[i];
            if (element.shouldRemove()) {
                removeFromElementsAtPosition(element, element.position);
                elements.splice(i, 1);
            }

            i -= 1;
        }
    }

    public function draw() {
        drawer.setWorldView(screenX, screenY, viewX, viewY, displayWidth, displayHeight);
        for (element in elements) {
            element.draw(drawer);
        }
    }

    /**
     *  Return the point (null if none) in the given direction from the given point
     *  @param position - 
     *  @param direction - 
     */
    public function positionInDirection(position:Point, direction:Direction) {
        var newPosition = new Point(position.x, position.y);

        switch (direction) {
            case Up:
                newPosition.y -= 1;
            case Down:
                newPosition.y += 1;
            case Left:
                newPosition.x -= 1;
            case Right:
                newPosition.x += 1;
        }

        return if (isPositionInWorld(newPosition))
            newPosition;
        else
            null;
    }

    public function isPositionInWorld(position:Point) {
        return position.x >= 0 && position.y >= 0 && position.x < width && position.y < height;
    }

    public function elementsAtPosition(position:Point) {
        return elementsByPosition[position.x][position.y];
    }

    public function toWorldPoint(point:Point) {
        var newPoint = new Point(point.x, point.y);
        newPoint.x -= screenX + viewX;
        newPoint.y -= screenY + viewY;

        return if (isPositionInWorld(newPoint)) newPoint else null;
    }

    /**
     *  Get the examine at the given world position
     *  @param position - 
     */
    public function getQuickExamine(position:Point) {
        var help = "";
        for (element in elementsAtPosition(position)) {
            if (help != "") help += "\n";

            help += element.getInfo();
        }
        
        return help;
    }
}