import js.Browser;

class Keyboard {
    public var pressed:Array<Bool>;
    public var down:Array<Bool>;
    static inline var keys = 256;

    public static inline var arrowLeft = 37;
    public static inline var arrowUp = 38;
    public static inline var arrowRight = 39;
    public static inline var arrowDown = 40;
    public static inline var space = 32;
    public static inline var enter = 13;
    public static inline var escape = 27;
    public static inline var backspace = 8;

    public function anyConfirm() {
        return pressed[space] || pressed[enter];
    }

    public function anyBack() {
        return pressed[escape] || pressed[backspace];
    }

    public function new() {
        pressed = [for (i in 0...keys) false];
        down = [for (i in 0...keys) false];

        js.Browser.window.addEventListener("keydown", function(event:js.html.KeyboardEvent) {
            var keyCode = event.keyCode;
            if (keyCode < keys) {
                pressed[keyCode] = true;
                down[keyCode] = true;
            }
        }, false);

        js.Browser.window.addEventListener("keyup", function(event:js.html.KeyboardEvent) {
            var keyCode = event.keyCode;
            if (keyCode < keys) {
                down[keyCode] = false;
            }
        }, false);
    }

    public function update() {

    }

    public function postUpdate() {
        for (i in 0...keys) {
            pressed[i] = false;
        }
    }

    public static function getLetterCode(letter:String) {
        var code = letter.charCodeAt(0);
        if (code >= 97 && code <= 122)
            code -= 97 - 65;
        return code;
    }

    public function leftKey() {
        return pressed[Keyboard.arrowLeft] || pressed[Keyboard.getLetterCode('A')];
    }

    public function rightKey() {
        return pressed[Keyboard.arrowRight] || pressed[Keyboard.getLetterCode('D')];
    }

    public function upKey() {
        return pressed[Keyboard.arrowUp] || pressed[Keyboard.getLetterCode('W')];
    }

    public function downKey() {
        return pressed[Keyboard.arrowDown] || pressed[Keyboard.getLetterCode('S')];
    }
}