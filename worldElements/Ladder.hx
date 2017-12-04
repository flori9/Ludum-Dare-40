package worldElements;

import worldElements.creatures.Creature;

class Ladder extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return false;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return false;

    public var isUp(get, never):Bool;
    function get_isUp() return world.floor == world.floorAmount;

    override function init() {
        color = 0xBBBCA4;
        character = "#";
    }
    
    public override function getInfo():String {
        return if (isUp)
            "A long ladder to the surface.";
        else
            "A ladder downwards.";
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
                if (isUp) {
                    world.finishGame();
                } else {
                    world.info.addInfo("You climbed down the ladder. It crumbled behind you.");
                    world.nextFloor();
                }
            } else if (world.player.controllingBody == triggeringCreature) {
                world.info.addInfo("You'd like to climb " + (isUp ? "up" : "down") +" the ladder with your own body.");
            }
        }
    }
}