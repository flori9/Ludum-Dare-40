package common;

class ArrayExtensions {
    /**
     *  Return the element from the array for which whereTrue and for which fn is largest
     *  @param array - The array to search for the maximum
     *  @param whereTrue - a requirement for item to be searched
     *  @param fn - Optional - a function to transform array elements.
     *  @return Float
     */
    public static function whereMax<T>(array:Array<T>, ?whereTrue:T->Bool, ?fn:T->Float) {
        if (fn == null)
            fn = function(val:T) return cast val;
        
        var arrayMaxVal = Math.NEGATIVE_INFINITY;
        var arrayMaxItem = null;
        for (item in array) {
            if (! whereTrue(item)) continue;
            
            var val = fn(item);
            if (val > arrayMaxVal) {
                arrayMaxItem = item;
                arrayMaxVal = val;
            }
        }
        return arrayMaxItem;
    }
    
    /**
     *  Returns the element from the array for which fn is largest
        @param array - The array to search for the maximum
        @param fn - Optional - a function to transform array elements.
        @return T
    */
    public static function max<T>(array:Array<T>, ?fn:T->Float):T {
        if (fn == null)
            fn = function(val:T) return cast val;
        
        var arrayMaxVal = Math.NEGATIVE_INFINITY;
        var arrayMaxItem = null;
        for (item in array) {
            var val = fn(item);
            if (val > arrayMaxVal) {
                arrayMaxItem = item;
                arrayMaxVal = val;
            }
        }
        return arrayMaxItem;
    }
    
    public static inline function maxValue<T>(array:Array<T>, fn:T->Float):Float {
        return fn(max(array, fn));
    }
    
    public static inline function maxValueI<T>(array:Array<T>, fn:T->Int):Int {
        return fn(max(array, fn));
    }
    
    /**
     *  Returns the element from the array for which fn is smallest
        @param array - The array to search for the minimum
        @param fn - Optional - a function to transform array elements.
        @return T
    */
    public static function min<T>(array:Array<T>, ?fn:T->Float):T {
        if (fn == null)
            fn = function(val:T) return cast val;
        
        var arrayMinVal = Math.POSITIVE_INFINITY;
        var arrayMinItem = null;
        for (item in array) {
            var val = fn(item);
            if (val < arrayMinVal) {
                arrayMinItem = item;
                arrayMinVal = val;
            }
        }
        return arrayMinItem;
    }
    
    public static inline function minValue<T>(array:Array<T>, fn:T->Float):Float {
        return fn(min(array, fn));
    }
    
    public static inline function minValueI<T>(array:Array<T>, fn:T->Int):Int {
        return fn(min(array, fn));
    }
    
    public static function sum<T>(array:Array<T>, ?fn:T->Float):Float {
        if (fn == null)
            fn = function(val:T) return cast val;
        
        var total:Float = 0;
        for (val in array)
            total += fn(val);
        return total;
    }
    
    /**
     *  Basically Lambda.exists, but not as buggy.
     *  @param array - The array
     *  @param fn - Function to check if there's any
     *  @return Bool
     */
    public static function any<T>(array:Array<T>, fn:T->Bool):Bool {
        for (val in array) {
           if (fn(val)) return true;
        }
        return false;
    }
    
    /**
     *  Returns whether array contains element in O(n)
     *  @param array - Array to search
     *  @param element - Element to look for
     *  @return Bool
     */
    public static function contains<T>(array:Array<T>, element:T):Bool {
        return array.indexOf(element) != -1;
    }
}