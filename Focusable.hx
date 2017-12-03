class Focusable {
    var keyboard:Keyboard;
    var world:World;
    var game:Game;

    public var showsWorld(get, never):Bool;
    function get_showsWorld() return false;

    public function new(keyboard:Keyboard, world:World, game:Game) {
        this.keyboard = keyboard;
        this.world = world;
        this.game = game;
    }
    
    public function update() {

    }

    public function draw() {
        
    }
}