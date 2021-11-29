package infiniteFrogger;

import gameCommons.Game;
import gameCommons.IFrog;
import util.*


import java.awt.image.DirectColorModel;

public class FrogInf implements IFrog {

    // Attributs

    private Game game;
    private Case position;
    private Direction direction;

    public FrogInf(Game game) {
        this.game = game;
        this.position = new Case(game.width / 2, 1);
        this.direction = Direction.up;
    }

    // getter & Setter
    public Case getPosition(){
        return this.position;
    }

    @Override
    public Direction getDirection() {
        return direction;
    }

    // Methodes

    public void move(Direction key) {

        if (key == Direction.left){
            if(pos.absc > 0) {
                pos = new Case(pos.absc - 1, pos.ord);
            }
        } else if (key == Direction.right){
            if(pos.absc < game.width - 1){
                pos = new Case(pos.absc + 1, pos.ord);
            }
        } else if (key == Direction.down){
            if(pos.ord > 0){
                pos = new Case(pos.absc, pos.ord - 1);
            }
        } else if(key == Direction.up) {
            if (pos.ord < game.height - 1) {
                pos = new Case(pos.absc, pos.ord + 1);
            }
        }

        this.game.testWin();
        this.game.testLose();
        System.out.println(this.position.absc+""+ this.position.ord + " score :");
}
