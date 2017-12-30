package worldElements.creatures.actions;

class TakeOverEnemy extends DirectionAction {
    override function get_actionPoints() return 5;

    var turnLength = 13;

    public function new(creature) {
        super(creature);
        
        this.abilityName = "Mind Control";
        this.abilityDescription = "Take over an enemy next to you. Make sure you're at least somewhat safe, as you won't be able to move your own body until you end the mind control. Also, you'll always lose mind control after " + (turnLength - 1) + " turns.";
    }

    public override function canUseOnElement(elementHere:WorldElement) {
        return Std.is(elementHere, Creature);
    }

    public override function useOnElement(elementHere:WorldElement) {
        var creatureHere:Creature = cast elementHere;
        creature.world.info.addInfo("You started mind controlling " + creatureHere.getNameToUse() + ".");
        creature.world.player.controllingBody = creatureHere;
        creature.world.player.loseMindControlIn = turnLength;
        creature.world.player.afterTakeover();
    }
}