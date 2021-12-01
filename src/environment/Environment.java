package environment;

import java.util.ArrayList;

import util.Case;
import gameCommons.Game;
import gameCommons.IEnvironment;

public class Environment implements IEnvironment {

    private ArrayList<Lane> lanes;
    private Game game;

	public Environment (Game game) {
        this.game = game;
        lanes = new ArrayList<>();


        // On veut que la première et la dernière lignes soient vides.
        // On commence donc par créer une première ligne avec une densité de 0
        // (donc aucune voiture) à l'abscice 0 (position initiale de la grenouille)
        lanes.add(new Lane(game, 0, 0.0));

        // On crée ensuite les autres lignes de l'écran en utilisant la
        // densité par défaut (game.defaultDensity)
        for (int i = 1; i < game.height-1; i++) {
            lanes.add(new Lane(game, i, game.defaultDensity));
        }

        // Enfin on fini par crée la dernière ligne avec une densité de 0
        // (donc aucune voiture) à l'abscice game.height-1 (dernière ligne )
        lanes.add(new Lane(game, game.height-1, 0.0));
    }

    public boolean isSafe(Case c) {
        for (Lane lane : lanes) {
            if (!lane.isSafe(c)) {
                return false;
            }
        }

        return true;
    }

    public boolean isWinningPosition(Case c) { return c.absc == game.height-1;}

    public void update() {
        for (Lane l : lanes) {
            l.update();
        }
    }

}
