package common;

class StringExtensions {
    public static inline function firstToUpper(str:String) {
        if (str.length == 0)
            return str;
        else
            return str.charAt(0).toUpperCase() + str.substr(1);
    }
}