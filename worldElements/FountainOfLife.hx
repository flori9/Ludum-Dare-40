package worldElements;

import worldElements.creatures.Creature;
import items.Item;

class FountainOfLife extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return false;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return false;


    override function init() {
        color = 0x4893BF;
        character = "¶";
    }
    
    public override function getInfo():String {
        return "A beautiful fountain.";
    }

    public override function hasActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            return true;
        }
        return false;
    }

    public override function performActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            var triggeringCreature:Creature = cast triggeringWorldElement;
            if (triggeringCreature.isUndead) {
                if (triggeringCreature.isInterestingForPlayer()) {
                    world.info.addInfo("You drink from the fountain and lose 2 HP.");
                }
                triggeringCreature.stats.hp -= 2;
            } else {
                if (triggeringCreature.isInterestingForPlayer()) {
                    world.info.addInfo("You drink from the fountain and gain 2 HP.");
                }
                triggeringCreature.stats.gainHP(2);
            }
        }
    }
}