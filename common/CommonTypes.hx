package common;

import pixi.core.math.shapes.Rectangle as PixiRect;
import pixi.core.math.Point as PixiPoint;

class Rectangle {
    public var x:Int;
    public var y:Int;
    public var width:Int;
    public var height:Int;
    
    public var position(get, set):Point;
    
    public var x2(get, never):Int;
    function get_x2() return x + width;
    public var y2(get, never):Int;
    function get_y2() return y + height;
    
    public var centerX(get, never):Int;
    function get_centerX() return x + Math.div(width, 2);
    public var centerY(get, never):Int;
    function get_centerY() return y + Math.div(height, 2);

    public inline function new(x, y, width, height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    public function overlaps(other:Rectangle) {
        return x < other.x2 && x2 > other.x && y < other.y2 && y2 > other.y;
    }
    
    public function contains(point:Point) {
        return Math.between(point.x, x, x + width) && Math.between(point.y, y, y + height);
    }

    public inline function toPixiRect() {
        return new PixiRect(x, y, width, height);
    }
    
    public static function fromPixiRect(rect:PixiRect) {
        return new Rectangle(Std.int(rect.x), Std.int(rect.y), Std.int(rect.width), Std.int(rect.height));
    }
    
    inline function get_position() {
        return new Point(x, y);
    }
    
    inline function set_position(newPos:Point) {
        return new Point(x = newPos.x, y = newPos.y);
    }
}

class Point {
    public var x:Int;
    public var y:Int;
    
    public inline function new(x, y) {
        this.x = x;
        this.y = y;
    }
    
    public static inline function fromPixiPoint(point) {
        return new Point(Math.floor(point.x), Math.floor(point.y));
    }
    
    public inline function toPixiPoint() {
        return new PixiPoint(x, y);
    }
    
    public inline function add(otherPoint:Point) {
        return new Point(x + otherPoint.x, y + otherPoint.y);
    }
    
    public inline function subtract(otherPoint:Point) {
        return new Point(x - otherPoint.x, y - otherPoint.y);
    }

    public inline function equals(otherPoint:Point)
        return x == otherPoint.x && y == otherPoint.y;

    public inline function manhattanDistance(otherPoint:Point)
        return Math.abs(x - otherPoint.x) + Math.abs(y - otherPoint.y);
}

class FPoint {
    public var x:Float;
    public var y:Float;
    
    public var length(get, never):Float;
    function get_length() return Math.sqrt(x * x + y * y);
    
    public inline function new(x, y) {
        this.x = x;
        this.y = y;
    }
    
    public inline function toPoint() {
        return new Point(Math.round(x), Math.round(y));
    }
}

typedef Padding = {top:Int, right:Int, bottom:Int, left:Int}

enum Direction { Left; Right; Up; Down; }