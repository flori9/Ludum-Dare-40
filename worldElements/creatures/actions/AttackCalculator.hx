package worldElements.creatures.actions;
import common.Random;

enum AttackResult {
    Damage(damage:Int);
    Critical(damage:Int);
    Block;
}

class AttackCalculator {
    public static function basicAttack(attackingCreature:Creature, attackedCreature:Creature, attackMultiplier:Float = 1, neverCrit = false) {
        var attackPartFloat:Float = attackingCreature.stats.attack;
        attackPartFloat = Random.getFloat(Math.ceil(attackPartFloat / 2), attackPartFloat + 1);
        attackPartFloat *= attackMultiplier;
        
        //Half rat damage
        //(todo: should be done differently, but this is easy for now)
        if (attackingCreature.hasSimpleStatusModifier(HalfDamageToRats) && Std.is(attackedCreature, Rat)) {
            attackPartFloat *= 0.5;
        }
        
        var attackPart = Math.floor(attackPartFloat);

        var defencePart = attackedCreature.stats.defence;
        var isCritical = false;
        if (!neverCrit && Random.getFloat() < attackingCreature.stats.critChance) {
            isCritical = true;
            attackPart += Math.ceil(attackingCreature.stats.attack * 0.5);
            defencePart = Math.imin(attackPart - 1, defencePart);
        }

        var damage = attackPart - defencePart;
        attackedCreature.stats.hp -= damage;

        var result:AttackResult;
        if (damage > 0) {
            if (isCritical)
                result = Critical(damage);
            else
                result = Damage(damage);
        } else {
            if (defencePart > 0)
                result = Block;
            else
                result = Damage(0);
        }

        attackStandardResults(attackingCreature, attackedCreature);

        return result;
    }

    public static function attackStandardResults(attackingCreature:Creature, attackedCreature:Creature) {
        //The attacked creature now knows the attacking creature has attacked them
        if (! attackedCreature.attackedBy.contains(attackingCreature))
            attackedCreature.attackedBy.push(attackingCreature);
    }
}