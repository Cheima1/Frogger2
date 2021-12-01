package environment;

import util.*;
import gameCommons.Game;
import gameCommons.IEnvironment;

import java.util.ArrayList;

public class EnvInf implements IEnvironment {

    // Attributs

    private ArrayList<Lane> lines;
    private Game game;

    // Constructeur
    
    public EnvInf(Game game) {
        this.game = game;
    }
    // Getters & Setters

    // Methodes
        
    public boolean isWinningPosition(Case c){
        return false; // on ne peut pas vraiment gagner il n'y a pas de fin
	}
	
	public boolean isSafe(Case c) {

	}
	
	public void update() {
	}

}
