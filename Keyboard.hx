import js.Browser;

class Keyboard {
    public var pressed:Array<Bool>;
    public var down:Array<Bool>;
    static inline var keys = 256;

    public static inline var arrowLeft = 37;
    public static inline var arrowUp = 38;
    public static inline var arrowRight = 39;
    public static inline var arrowDown = 40;

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
}