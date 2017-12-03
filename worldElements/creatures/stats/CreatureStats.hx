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
    public var speed:Int;

    public var apRegen:Int; //Turns
    public var hpRegen:Int; //Turns

    public var timeToNextAPRegen:Int;
    public var timeToNextHPRegen:Int;

    public var maxHP:Int;
    public var maxAP:Int;

    public function new(hp:Int, ap:Int, attack:Int = 0, defence:Int = 0) {
        maxHP = hp;
        maxAP = ap;
        this.attack = attack;
        this.defence = defence;
    
        this.hp = hp;
        this.ap = ap;
        this.speed = 100;
        apRegen = 10;
        hpRegen = 10;
        timeToNextAPRegen = 10;
        timeToNextHPRegen = 10;
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

    public function setHPRegen(regen) {
        hpRegen = regen;
        timeToNextHPRegen = Math.imin(timeToNextHPRegen, regen);
    }

    public function setAPRegen(regen) {
        apRegen = regen;
        timeToNextAPRegen = Math.imin(timeToNextAPRegen, regen);
    }

    public function gainHP(gain) {
        hp = Math.imin(hp + gain, maxHP);
    }

    public function gainAP(gain) {
        ap = Math.imin(ap + gain, maxAP);
    }
}