package dungeonGeneration;

import worldElements.*;
import worldElements.creatures.*;
import common.Random;

enum RoomType {
    PlayerStart;
    Treasure;
    Monsters;
    End;
    None;
}

class DungeonGenerator {
    var world:World;
    var width:Int;
    var height:Int;
    var playerBody:Creature;
    var floor:Int;

    public function new(world:World, floor:Int = 1) {
        this.world = world;
        this.floor = floor;
        width = world.width;
        height = world.height;

        playerBody = world.player.ownBody;
        clearWorld();
        generateWorld();
    }

    public function clearWorld() {
        world.elements = new Array<WorldElement>();
        world.elementsByPosition = [for (i in 0...width)
            [for (j in 0...height) []]];
    }

    public function generateWorld() {
        generateBasicDungeon();
    }

    public function generateBasicDungeon() {
        var basicDungeon:Array<Array<Bool>> = [for (x in 0...width) [for (y in 0...height) false]];
        var rooms:Array<Rectangle> = [];
        var minWidth = 3, maxWidth = 6;
        var minHeight = 3, maxHeight = 6;
        var minDistance = 2;
        var minimumRoomAmount = Random.getInt(11, 16);
        var maxIterations = 10000;
        var i = 0;

        //Start by generating a lot of random rooms that do not overlap
        while (rooms.length < minimumRoomAmount && ++i < maxIterations) {
            var rectWidth = Random.getInt(minWidth, maxWidth);
            var rectHeight = Random.getInt(minHeight, maxHeight);
            if (rectWidth == 3 && rectHeight == 3) {
                if (Random.getInt(2) == 1)
                    rectWidth = 4;
                else
                    rectHeight = 4;
            }
            var newRoom = new Rectangle(Random.getInt(1, width - rectWidth), Random.getInt(1, height - rectHeight), rectWidth, rectHeight);
            var newRoomCollider = new Rectangle(newRoom.x - minDistance, newRoom.y - minDistance, newRoom.width + minDistance * 2, newRoom.height + minDistance * 2);
            var overlaps = false;
            for (rect in rooms) {
                if (rect.overlaps(newRoomCollider)) {
                    overlaps = true;
                    break;
                }
            }
            if (! overlaps) {
                rooms.push(newRoom);
            }
        }
        
        var paths:Array<RoomPath> = [];

        //Then create paths between them
        for (i in 0...rooms.length) {
            var room = rooms[i];
            for (j in i + 1...rooms.length) {
                var otherRoom = rooms[j];
                var hasIntersection = false;

                for (possiblyIntersectingRoom in rooms) {
                    if (possiblyIntersectingRoom == room || possiblyIntersectingRoom == otherRoom)
                        continue;

                    if (lineIntersectsRect(possiblyIntersectingRoom, room.centerX, room.centerY, otherRoom.centerX, otherRoom.centerY)) {
                        hasIntersection = true;
                        break;
                    }
                }

                if (! hasIntersection) {
                    //Add a path between these two rooms
        	        paths.push(new RoomPath(room, otherRoom));
                }
            }
        }

        //Prim's alg (very slow implementation, but who cares for a game jam)
        var retry = true;
        var newPaths = [];

        while (retry) {
            retry = false;

            var unusedRooms = rooms.copy();
            var usedRooms = [rooms[0]];
            unusedRooms.remove(usedRooms[0]);
            while (unusedRooms.length >= 0) {
                var minimumWidthPath = null, minimumLength = 100000.0, newPathRoom = null;
                for (path in paths) {
                    var wouldBeNewRoom = null;
                    if (unusedRooms.contains(path.room1) && usedRooms.contains(path.room2)) {
                        wouldBeNewRoom = path.room1;
                    } else if (unusedRooms.contains(path.room2) && usedRooms.contains(path.room1)) {
                        wouldBeNewRoom = path.room2;
                    }
                    if (wouldBeNewRoom != null) {
                        var len = new Point(path.room1.centerX, path.room1.centerY).manhattanDistance(new Point(path.room2.centerX, path.room2.centerY));
                        if (len < minimumLength) {
                            minimumLength = len;
                            newPathRoom = wouldBeNewRoom;
                            minimumWidthPath = path;
                        }
                    }
                }

                if (minimumWidthPath == null) {
                    if (unusedRooms.length >= 3) {
                        retry = true;
                        newPaths = [];
                    } else {
                        for (room in unusedRooms) {
                            rooms.remove(room);
                        }
                    }
                    break;
                } else {
                    unusedRooms.remove(newPathRoom);
                    usedRooms.push(newPathRoom);
                    newPaths.push(minimumWidthPath);
                }
            }
        }

        var oldPaths = paths;
        paths = newPaths;
        var suboptimalsFrom = paths.length;
        //Add in some old paths even though they were not exactly optimal
        for (i in 0...5) {
            var path = Random.fromArray(oldPaths);
            if (! paths.contains(path))
                paths.push(path);
        }

        //Carve out the rooms and the paths
        for (room in rooms) {
            for (i in 0...room.width) {
                for (j in 0...room.height)
                    basicDungeon[room.x + i][room.y + j] = true;
            }
        }

        for (i in 0...paths.length) {
            var path = paths[i];

            var isSuboptimal = i >= suboptimalsFrom;

            /**
             *  Set basic dungeon to true. Returns whether we want it to stop then
             *  @param x - 
             *  @param y - 
             */
            function setBasicDungeon(x:Int, y:Int):Bool {
                //if (isSuboptimal && basicDungeon[x][y])
                //    return false;
                basicDungeon[x][y] = true;
                return false;
            }

            var room1 = path.room1;
            var room2 = path.room2;

            var leftRoom = room1.x < room2.x ? room1 : room2;
            var rightRoom = room1 == leftRoom ? room2 : room1;

            var topRoom = room1.y < room2.y ? room1 : room2;
            var bottomRoom = room1 == topRoom ? room2 : room1;
            var yOverlapMin = Math.imax(room1.y, room2.y), yOverlapMax = Math.imin(room1.y2, room2.y2);
            if (yOverlapMax > yOverlapMin) {
                var yy = Random.getInt(yOverlapMin, yOverlapMax);
                for (xx in leftRoom.x2...rightRoom.x) {
                    if (setBasicDungeon(xx, yy)) break;
                }
                continue;
            }

            var xOverlapMin = Math.imax(room1.x, room2.x), xOverlapMax = Math.imin(room1.x2, room2.x2);
            if (xOverlapMax > xOverlapMin) {
                var xx = Random.getInt(xOverlapMin, xOverlapMax);
                for (yy in topRoom.y2...bottomRoom.y) {
                    if (setBasicDungeon(xx, yy)) break;
                }
                continue;
            }

            //No direct overlap in coords, need to make two paths
            if (Random.getInt(2) == 1) {
                var toX = Random.getInt(rightRoom.x, rightRoom.x2);
                var fromY = Random.getInt(leftRoom.y, leftRoom.y2);
                var stop = false;
                //First, a path to the right
                for (xx in leftRoom.x2...toX + 1) {
                    if (setBasicDungeon(xx, fromY)) {
                        stop = true;
                        break;
                    }
                }
                if (! stop) {
                    //Then, a path upwards/downwards
                    var minY = Math.imin(fromY + 1, rightRoom.y2);
                    var maxY = Math.imax(fromY, rightRoom.y);
                    for (yy in minY...maxY)
                        if (setBasicDungeon(toX, yy)) break;
                }
            } else {
                var toY = Random.getInt(bottomRoom.y, bottomRoom.y2);
                var fromX = Random.getInt(topRoom.x, topRoom.x2);
                var stop = false;
                //First, a path downwards
                for (yy in topRoom.y2...toY + 1) {
                    if (setBasicDungeon(fromX, yy)) {
                        stop = true;
                        break;
                    }
                }
                if (! stop) {
                    //Then, a path upwards/downwards
                    var minX = Math.imin(fromX + 1, bottomRoom.x2);
                    var maxX = Math.imax(fromX, bottomRoom.x);
                    for (xx in minX...maxX)
                        if (setBasicDungeon(xx, toY)) break;
                }
            }
        }

        for (x in 0...width) {
            for (y in 0...height) {
                if (!basicDungeon[x][y]) {
                    world.addElement(new Wall(world, new Point(x, y)));
                } else
                    world.addElement(new Floor(world, new Point(x, y)));
            }
        }

        var roomFunction:Map<Rectangle, RoomType> = new Map<Rectangle, RoomType>();
        for (room in rooms)
            roomFunction[room] = None;

        //Give each room a function
        //The leftmost room will be that of the player, a room in the right the exit
        var playerRoom = rooms.min(function (r) return r.x);
        roomFunction[playerRoom] = PlayerStart;

        function getUnusedRooms() return rooms.filter(function(r) return roomFunction[r] == None);
        function getUnusedRoomsRandomOrder() {
            //Do some wacky shuffle that's good enough
            var unused = getUnusedRooms();
            unused.sort(function(_, _2) return Random.fromArray([-1, 1]));
            return unused;
        }

        //Fill some of the unused rooms with monsters
        var roomsStillToFill = getUnusedRoomsRandomOrder();
        for (i in 0...roomsStillToFill.length - 2)
            roomFunction[roomsStillToFill[i]] = Monsters;

        for (room in roomFunction.keys()) {
            switch (roomFunction[room]) {
                case PlayerStart:
                    playerBody.position = new Point(room.centerX, room.centerY);
                    world.addElement(playerBody);
                case Monsters:
                    //Add the monster(s)
                    addMonsters(room);
                case End:
                    //Add the exit
                case Treasure:
                    //Add the treasure
                case None:
                    //Nothing in the room
            }
        }

        return basicDungeon;
    }

