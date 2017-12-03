package worldElements.creatures.actions;

class StopTakeOver extends CreatureAction {
    override function get_actionPoints() return 0;

    public function new(creature) {
        super(creature);
        
        this.abilityName = "Stop Mind Control";
        this.abilityDescription = "Stop mind controlling this creature.";
    }

    public override function canUse() {
        return true;
    }

    public override function use() {
        creature.world.info.addInfo("You stopped mind controlling and found yourself back in your own body.");
        creature.world.player.stopTakeover();
    }
}