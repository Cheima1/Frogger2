package infiniteFrogger;


import gameCommons.Game;
import gameCommons.IEnvironment;

import java.util.ArrayList;

public class EnvInf implements IEnvironment {

    // Attributs

    private ArrayList<LaneInf> lines;
    private Game game;

    // Constructeur
    
    public EnvInf(Game game){
        this.game = game;

    // Getters & Setters

    // Methodes
        
    public boolean is WinningPosition(Case c) {
		
	}
	
	public boolean isSafe(Case c) {
	}
	
	public void update() {
	}

}