    function anyEmptyPositionInRoom(room:Rectangle) {
        var tries = 0;
        while (tries < 1000) {
            var pointX = Random.getInt(room.x, room.x2),
                pointY = Random.getInt(room.y, room.y2);
            if (world.noBlockingElementsAt(new Point(pointX, pointY)))
                return new Point(pointX, pointY);
        }
        return null;
    }

    public function addMonsters(room:Rectangle) {
        var points = 2 + Random.getInt(floor);
        var creatureOptions = [{type: Goblin, points: 2}, {type: Rat, points: 1}, {type: ManeatingPlant, points: 1}];
        for (i in 0...100) {
            var creatureOption = Random.fromArray(creatureOptions);

            if (points >= creatureOption.points) {
                var position = anyEmptyPositionInRoom(room);
                world.addElement(Type.createInstance(creatureOption.type, [world, position]));
                points -= creatureOption.points;
            }
        }
    }

    public static function lineIntersectsRect(rect:Rectangle, p1X:Float,
        p1Y:Float,
        p2X:Float,
        p2Y:Float) {
            return segmentIntersectRectangle(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height,
                p1X, p1Y, p2X, p2Y);
    }

    //https://stackoverflow.com/questions/5514366/how-to-know-if-a-line-intersects-a-rectangle
    public static function segmentIntersectRectangle(
        rectangleMinX:Float,
        rectangleMinY:Float,
        rectangleMaxX:Float,
        rectangleMaxY:Float,
        p1X:Float,
        p1Y:Float,
        p2X:Float,
        p2Y:Float):Bool
    {
        // Find min and max X for the segment
        var minX = p1X;
        var maxX = p2X;

        if (p1X > p2X)
        {
            minX = p2X;
            maxX = p1X;
        }

        // Find the intersection of the segment's and rectangle's x-projections
        if (maxX > rectangleMaxX)
        {
            maxX = rectangleMaxX;
        }

        if (minX < rectangleMinX)
        {
            minX = rectangleMinX;
        }

        if (minX > maxX) // If their projections do not intersect return false
        {
            return false;
        }

        // Find corresponding min and max Y for min and max X we found before
        var minY = p1Y;
        var maxY = p2Y;

        var dx = p2X - p1X;

        if (Math.abs(dx) > 0.0000001)
        {
            var a = (p2Y - p1Y)/dx;
            var b = p1Y - a*p1X;
            minY = a*minX + b;
            maxY = a*maxX + b;
        }

        if (minY > maxY)
        {
            var tmp = maxY;
            maxY = minY;
            minY = tmp;
        }

        // Find the intersection of the segment's and rectangle's y-projections
        if (maxY > rectangleMaxY)
        {
            maxY = rectangleMaxY;
        }

        if (minY < rectangleMinY)
        {
            minY = rectangleMinY;
        }

        if (minY > maxY) // If Y-projections do not intersect return false
        {
            return false;
        }

        return true;
    }
}

class RoomPath {
    public var room1:Rectangle;
    public var room2:Rectangle;

    public function new(room1, room2) {
        this.room1 = room1;
        this.room2 = room2;
    }
}