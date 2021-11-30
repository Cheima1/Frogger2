package infiniteFrogger;

import gameCommons.Game;
import util.Case;
import graphicalElements.Element;
import java.awt.Color;

public class CarInf {

    // Attributs

    private Game game;
    private Case leftPosition;
    private boolean lefttoRight;
    private int length;

    // Constructeur
    
    public CarInf(Game game, Case , boolean leftToRight) {
       this.game = game;
       this.length = (int) ((java.lang.Math.random() * 3) + 1);
       this.leftToRight = leftToRight;
       this.leftPosition = ;

    // Getters & Setters

    // TODO : ajout de Methodes
        
    public boolean isAccident(Case posG) {
		// utiliser isSafe
		if (posG.ord == leftPosition.ord) {
			return true;
		} else {
			return false;
		}
	}   
        
    // Methode carAppears
	/**
	 * Savoir si on est dans la case de jeu
	 * @return : un boolean true si la voiture apparait dans la fenetre de jeu et pas au-dela
	 * false sinon
	 */     
        
    public boolean carAppears() {
		int res = leftPosition.absc + length;
		if (res > 0 || leftPosition.absc < game.width) {
			return true;
		} else {
			return false;
		}
	}
   
     private void addToGraphics() {
         for (int i = 0; i < length; i++) {
             Color color = colorRtL;
			 if (this.leftToRight){
				color = colorLtR;
			 }
			game.getGraphic()
                .add(new Element(leftPosition.absc + i, leftPosition.ord, color));
		}
	}
}
