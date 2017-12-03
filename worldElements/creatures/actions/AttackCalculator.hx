package worldElements.creatures.actions;
import common.Random;

enum AttackResult {
    Damage(damage:Int);
    Critical(damage:Int);
    Block;
}

class AttackCalculator {
    public static function basicAttack(attackingCreature:Creature, attackedCreature:Creature) {
        var attackPart = attackingCreature.stats.attack;
        attackPart = Random.getInt(Math.ceil(attackPart / 2), attackPart + 1);
        var defencePart = attackedCreature.stats.defence;
        var isCritical = false;
        if (Random.getFloat() < attackingCreature.stats.critChance) {
            isCritical = true;
            attackPart += Math.ceil(attackingCreature.stats.attack * 0.67);
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