import worldElements.creatures.statusEffects.Poison;
import worldElements.creatures.actions.*;

using Lambda;

class Player extends Focusable {
    public var ownBody:worldElements.creatures.Creature;
    public var controllingBody:worldElements.creatures.Creature;

    var statusEffectsMenuKey:Int;
    var actionsKey:Int;
    var waitKey:Int;

    override function get_showsWorld() return true;

    public function new(keyboard:Keyboard, world:World, game:Game) {
        super(keyboard, world, game);

        ownBody = new worldElements.creatures.Human(world, new Point(1, 1));
        ownBody.movement.autoMove = false;
        world.addElement(ownBody);
        controllingBody = ownBody;

        statusEffectsMenuKey = Keyboard.getLetterCode("e");
        actionsKey = 16; //shift
        waitKey = 190; //.

        // ownBody.actions.push(new AfflictStatusEffect(ownBody, Poison, function(c) return new Poison(c),
        //     "{subject} poisoned {object}!", 1,
        //     "Poisonous Strike", "Poison an enemy next to you."));
        ownBody.actions.push(new Dash(ownBody));
        ownBody.actions.push(new TakeOverEnemy(ownBody));
    }

    public function afterTakeover() {
        controllingBody.movement.autoMove = false;
        controllingBody.actions.push(new StopTakeOver(ownBody));
    }

    public function stopTakeover() {
        if (controllingBody.stats.hp > 0) {
            controllingBody.movement.autoMove = true;
            var stopTakeOverAction = controllingBody.actions.find(function (ac) return Std.is(ac, StopTakeOver));
            if (stopTakeOverAction != null)
                controllingBody.actions.remove(stopTakeOverAction);
        }

        controllingBody = ownBody;
    }

    public override function update() {
        if (ownBody.stats.hp <= 0) {
            //You are dead!
            if (keyboard.anyConfirm())
                game.restartGame();
            return;
        }

        var xMove = 0, yMove = 0;

        if (keyboard.leftKey())
            xMove -= 1;
        if (keyboard.rightKey())
            xMove += 1;
        if (keyboard.upKey())
            yMove -= 1;
        if (keyboard.downKey())
            yMove += 1;
        
        var moveDirection = null;
        if (xMove == -1) {
            moveDirection = Left;
        } else if (xMove == 1) {
            moveDirection = Right;
        } else if (yMove == -1)
            moveDirection = Up;
        else if (yMove == 1)
            moveDirection = Down;

        if (moveDirection != null) {
            if (controllingBody.movement.canMove(world, controllingBody, moveDirection)) {
                game.beforeStep();
                controllingBody.movement.moveInDirection(world, controllingBody, moveDirection);
                controllingBody.hasMoved = true;
                game.afterStep();
            }
        } else if (keyboard.pressed[actionsKey]) {
            showActions();
        } else if (keyboard.pressed[statusEffectsMenuKey]) {
            showStatusEffects();
        } else if (keyboard.pressed[waitKey]) {
            game.beforeStep();
            game.afterStep();
        }
    }

    public function afterStep() {
        if (ownBody.stats.hp <= 0) {
            controllingBody = ownBody;
            world.addElement(new worldElements.PlayerBody(world, new Point(ownBody.position.x, ownBody.position.y)));
            game.info.addInfo("You are dead! Press Space or Enter to restart.");
        }
        else if (controllingBody.stats.hp <= 0) {
            stopTakeover();
            game.info.addInfo("You found yourself back in your own body.");
        }
    }

    function showStatusEffects() {
        var statusEffectMenuItems = [for (statusEffect in controllingBody.statusEffects) new ui.MenuItem(statusEffect.name, statusEffect.getText(), function() {})];
        var menu:ui.Menu;
        statusEffectMenuItems.push(new ui.MenuItem("Close Menu", "", function() menu.close()));
        menu = new ui.Menu(game.drawer, keyboard, world, game, this, "Status Effects", statusEffectMenuItems, statusEffectsMenuKey);
        game.focus(menu);
    }

    function showActions() {
        var actionMenuItems = [];
        var menu:ui.Menu;
        function showFail(text:String) {
            menu.info.clear();
            game.focus(menu);
            menu.info.addInfo(text);
            menu.info.processInfo(game.drawer);
        }

        for (action in controllingBody.actions) {
            if (action != controllingBody.basicAttack)
                actionMenuItems.push(new ui.MenuItem(action.abilityName + " (" + action.actionPoints + " AP)", action.abilityDescription, function() {
                    if (controllingBody.stats.ap >= action.actionPoints) {
                        if (Std.is(action, DirectionAction)) {
                            var directionAction:DirectionAction = cast action;
                            var dirMenu = new ui.ChooseDirection(keyboard, world, game, 'Choose a direction to use ${action.abilityName}.', 
                                function(dir) {
                                    directionAction.setParameter(dir);
                                    if (directionAction.canUse()) {
                                        controllingBody.stats.ap -= action.actionPoints;
                                        game.focus(this, false);
                                        game.beforeStep();
                                        directionAction.use();
                                        controllingBody.hasMoved = true;
                                        game.afterStep();
                                    } else {
                                        showFail('You can\'t use ${action.abilityName} in that direction!');
                                    }
                                }, menu);
                            game.focus(dirMenu);
                        } else {
                            //Assume no params!
                            if (action.canUse()) {
                                controllingBody.stats.ap -= action.actionPoints;
                                game.focus(this, false);
                                game.beforeStep();
                                action.use();
                                controllingBody.hasMoved = true;
                                game.afterStep();
                            } else {
                                showFail('You can\'t use ${action.abilityName} at the moment!');
                            }
                        }
                    }
                    else showFail('You don\'t have enough AP to use ${action.abilityName}!');
                }));
        }
        actionMenuItems.push(new ui.MenuItem("Close Menu", "", function() menu.close()));
        menu = new ui.Menu(game.drawer, keyboard, world, game, this, "Abilities", actionMenuItems, actionsKey);
        game.focus(menu);
    }
}