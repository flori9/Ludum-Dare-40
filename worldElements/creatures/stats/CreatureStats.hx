package worldElements.creatures.stats;

class CreatureStats {
    /** Health */
    public var hp:Int;
    /**
     *  Action points
     */
    public var ap:Int;
    public var attack:Int;
    public var defence:Int;

    public var maxHP:Int;
    public var maxAP:Int;

    public function new(hp:Int, ap:Int, attack:Int = 0, defence:Int = 0) {
        maxHP = hp;
        maxAP = ap;
        this.attack = attack;
        this.defence = defence;
    
        this.hp = hp;
        this.ap = ap;
    }

    public function getInfo():String {
        return 'HP: $hp/$maxHP; AP: $ap/$maxAP';
    }

    public function setMaxHP(newMaxHP) {
        var diff = newMaxHP - maxHP;
        maxHP = newMaxHP;
        hp += diff;
    }

    public function setMaxAP(newMaxAP) {
        var diff = newMaxAP - maxAP;
        maxAP = newMaxAP;
        ap += diff;
    }

    public function setAttack(attack) {
        this.attack = attack;
    }
}