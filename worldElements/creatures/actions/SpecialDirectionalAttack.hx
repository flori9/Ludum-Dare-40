package worldElements.creatures.actions;

using StringTools;

class SpecialDirectionalAttack extends DirectionalAttack {
    var damageMultiplier:Float;
    var criticalText:String;
    var damageText:String;
    var blockText:String;
    var ap:Int;
    var neverCrit:Bool;
    var postAttack:Int->Void;

    override function get_actionPoints() return ap;
    
    /**
     *  Use {damage} {attacker} {target} {reference} {selfreference} {butDefended}
     *  @param creature - 
     *  @param damageMultiplier - 
     *  @param criticalText - 
     *  @param damageText - 
     *  @param blockText - 
     */
    public function new(creature:Creature, damageMultiplier:Float, criticalText:String, damageText:String, blockText:String,
        abilityName:String, abilityDescription:String, ap:Int, neverCrit:Bool = false, ?postAttack:Int->Void) {
        super(creature);

        this.damageMultiplier = damageMultiplier;
        this.criticalText = criticalText;
        this.damageText = damageText;
        this.blockText = blockText;
        this.abilityName = abilityName;
        this.abilityDescription = abilityDescription;
        this.ap = ap;
        this.neverCrit = neverCrit;
        this.postAttack = postAttack;
    }

    public override function useOnElement(elementHere:WorldElement) {
        var creatureHere:Creature = cast elementHere;
        var result = AttackCalculator.basicAttack(creature, creatureHere, damageMultiplier, neverCrit);
        if (postAttack != null) {
            postAttack(switch(result) {
                case Critical(damage): damage;
                case Damage(damage): damage;
                case Block: 0;
            });
        }
        if (creature.isInterestingForPlayer() || elementHere.isInterestingForPlayer()) {
            var text = switch (result) {
                case Critical(damage): criticalText.replace("{damage}", '$damage');
                case Damage(damage): damageText.replace("{damage}", '$damage');
                case Block: blockText;
            }
            text = text.replace("{attacker}", creature.getNameToUse());
            text = text.replace("{attackerReference}", creature.getReferenceToUse(false, true));
            text = text.replace("{owner}", creature.getOwnerReference());
            text = text.replace("{target}", creatureHere.getNameToUse());
            text = text.replace("{butDefended}", "but {reference} defended {selfreference}");
            text = text.replace("{reference}", creatureHere.getReferenceToUse());
            text = text.replace("{selfreference}", creatureHere.getReferenceToUse(true));
            
            text = text.firstToUpper();
            creature.world.info.addInfo(text);
        }
    }
}