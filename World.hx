import worldElements.*;

import worldElements.creatures.Creature;
import items.artifacts.*;

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

    public var remainingArtifacts:Array<{artifact:items.artifacts.Artifact, minFloor:Int}>;

    public var floor:Int = 1;
    public var floorAmount:Int = 5;

    public var creatures(get, never):Array<Creature>;
    function get_creatures()
        return elements.filter(function (elem) return Std.is(elem, Creature)).map(function (elem) return cast elem);

    public function new(drawer:Drawer) {
        this.drawer = drawer;
        this.pathfinder = new Pathfinder(this);

        elements = new Array<WorldElement>();
        elementsByPosition = [for (i in 0...width)
            [for (j in 0...height) []]];
        
        initArtifacts();
    }

    public function initArtifacts() {
        remainingArtifacts = [
            { artifact: new GobletOfForgetfulness(), minFloor: 1 },
            { artifact: new UnclearGlasses(), minFloor: 1 },
            { artifact: new DiamondBell(), minFloor: 2 },
            { artifact: new BeltOfSlowness(), minFloor: 3 },
            { artifact: new WingsOfPeace(), minFloor: 3 }
        ];
    }

    public function nextFloor() {
        floor++;
        generateLevel();
        player.onNewFloor(floor);
    }

    public function generateLevel() {
        new dungeonGeneration.DungeonGenerator(this, floor);
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

        //Player afterStep
        player.afterStep();

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
        var isDebugMode = false;

        drawer.setWorldView(screenX, screenY, viewX, viewY, displayWidth, displayHeight);

        var visibleElements:Array<WorldElement> = [];
        var elemAt = [for (i in 0...width)[for (j in 0...height) false]];

        var playerIsForgetfull = player.controllingBody.hasSimpleStatusModifier(Forgetfullness) ||
            player.ownBody.hasSimpleStatusModifier(Forgetfullness);
        var worseSight = player.controllingBody.hasSimpleStatusModifier(WorseSight);
        var maxSeeDistance = worseSight ? 5.01 : 100;

        var centerX = player.controllingBody.position.x, centerY = player.controllingBody.position.y;

        for (element in elements) {
            element.isCurrentlyVisible = false;

            var canSee = Math.sqrt((element.position.x - centerX) * (element.position.x - centerX) +
                (element.position.y - centerY) * (element.position.y - centerY)) <= maxSeeDistance;

            if (canSee && pathfinder.isVisible(player.controllingBody.position, element.position, true)) {
                visibleElements.push(element);
                elemAt[element.position.x][element.position.y] = true;
            } else {
                if (element.isEasierVisible) {
                    var nowSeen = false;

                    var anyIndirectlyVisible = false;
                    if (canSee) {
                        forEachDirectionFromPoint(element.position, function(p) {
                            if (pathfinder.isVisible(player.controllingBody.position, p, true) && noBlockingElementsAt(p))
                                anyIndirectlyVisible = true;
                        });
                    }

                    if (anyIndirectlyVisible) {
                        nowSeen = true;
                        visibleElements.push(element);
                        elemAt[element.position.x][element.position.y] = true;
                    }

                    if ((! nowSeen && element.isStatic && element.seenByPlayer && !playerIsForgetfull) || isDebugMode) {
                        element.draw(drawer, true);
                        element.isCurrentlyVisible = true;
                    }
                } else if ((element.isStatic && element.seenByPlayer && !playerIsForgetfull) || isDebugMode)
                    element.draw(drawer, true);
            }
        }


        var shouldBeVisible = [for (i in 0...width)[for (j in 0...height) false]];
        function floodFill(x, y) {
            shouldBeVisible[x][y] = true;
            var xx = x - 1, yy = y;
            if (isPositionInWorld(new Point(xx, yy)) && (!shouldBeVisible[xx][yy] && elemAt[xx][yy]))
                floodFill(xx, yy);
            var xx = x + 1, yy = y;
            if (isPositionInWorld(new Point(xx, yy)) && (!shouldBeVisible[xx][yy] && elemAt[xx][yy]))
                floodFill(xx, yy);
            var xx = x, yy = y - 1;
            if (isPositionInWorld(new Point(xx, yy)) && (!shouldBeVisible[xx][yy] && elemAt[xx][yy]))
                floodFill(xx, yy);
            var xx = x, yy = y + 1;
            if (isPositionInWorld(new Point(xx, yy)) && (!shouldBeVisible[xx][yy] && elemAt[xx][yy]))
                floodFill(xx, yy);
        }
        
        floodFill(centerX, centerY);

        for (element in visibleElements) {
            if (shouldBeVisible[element.position.x][element.position.y]) {
                element.isCurrentlyVisible = true;
                element.draw(drawer, false);
                element.seenByPlayer = true;
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
                var thisInfo = element.getInfo();
                if (thisInfo != "") {
                    if (help != "") help += "\n";

                    help += thisInfo;
                }
            }
        }
        
        return help;
    }
}