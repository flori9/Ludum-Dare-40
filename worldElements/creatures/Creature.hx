package worldElements.creatures;
import worldElements.creatures.movement.*;
import worldElements.creatures.stats.CreatureStats;
import worldElements.creatures.actions.*;

class Creature extends WorldElement {
    public var movement:Movement;
    override function get_isBlocking() return true;
    public var hasMoved:Bool = false;
    public var stats:CreatureStats;
    public var creatureTypeName:String = "creature";
    public var creatureTypeAorAn:String = "a";
    public var creatureAttackVerb:String = "bit";
    public var creatureFullAttackVerb:String = "bite";

    var basicAttack:DirectionalAttack;

    public override function init() {
        movement = new BasicMovement();
        stats = new CreatureStats(1, 1);
        basicAttack = new DirectionalAttack(this);
    }

    public override function preUpdate() {
        hasMoved = false;
    }

    public override function update() {
        super.update();

        if (!hasMoved) {
            movement.move(world, this);
            hasMoved = true;
        }
    }

    public override function getInfo():String {
        var pre = "", post = "";
        if (world.player.ownBody == this && world.player.controllingBody == this)
            pre = "You, ";
        else if (world.player.controllingBody == this)
            post = ", controlled by you";
        else if (world.player.ownBody == this)
            pre = "Your own body, ";

        return (pre + '$creatureTypeAorAn $creatureTypeName$post - ${stats.getInfo()}').firstToUpper();
    }

    public override function hasActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            //The action is "attack"!
            return true;
        }
        return false;
    }

    public override function performActionFor(triggeringWorldElement:WorldElement) {
        if (Std.is(triggeringWorldElement, Creature)) {
            (cast triggeringWorldElement:Creature).attack(this);
        }
    }

    /**
     *  Attack any creature with a basic attack
     *  @param what - 
     */
    public function attack(what:Creature) {
        basicAttack.useOnElement(what);
    }

    public override function shouldRemove() {
        if (stats.hp <= 0) {
            //Yeah, this should be removed, and also show a message
            world.info.addInfo('${getNameToUse()} has been defeated.'.firstToUpper());
            return true;
        }
        return false;
    }

    public override function isInterestingForPlayer() {
        return world.player.ownBody == this || world.player.controllingBody == this;
    }

    /**
     *  Get a full name, or you.
     */
    public function getNameToUse() {
        if (world.player.ownBody == this || world.player.controllingBody == this)
            return "you";
        else
            return 'the $creatureTypeName';
    }

    /**
     *  Get a short reference, like "it"
     *  @param itself - 
     */
    public function getReferenceToUse(itself:Bool = false) {
        if (world.player.ownBody == this || world.player.controllingBody == this)
            return itself ? "yourself" : "you";
        else
            return itself ? "itself" : "it";
    }
}