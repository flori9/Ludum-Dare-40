package worldElements;

import worldElements.creatures.Creature;
import items.Item;

class ItemOnFloor extends WorldElement {
    override function get_isBlocking() return true;
    override function get_isViewBlocking() return false;
    override function get_isStatic() return true;
    override function get_isEasierVisible() return false;

    var taken = false;
    var items:Array<Item>;
    public function new(world:World, position:Point, items:Array<Item>) {
        this.items = items;

        super(world, position);
    }

    override function init() {
        if (items.length == 1) {
            color = items[0].color;
            character = items[0].character;
        } else {
            color = 0xb0b0b0;
            character = "+";
        }

        moveAfterActionsForThis = true;
    }
    
    public override function getInfo():String {
        if (items.length == 1) {
            return items[0].aOrAn.firstToUpper() + " " + items[0].name + "."; //curseThing
        } else {
            return "A pile of items.";
        }
    }

    public override function hasActionFor(triggeringWorldElement:WorldElement) {
        if (taken) return false;

        if (Std.is(triggeringWorldElement, Creature)) {
            var triggeringCreature:Creature = cast triggeringWorldElement;
            return triggeringCreature.canTakeItems;
            //todo: show message if can't take
        }
        return false;
    }

    public override function performActionFor(triggeringWorldElement:WorldElement) {
        if (! taken) {
            if (Std.is(triggeringWorldElement, Creature)) {
                var triggeringCreature:Creature = cast triggeringWorldElement;
                for (item in items) {
                    if (triggeringCreature.isInterestingForPlayer()) {
                        world.info.addInfo('You took the ${item.name}.'); //curseThing
                        item.onTake(triggeringCreature);
                    }
                    triggeringCreature.inventory.push(item);
                }
                taken = true;
            }
        }
    }

    public override function shouldRemove() {
        return taken;
    }
}