package worldElements;

import worldElements.creatures.Creature;

class Ladder extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return false;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return false;

    override function init() {
        color = 0xBBBCA4;
        character = "#";
    }
    
    public override function getInfo():String {
        return "A ladder downwards.";
    }

    public override function hasActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            var triggeringCreature:Creature = cast triggeringWorldElement;
            //The action is "move down" || "show the player they can't do that"!
            return world.player.controllingBody == triggeringCreature || world.player.ownBody == triggeringCreature;
        }
        return false;
    }

    public override function performActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            var triggeringCreature:Creature = cast triggeringWorldElement;
            if (world.player.ownBody == triggeringCreature) {
                //Move down
                world.info.addInfo("You climbed down the ladder. It crumbled behind you.");
                world.nextFloor();
            } else if (world.player.controllingBody == triggeringCreature) {
                world.info.addInfo("You'd like to climb down the ladder with your own body.");
            }
        }
    }
}