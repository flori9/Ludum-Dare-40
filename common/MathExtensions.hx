package common;

class MathExtensions {
    public static inline function sign(cls:Class<Math>, num:Float) {
        return if (num > 0) 1;
        else if (num < 0) -1;
        else 0;
    }
    
    public static inline function clamp(cls:Class<Math>, val:Float, minVal:Float, maxVal:Float) {
        return if (val < minVal)
            minVal;
        else if (val > maxVal)
            maxVal;
        else
            val;
    }
    
    public static inline function iclamp(cls:Class<Math>, val:Int, minVal:Int, maxVal:Int):Int {
        return if (val < minVal)
            minVal;
        else if (val > maxVal)
            maxVal;
        else
            val;
    }
    
    //Min for ints
    public static inline function imin(cls:Class<Math>, val1:Int, val2:Int) {
        return val2 < val1 ? val2 : val1;
    }
    
    //Max for ints
    public static inline function imax(cls:Class<Math>, val1:Int, val2:Int) {
        return val2 > val1 ? val2 : val1;
    }
    
    //Integer division
    public static inline function div(cls:Class<Math>, val1:Int, val2:Int):Int {
        return Std.int(val1 / val2);
    }
    
    /**Check if value is between two others
    First value inclusive, second one exclusive.*/
    public static inline function between(cls:Class<Math>, val:Float, lower:Float, upper:Float) {
        return val >= lower && val < upper;
    }
    
    public static inline function floorTo(cls:Class<Math>, val:Float, to:Int) {
        return Math.floor(val / to) * to;
    }
    
    //Integer abs
    public static inline function iabs(cls:Class<Math>, val:Int):Int {
        return val < 0 ? -val : val;
    }
    
    public static inline function lerp(cls:Class<Math>, val1:Float, val2:Float, lerpWith:Float) {
        return val1 + lerpWith * (val2 - val1);
    }
    
    public static inline function ilerp(cls:Class<Math>, val1:Float, val2:Float, lerpWith:Float) {
        return Std.int(Math.lerp(val1, val2, lerpWith));
    }
    
    /**
      Get any logaritm
      @param cls (math class)
      @param val (Value to log)
      @param logBy (What log to use (2 for example))
     */
    public static inline function logn(cls:Class<Math>, val:Float, logBy:Float) {
        return Math.log(val) / Math.log(logBy);
    }
    
    /**
      Format a float to a string with prec digits after the dot
      from https://stackoverflow.com/questions/23689001/how-to-reliably-format-a-floating-point-number-to-a-specified-number-of-decimal
      @param cls (math class)
      @param n The number
      @param prec The amount of digits after the dot
     */
    public static function floatFormat(cls:Class<Math>, n:Float, prec:Int) {
        n = Math.round(n * Math.pow(10, prec));
        var str = '' + n;
        var len = str.length;
        if (len <= prec) {
            while (len < prec) {
                str = '0' + str;
                len++;
            }
            return '0.' + str;
        }
        else {
            return str.substr(0, str.length-prec) + '.' +
                str.substr(str.length-prec);
        }
    }
}