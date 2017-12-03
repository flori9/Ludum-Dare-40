package worldElements.creatures.actions;

using Lambda;

class RangedSpecialDirectionalAttack extends SpecialDirectionalAttack {
    var rangeInSquares = 1000;

    /**
     *  Use {damage} {attacker} {target} {reference} {selfreference} {butDefended}
     *  @param creature - 
     *  @param damageMultiplier - 
     *  @param criticalText - 
     *  @param damageText - 
     *  @param blockText - 
     */
    public function new(creature:Creature, damageMultiplier:Float, criticalText:String, damageText:String, blockText:String,
        abilityName:String, abilityDescription:String, ap:Int, rangeInSquares:Int, neverCrit:Bool = false, ?postAttack:Int->Void) {
        super(creature, damageMultiplier, criticalText, damageText, blockText,
            abilityName, abilityDescription, ap, neverCrit, postAttack);

        this.rangeInSquares = rangeInSquares;
    }

    public override function canUse() {
        var pos = creature.position;
        for (i in 0...rangeInSquares) {
            pos = creature.world.positionInDirection(pos, direction);
            if (creature.world.elementsAtPosition(pos).any(function (elem) return Std.is(elem, Creature)))
                return true;
            if (!creature.world.noBlockingElementsAt(pos, false))
                return false;
        }
        return false;
    }

    public override function canUseOnCreatureFrom(creatures:Array<Creature>) {
        var pos = creature.position;
        for (i in 0...rangeInSquares) {
            pos = creature.world.positionInDirection(pos, direction);
            if (canUseOnAnyCreatureFromElements(creature.world.elementsAtPosition(pos), creatures))
                return true;
            if (!creature.world.noBlockingElementsAt(pos, false))
                return false;
        }
        return false;
    }

    public override function use() {
        var pos = creature.position;
        for (i in 0...rangeInSquares) {
            pos = creature.world.positionInDirection(pos, direction);
            if (creature.world.elementsAtPosition(pos).any(function (elem) return Std.is(elem, Creature)))
            {
                //Use on the creature
                super.useOnElement(creature.world.elementsAtPosition(pos).find(function (elem) return Std.is(elem, Creature)));
                break;
            }
            if (!creature.world.noBlockingElementsAt(pos, false))
                break;
        }
    }
}