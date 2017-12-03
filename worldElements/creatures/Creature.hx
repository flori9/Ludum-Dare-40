package worldElements.creatures;
import worldElements.creatures.movement.*;
import worldElements.creatures.stats.CreatureStats;
import worldElements.creatures.actions.*;
import worldElements.creatures.statusEffects.StatusEffect;

class Creature extends WorldElement {
    public var movement:Movement;
    override function get_isBlocking() return true;
    public var hasMoved:Bool = false;
    public var stats:CreatureStats;
    public var creatureTypeName:String = "creature";
    public var creatureTypeAorAn:String = "a";
    public var creatureAttackVerb:String = "bit";
    public var creatureFullAttackVerb:String = "bite";

    public var attackedBy:Array<Creature> = [];

    var basicAttack:DirectionalAttack;
    public var actions:Array<CreatureAction>;

    //Creatures may move until they have less speedpoints than the player.
    var speedPoints:Int = 0;

    public var statusEffects:Array<StatusEffect>;

    /**
     *  when we last saw things we want to follow
     */
    public var lastSeenCreature:Map<Creature, Int> = new Map<Creature, Int>();
    /**
     *  How long we will perfectly follow without seeing
     */
    public var followTimeWithoutSee = 3;
    /**
     *  Whether we're always aggresive towards the player
     */
    public var aggresiveToPlayer = false;
    public var wanderTo:Point = null;

    public override function init() {
        movement = new BasicMovement();
        stats = new CreatureStats(1, 1);
        basicAttack = new DirectionalAttack(this);
        actions = [];
        actions.push(basicAttack);
        attackedBy = [];
        statusEffects = new Array<StatusEffect>();
    }

    public override function preUpdate() {
        hasMoved = false;
    }

    public override function update(isExtra = false) {
        super.update();

        if (!hasMoved) {
            if (! isExtra) //Extra updates don't give speed points, of course
                speedPoints += stats.speed;
            var playerSpeed = world.player.controllingBody.stats.speed;

            if (speedPoints >= playerSpeed) {
                movement.move(world, this);
                hasMoved = true;

                speedPoints -= playerSpeed;
                if (speedPoints >= playerSpeed)
                    world.requestExtraUpdate(this);
            }
        }
    }

    public override function postUpdate() {
        var i = statusEffects.length;
        while (--i >= 0) {
            var statusEffect = statusEffects[i];
            statusEffect.onTurn();
            if (statusEffect.ended)
                statusEffects.splice(i, 1);
        }

        for (creature in lastSeenCreature.keys()) {
            lastSeenCreature[creature] += 1;
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

        var info = stats.getInfo();
        if (statusEffects.length > 0) {
            for (statusEffect in statusEffects) {
                if (info != "") info += "; ";
                info += statusEffect.name;
            }
        }

        return (pre + '$creatureTypeAorAn $creatureTypeName$post - $info').firstToUpper();
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

    public function getWereOrWas() {
        if (world.player.ownBody == this || world.player.controllingBody == this)
            return "were";
        else
            return "was";
    }

    public function addStatusEffect(statusEffect:StatusEffect) {
        statusEffects.push(statusEffect);
    }
}