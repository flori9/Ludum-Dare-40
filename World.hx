import worldElements.*;

class World {
    public var elements:Array<WorldElement>;
    /**
     *  Allows quick retrieval of elements at a given position
     */
    public var elementsByPosition:Array<Array<Array<WorldElement>>>;
    var drawer:Drawer;

    static inline var screenX = 0;
    static inline var screenY = 1;

    public var width = 20;
    public var height = 20;

    public function new(drawer:Drawer) {
        elements = new Array<WorldElement>();
        elementsByPosition = [for (i in 0...width)
            [for (j in 0...height) []]];

        elements.push(new Wall(this, new Point(0, 0)));
        elements.push(new Wall(this, new Point(1, 0)));
    }

    /**
     *  After setting any position, do this
     *  @param element - 
     */
    public function addToElementsAtPosition(element:WorldElement) {
        elementsByPosition[element.position.x][element.position.y].push(element);
    }

    /**
     *  Before anything can move, do this
     *  @param element - 
     */
    public function removeFromElementsAtPosition(element:WorldElement) {
        elementsByPosition[element.position.x][element.position.y].remove(element);
    }

    /**
     *  Called after the player has done a move.
     *  Does enemy movement and draws
     */
    public function update() {
        for (element in elements) {
            element.update();
        }

        draw();
    }

    public function draw() {
        drawer.setWorldView(screenX, screenY, 0, 0, width, height);
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
}