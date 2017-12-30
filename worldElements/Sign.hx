package worldElements;

import worldElements.creatures.Creature;

class Sign extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return false;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return false;
    
    var info:String;
    
    public function new(world:World, position:Point, info:String) {
        this.info = info;

        super(world, position);
    }
    
    override function init() {
        color = 0xBA9A73;
        character = "?";
    }
    
    public override function getInfo():String {
        return "A signpost. Move into it to read it.";
    }

    public override function hasActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            var triggeringCreature:Creature = cast triggeringWorldElement;
            return world.player.controllingBody == triggeringCreature || world.player.ownBody == triggeringCreature;
        }
        return false;
    }

    public override function performActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            var triggeringCreature:Creature = cast triggeringWorldElement;
            if (world.player.ownBody == triggeringCreature || world.player.controllingBody == triggeringCreature) {
                    world.info.addInfo(info);
            }
        }
    }
}