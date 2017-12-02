import de.polygonal.ds.ArrayedQueue;

class Pathfinder {
    var world:World;

    public function new(world:World) {
        this.world = world;
    }

    public function find(fromPosition:Point, isGoal:Point->Bool, all:Bool = true):Array<{point:Point, inDirection:Direction, distance:Int}> {
        var visited = [for (i in 0...world.width) [for (j in 0...world.height) false]];
        var queue = new ArrayedQueue<Point>();
        var firstDirection:Map<Point, Direction> = new Map<Point, Direction>();
        var totalDistance:Map<Point, Int> = new Map<Point, Int>();
        var foundPositions = [];
        queue.enqueue(fromPosition);
        visited[fromPosition.x][fromPosition.y] = true;
        firstDirection[fromPosition] = null;
        totalDistance[fromPosition] = 0;

        while (!queue.isEmpty()) {
            var queueItem = queue.dequeue();
            var firstDir = firstDirection[queueItem];
            var thisDistance = totalDistance[queueItem];
            if (queueItem != fromPosition && isGoal(queueItem)) {
                foundPositions.push({point: queueItem, inDirection: firstDir, distance: thisDistance});
                if (!all)
                    break;
            }

            if (queueItem == fromPosition || ! world.elementsAtPosition(queueItem).any(function(elem) return elem.isBlocking)) {
                if (queueItem.x > 0 && !visited[queueItem.x - 1][queueItem.y])
                {
                    visited[queueItem.x - 1][queueItem.y] = true;
                    var newPoint = new Point(queueItem.x - 1, queueItem.y);
                    firstDirection[newPoint] = firstDir == null ? Left : firstDir;
                    totalDistance[newPoint] = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
                if (queueItem.y > 0 && !visited[queueItem.x][queueItem.y - 1])
                {
                    visited[queueItem.x][queueItem.y - 1] = true;
                    var newPoint = new Point(queueItem.x, queueItem.y - 1);
                    firstDirection[newPoint] = firstDir == null ? Up : firstDir;
                    totalDistance[newPoint] = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
                if (queueItem.x < world.width - 1 && !visited[queueItem.x + 1][queueItem.y])
                {
                    visited[queueItem.x + 1][queueItem.y] = true;
                    var newPoint = new Point(queueItem.x + 1, queueItem.y);
                    firstDirection[newPoint] = firstDir == null ? Right : firstDir;
                    totalDistance[newPoint] = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
                if (queueItem.y < world.height - 1 && !visited[queueItem.x][queueItem.y + 1])
                {
                    visited[queueItem.x][queueItem.y + 1] = true;
                    var newPoint = new Point(queueItem.x, queueItem.y + 1);
                    firstDirection[newPoint] = firstDir == null ? Down : firstDir;
                    totalDistance[newPoint] = thisDistance + 1;
                    queue.enqueue(newPoint);
                }
            }
        }

        return foundPositions;
    }
}