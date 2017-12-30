package worldElements.creatures;
import worldElements.creatures.movement.*;
import worldElements.creatures.stats.CreatureStats;
import worldElements.creatures.actions.*;
import worldElements.creatures.statusEffects.StatusEffect;
import worldElements.creatures.statusModifiers.*;

@:keep
@:keepSub
class Creature extends WorldElement {
    public var movement:Movement;
    public var originalMovement:Movement;
    override function get_isBlocking() return true;
    public var hasMoved:Bool = false;
    public var stats:CreatureStats;
    public var creatureTypeName:String = "creature";
    public var creatureTypeAorAn:String = "a";
    public var creatureAttackVerb:String = "bit";
    public var creatureFullAttackVerb:String = "bite";

    public var attackedBy:Array<Creature> = [];
    /**
     *  Always attack creatures that have attacked leaders.
     */
    public var leaderCreatures:Array<Creature>;

    public var basicAttack:DirectionalAttack;
    public var actions:Array<CreatureAction>;

    //Creatures may move until they have less speedpoints than the player.
    var speedPoints:Int = 0;

    public var statusEffects:Array<StatusEffect>;

    public var statusModifiers(get, never):Array<StatusModifier>;
    function get_statusModifiers() {
        var mods:Array<StatusModifier> = [];
        for (se in statusEffects)
            mods.push(se);
        for (it in inventory)
            mods.push(it);
        return mods;
    }

    public var simpleStatusModifiers(get, never):Array<SimpleStatusModifier>;
    function get_simpleStatusModifiers() {
        var mods:Array<SimpleStatusModifier> = [];
        for (it in inventory) {
            for (se in it.modifiersWhileInInventory)
                mods.push(se);
        }
        return mods;
    }

    public function hasSimpleStatusModifier(mod) {
        return simpleStatusModifiers.contains(mod);
    }

    /**
     *  when we last saw things we want to follow
     */
    public var lastSeenCreature:Map<Creature, Int> = new Map<Creature, Int>();
    /**
     *  How long we will perfectly follow without seeing
     */
    public var followTimeWithoutSee = 3;
    /**
     *  Whether we're always aggressive towards the player
     */
    public var aggressiveToPlayer = false;
    /**
     *  Whether we're aggressive to the player if they come near
     */
    public var aggressiveToPlayerIfNear = false;
    /**
     *  Manhattan distance for aggression
     */
    public var aggressiveNearDistance = 2;
    public var wanderTo:Point = null;
    public var basePoint:Point = null;
    public var maxWanderDistance:Int = -1;
    public var canTakeItems:Bool = false;
    public var isUndead:Bool = false;

    public var inventory:Array<items.Item>;

    public override function init() {
        movement = new BasicMovement();
        originalMovement = movement;
        stats = new CreatureStats(this, 1, 1);
        basicAttack = new DirectionalAttack(this);
        actions = [];
        actions.push(basicAttack);
        attackedBy = [];
        inventory = [];
        statusEffects = new Array<StatusEffect>();
        leaderCreatures = [];
    }

    /**
     *  init as humanoid
     */
    public function initAsHumanoid() {
        canTakeItems = true;
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

        //Regain HP and AP
        stats.timeToNextAPRegen -= 1;
        if (stats.ap == stats.maxAP)
            stats.timeToNextAPRegen = stats.apRegen;
        if (stats.timeToNextAPRegen <= 0) {
            stats.gainAP(1);
            stats.timeToNextAPRegen = stats.apRegen;
        }

        stats.timeToNextHPRegen -= 1;
        if (stats.hp == stats.maxHP)
            stats.timeToNextHPRegen = stats.hpRegen;
        if (stats.timeToNextHPRegen <= 0) {
            stats.gainHP(1);
            stats.timeToNextHPRegen = stats.hpRegen;
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
        info += ".";

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
            if (world.player.ownBody == this && world.player.controllingBody != this)
                world.info.addInfo('While you were mind controlling, you have been defeated!'.firstToUpper());
            else
                world.info.addInfo('${getNameToUse()} ${getHaveOrHas()} been defeated.'.firstToUpper());

            //Drop any items they have
            if (world.player.ownBody != this) {
                if (inventory.length != 0)
                    world.addElement(new worldElements.ItemOnFloor(world, position, inventory));
            }
            
            //No longer a leader
            for (creature in world.creatures) {
                creature.leaderCreatures.remove(this);
            }
            return true;
        }
        return false;
    }

    public override function isInterestingForPlayer(controllingOnly = true) {
        return (!controllingOnly && world.player.ownBody == this) || world.player.controllingBody == this;
    }

    /**
     *  Get a full name, or you.
     */
    public function getNameToUse() {
        if (/*world.player.ownBody == this || */world.player.controllingBody == this)
            return "you";
        else
            return 'the $creatureTypeName';
    }

    /**
     *  Get a short reference, like "it"
     *  @param itself - 
     */
    public function getReferenceToUse(itself:Bool = false, object:Bool = false) {
        if (/*world.player.ownBody == this || */world.player.controllingBody == this)
            return itself ? "yourself" : "you";
        else
            return itself ? "itself" : "it";
        //he/himself/him
    }

    public function getAttackVerb() {
        return /*world.player.controllingBody == this ? creatureFullAttackVerb : */creatureAttackVerb;
    }

    public function getWereOrWas() {
        if (/*world.player.ownBody == this || */world.player.controllingBody == this)
            return "were";
        else
            return "was";
    }

    public function getOwnerReference() {
        if (world.player.controllingBody == this)
            return "your";
        else
            return "its";
    }

    public function getHaveOrHas() {
        if (/*world.player.ownBody == this || */world.player.controllingBody == this)
            return "have";
        else
            return "has";
    }

    public function addStatusEffect(statusEffect:StatusEffect) {
        statusEffects.push(statusEffect);
    }

    /**
     *  Whether it makes the given creature aggressive to it.
     *  @param creature - 
     */
    public function makesCreatureAggressive(creature:Creature) {
        return statusModifiers.any(function (sm) return sm.makesCreatureAggressive(creature));
    }
}