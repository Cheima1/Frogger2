package infiniteFrogger;

import gameCommons.Game;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class LaneInf {

    // Attributs

    private Game game;
    private ArrayList<CarInf> cars;
    private boolean leftToRight;
    private double density;
    private int timer;
    private int speed;
    private int ordonnee;

    // Constructeur
    
    public Lane (Game game, int ordonnee, double density) {
        this.game = game;
        this.ordonnee = ordonnee;
        this.density = density;
        
    }
        

    // Getters & Setters

    // Methodes
}
