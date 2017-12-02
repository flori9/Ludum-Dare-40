package common;

/**
 *  Unseeded but fast random. Much faster than SeedeableRandom.
 */
class Random {
    /**
     *  Get an integer. First value always incl, second excl:
     *  No arguments: from 0 to maxint.
     *  @param val0 - (optional) only this: max, otherwise min
     *  @param val1 - (optional) max
     */
    public static function getFloat(?val0:Float, ?val1:Float) {
        var min:Float = 0, max:Float = 1;
        if (val0 != null && val1 != null) {
            min = val0;
            max = val1;
        } else if (val0 != null) {
            max = val0;
        }
        return Math.random() * (max - min) + min;
    }
    
    /**
     *  Get an int. First value always incl, second excl:
     *  No arguments: from 0 to 1.
     *  @param val0 - (optional) One argument: from 0 to val0.
     *  @param val1 - (optional) Two arguments: from val0 to val1.
     */
    public static function getInt(?val0:Int, ?val1:Int) {
        var min = 0, max = 2147483647;
        if (val0 != null && val1 != null) {
            min = val0;
            max = val1;
        } else if (val0 != null) {
            max = val0;
        }
        return Math.floor(Math.random() * (max - min)) + min;
    }
    
    /**
     *  Get a random value from the array.
     *  @param arr - The array to get an item from
     *  @return T - A random item from the array
     */
    public static function fromArray<T>(arr:Array<T>):T {
        if (arr.length == 0) throw "You can't get a random item from an empty array!";
        
        return arr[getInt(arr.length)];
    }
}