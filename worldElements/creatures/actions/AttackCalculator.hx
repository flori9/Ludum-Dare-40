package worldElements.creatures.actions;

enum AttackResult {
    Damage(damage:Int);
    Block;
}

class AttackCalculator {
    public static function basicAttack(attackingCreature:Creature, attackedCreature:Creature) {
        var attackPart = attackingCreature.stats.attack;
        var defencePart = attackedCreature.stats.defence;

        var damage = attackPart - defencePart;
        attackedCreature.stats.hp -= damage;

        var result:AttackResult;
        if (damage > 0) {
            result = Damage(damage);
        } else {
            if (defencePart > 0)
                result = Block;
            else
                result = Damage(0);
        }

        return result;
    }
}