import worldElements.*;

class World {
    public var elements:Array<WorldElement>;
    /**
     *  Allows quick retrieval of elements at a given position
     */
    public var elementsByPosition:Array<Array<Array<WorldElement>>>;
    var drawer:Drawer;
    public var pathfinder:Pathfinder;

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

    var extraUpdates:Array<WorldElement>;

    public function new(drawer:Drawer) {
        this.drawer = drawer;
        this.pathfinder = new Pathfinder(this);

        elements = new Array<WorldElement>();
        elementsByPosition = [for (i in 0...width)
            [for (j in 0...height) []]];
        
        elements.push(new Wall(this, new Point(0, 0)));
        elements.push(new Wall(this, new Point(1, 0)));
        elements.push(new Wall(this, new Point(2, 0)));
        elements.push(new Wall(this, new Point(3, 0)));
        elements.push(new Wall(this, new Point(2, 1)));
        elements.push(new Wall(this, new Point(2, 2)));
        elements.push(new Wall(this, new Point(4, 1)));
        elements.push(new Wall(this, new Point(3, 2)));
        elements.push(new Wall(this, new Point(4, 2)));
        elements.push(new Wall(this, new Point(5, 2)));
        elements.push(new Wall(this, new Point(6, 1)));
        elements.push(new Wall(this, new Point(3, 1)));
        elements.push(new worldElements.creatures.Rat(this, new Point(5, 4)));
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
     *  Called before player has done a move
     */
    public function preUpdate() {
        for (element in elements) {
            element.preUpdate();
        }
    }

    /**
     *  Called after the player has done a move.
     *  Does enemy movement and draws
     */
    public function update() {
        removeElementsWhereNeeded();

        extraUpdates = [];

        for (element in elements) {
            element.update();
        }

        while (extraUpdates.length > 0) {
            removeElementsWhereNeeded();
            var processExtraUpdates = extraUpdates.copy();
            
            extraUpdates = [];

            for (elem in processExtraUpdates) {
                elem.preUpdate();
                elem.update(true);
            }
        }

        removeElementsWhereNeeded();

        for (element in elements) {
            element.postUpdate();
        }

        removeElementsWhereNeeded();

        draw();
    }

    /**
     *  If a worldelement is faster than the player, they get to request an extra update
     *  every now and then.
     *  @param elem - 
     */
    public function requestExtraUpdate(elem:WorldElement) {
        extraUpdates.push(elem);
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
            element.isCurrentlyVisible = false;

            if (pathfinder.isVisible(player.controllingBody.position, element.position, true)) {
                element.draw(drawer, false);
                element.seenByPlayer = true;
                element.isCurrentlyVisible = true;
            } else {
                if (element.isEasierVisible) {
                    var nowSeen = false;

                    var anyIndirectlyVisible = false;
                    forEachDirectionFromPoint(element.position, function(p) {
                        if (pathfinder.isVisible(player.controllingBody.position, p, true) && noBlockingElementsAt(p))
                            anyIndirectlyVisible = true;
                    });

                    if (anyIndirectlyVisible) {
                        nowSeen = true;
                        element.isCurrentlyVisible = true;
                        element.draw(drawer, false);
                        element.seenByPlayer = true;
                    }

                    if (! nowSeen && element.seenByPlayer) {
                        element.draw(drawer, true);
                        element.isCurrentlyVisible = true;
                    }
                }
            }
        }

        //If you see four view blockers around something, and that is a wall, show it as a wall too
        for (element in elements) {
            if (Std.is(element, Wall)) {
                var wall:Wall = cast element;
                if (! wall.seenByPlayer) {
                    var allAroundSeen = true;
                    forEachDirectionFromPoint(wall.position, function (p) {
                        if (noBlockingElementsAt(p) || elementsAtPosition(p).any(function (elem) return elem.isViewBlocking && !elem.seenByPlayer)) {
                            allAroundSeen = false;
                        }
                    });

                    if (allAroundSeen) {
                        wall.seenByPlayer = true;
                        wall.draw(drawer, true);
                        wall.isCurrentlyVisible = true;
                    }
                }
            }
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

    public function forEachDirectionFromPoint(position:Point, functionToExecute:Point->Void) {
        var left = new Point(position.x - 1, position.y);
        if (isPositionInWorld(left))
            functionToExecute(left);

        var right = new Point(position.x + 1, position.y);
        if (isPositionInWorld(right))
            functionToExecute(right);
        
        var up = new Point(position.x, position.y - 1);
        if (isPositionInWorld(up))
            functionToExecute(up);

        var down = new Point(position.x, position.y + 1);
        if (isPositionInWorld(down))
            functionToExecute(down);
    }

    public function isPositionInWorld(position:Point) {
        return position.x >= 0 && position.y >= 0 && position.x < width && position.y < height;
    }

    public function elementsAtPosition(position:Point) {
        return elementsByPosition[position.x][position.y];
    }

    public function noBlockingElementsAt(position:Point, viewBlockingOnly = true) {
        return ! elementsAtPosition(position).any(function (elem) return viewBlockingOnly ? elem.isViewBlocking : elem.isBlocking);
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
            if (element.isCurrentlyVisible) {
                if (help != "") help += "\n";

                help += element.getInfo();
            }
        }
        
        return help;
    }
}