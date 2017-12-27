import de.polygonal.ds.ArrayedQueue;
import worldElements.WorldElement;

class Pathfinder {
    var world:World;

    public function new(world:World) {
        this.world = world;
    }

    public function find(fromPosition:Point, isGoal:Point->Bool, all:Bool = true):Array<{point:Point, inDirection:Direction, distance:Int}> {
        var visited = [for (i in 0...world.width) [for (j in 0...world.height) false]];
        var queue = new ArrayedQueue<PathfindingPoint>();
        var foundPositions = [];
        var from = new PathfindingPoint(fromPosition);
        queue.enqueue(from);
        visited[fromPosition.x][fromPosition.y] = true;

        while (!queue.isEmpty()) {
            var queueItem = queue.dequeue();
            var firstDir = queueItem.direction;
            var thisDistance = queueItem.totalDistance;
            if (queueItem != from && isGoal(queueItem.point)) {
                foundPositions.push({point: queueItem.point, inDirection: firstDir, distance: thisDistance});
                if (!all)
                    break;
            }

            if (queueItem == from || ! world.elementsAtPosition(queueItem.point).any(function(elem) return elem.isBlocking)) {
                if (queueItem.x > 0 && !visited[queueItem.x - 1][queueItem.y])
                {
                    visited[queueItem.x - 1][queueItem.y] = true;
                    var newPoint = new PathfindingPoint(new Point(queueItem.x - 1, queueItem.y));
                    newPoint.direction = firstDir == null ? Left : firstDir;
                    newPoint.totalDistance = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
                if (queueItem.y > 0 && !visited[queueItem.x][queueItem.y - 1])
                {
                    visited[queueItem.x][queueItem.y - 1] = true;
                    var newPoint = new PathfindingPoint(new Point(queueItem.x, queueItem.y - 1));
                    newPoint.direction = firstDir == null ? Up : firstDir;
                    newPoint.totalDistance = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
                if (queueItem.x < world.width - 1 && !visited[queueItem.x + 1][queueItem.y])
                {
                    visited[queueItem.x + 1][queueItem.y] = true;
                    var newPoint = new PathfindingPoint(new Point(queueItem.x + 1, queueItem.y));
                    newPoint.direction  = firstDir == null ? Right : firstDir;
                    newPoint.totalDistance = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
                if (queueItem.y < world.height - 1 && !visited[queueItem.x][queueItem.y + 1])
                {
                    visited[queueItem.x][queueItem.y + 1] = true;
                    var newPoint = new PathfindingPoint(new Point(queueItem.x, queueItem.y + 1));
                    newPoint.direction = firstDir == null ? Down : firstDir;
                    newPoint.totalDistance = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
            }
        }

        return foundPositions;
    }

    /**
       Whether the second position can see the first one (no blocking/viewblocking objects between them)
       @param firstPosition - 
       @param secondPosition - 
       @param onlyViewBlocking Whether only viewblocking objects between the points are a problem (not other blocking ones)
     */
    public function isVisible(firstPosition:Point, secondPosition:Point, onlyViewBlocking:Bool = true, cornersAreBlocking:Bool = true) {
        function checkIfBlocking(elem:WorldElement) return onlyViewBlocking ? elem.isViewBlocking : elem.isBlocking;

        function checkPoint(y, x) {
            if ((firstPosition.x == x && firstPosition.y == y) || (secondPosition.x == x && secondPosition.y == y))
                return false;
            return world.elementsAtPosition(new Point(x, y)).any(checkIfBlocking);
        }

        var x1 = firstPosition.x, y1 = firstPosition.y, x2 = secondPosition.x, y2 = secondPosition.y;

        //http://eugen.dedu.free.fr/projects/bresenham/
        var i;               // loop counter 
        var ystep:Int, xstep:Int;    // the step on y and x axis 
        var error:Int;           // the error accumulated during the increment 
        var errorprev:Int;       // *vision the previous value of the error variable 
        var y:Int = y1, x:Int = x1;  // the line points 
        var ddy:Int, ddx:Int;        // compulsory variables: the double values of dy and dx 
        var dx:Int = x2 - x1; 
        var dy:Int = y2 - y1; 
        if (checkPoint(y1, x1))  // first point
            return false; 
        // NB the last point can't be here, because of its previous point (which has to be verified) 
        if (dy < 0) { 
            ystep = -1; 
            dy = -dy; 
        }
        else 
            ystep = 1; 
        if (dx < 0) { 
            xstep = -1; 
            dx = -dx; 
        }
        else 
            xstep = 1; 
        ddy = 2 * dy;
        ddx = 2 * dx; 
        if (ddx >= ddy) {  // first octant (0 <= slope <= 1) 
            // compulsory initialization (even for errorprev, needed when dx==dy) 
            errorprev = error = dx;  // start in the middle of the square 
            for (i in 0...dx) {  // do not use the first point (already done) 
                x += xstep; 
                error += ddy; 
                if (error > ddx) {  // increment y if AFTER the middle ( > ) 
                    y += ystep; 
                    error -= ddx; 
                    // three cases (octant == right->right-top for directions below): 
                    if (error + errorprev < ddx) {  // bottom square also 
                        if (checkPoint(y-ystep, x))
                            return false;
                    } else if (error + errorprev > ddx) { // left square also 
                        if (checkPoint(y, x-xstep))
                            return false;
                    } else if (cornersAreBlocking) {  // corner: bottom and left squares also 
                        if (checkPoint(y-ystep, x))
                            return false;
                        if (checkPoint(y, x-xstep))
                            return false;
                    }
                } 
                if (checkPoint(y, x))
                    return false;
                errorprev = error; 
            }
        } else {  // the same as above 
            errorprev = error = dy; 
            for (i in 0...dy) { 
                y += ystep; 
                error += ddx; 
                if (error > ddy) { 
                    x += xstep; 
                    error -= ddy; 
                    if (error + errorprev < ddy) {
                        if (checkPoint(y, x-xstep))
                            return false;
                    } else if (error + errorprev > ddy) {
                        if (checkPoint(y-ystep, x))
                            return false;
                    } else if (cornersAreBlocking) { 
                        if (checkPoint(y, x-xstep))
                            return false;
                        if (checkPoint(y-ystep, x))
                            return false;
                    } 
                } 
                if (checkPoint(y, x))
                    return false;
                errorprev = error; 
            } 
        } 

        // if (firstPosition.x == secondPosition.x) {
        //     var yy = Math.imin(firstPosition.y, secondPosition.y) + 1;
        //     while (yy < Math.imax(firstPosition.y, secondPosition.y) - 1) {
        //         if (world.elementsAtPosition(new Point(firstPosition.x, yy)).any(checkIfBlocking))
        //             return false;
        //         yy += 1;
        //     }
        // } else {

        // }

        return true;
    }
}

class PathfindingPoint {
    public var point(default, null):Point;

    public var x (get, never):Int;
    function get_x() return point.x;
    public var y (get, never):Int;
    function get_y() return point.y;
    public var direction:Direction = null;
    public var totalDistance:Int = 0;

    public function new(point:Point) {
        this.point = point;
    }
}