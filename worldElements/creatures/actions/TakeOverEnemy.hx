package worldElements.creatures.actions;

class TakeOverEnemy extends DirectionAction {
    override function get_actionPoints() return 5;

    public function new(creature) {
        super(creature);
        
        this.abilityName = "Mind Control";
        this.abilityDescription = "Take over an enemy next to you. Make sure you're at least somewhat safe, as you won't be able to move your own body until you end the mind control.";
    }

    public override function canUseOnElement(elementHere:WorldElement) {
        return Std.is(elementHere, Creature);
    }

    public override function useOnElement(elementHere:WorldElement) {
        var creatureHere:Creature = cast elementHere;
        creature.world.info.addInfo("You started mind controlling " + creatureHere.getNameToUse() + ".");
        creature.world.player.controllingBody = creatureHere;
        creature.world.player.afterTakeover();
    }
}