package ui;

class FinishGame extends Focusable {
    var drawer:Drawer;

    public function new(drawer:Drawer, keyboard:Keyboard, world:World, game:Game) {
        this.drawer = drawer;
        super(keyboard, world, game);

        game.focus(this);
        
        draw();
    }

    public function close() {
        //game.focus(innerFocusable);
    }

    public override function update() {
        if (keyboard.anyBack()) {
            game.restartGame();
        }
    }

    public override function draw() {
        drawer.clear();
        var drawY = 2;
        var title = "Game Complete!";
        drawer.setMultiBackground(0, drawY, title.length, Drawer.colorToInt(DarkGray));
        drawer.drawText(0, drawY, title);
        drawY += 1;
        var text = "";
        text += "You climbed the long ladder all the way to the surface!";
        var totalAmountOfArtifacts = 0;
        for (item in game.player.controllingBody.inventory) {
            if (Std.is(item, items.artifacts.Artifact)) {
                totalAmountOfArtifacts += 1;
            }
        }
        var totalArtifactValue = game.player.controllingBody.inventory.sum(function (it) return it.value);
        text += ' You took ${totalAmountOfArtifacts} cursed artifact${totalAmountOfArtifacts == 1 ? "" : "s"} for a total profit of ${totalArtifactValue} gold.';
        if (totalArtifactValue == 0)
            text += " You're just as poor as before. Why did you even enter the dungeon?";
        else if (totalArtifactValue <= 300)
            text += " That's not bad, but you feel you could've made more.";
        else if (totalArtifactValue <= 600)
            text += " That's a pretty nice sum of money.";
        else if (totalArtifactValue <= 1200)
            text += " You feel pretty rich now!";
        else if (totalArtifactValue <= 1600)
            text += " You feel really rich now!";
        else
            text += " That'll be plenty for the rest of your life!";
        text += "\n\nThis game was made by Florian van Strien in 48 hours for the Ludum Dare Compo 40. Thank you very much for playing!";
        drawer.drawText(0, drawY, text);
        drawer.drawText(0, 22, "Press Escape or Backspace if you'd like to play again.");
    }
}