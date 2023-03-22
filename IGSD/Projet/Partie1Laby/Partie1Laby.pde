// Partie 0 : Labyrinthe simple

// Variables importantes

// Taille des murs
int mur = 1;

// Taille du labyrinthe
int LAB_SIZE = 21;
// Labyrinthe sous forme de #
char labyrinthe [][];
char sides [][][];

int iposX = 1;
int iposY = -1;

int posX = iposX;
int posY = iposY;

// Les PShapes
PShape laby;
PShape ceiling0;
PShape ceiling1;

void setup() { 
  // le nombre de d'image
  frameRate(20);
  randomSeed(2);
  // taille de la fenêtre
  size(1000, 1000, P3D);
  
  // le labyrinthe prendre des caractères #
  labyrinthe = new char[LAB_SIZE][LAB_SIZE];
  sides = new char[LAB_SIZE][LAB_SIZE][4];
  
  int todig = 0;
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      sides[j][i][0] = 0;
      sides[j][i][1] = 0;
      sides[j][i][2] = 0;
      sides[j][i][3] = 0;
      if (j%2==1 && i%2==1) {
        labyrinthe[j][i] = '.';
        todig ++;
      } else
        labyrinthe[j][i] = '#';
    }
  }
  int gx = 1;
  int gy = 1;
  while (todig > 0 ) {
    int oldgx = gx;
    int oldgy = gy;
    int alea = floor(random(0, 4)); // selon un tirage aleatoire
    if      (alea==0 && gx>1)          gx -= 2; // le fantome va a gauche
    else if (alea==1 && gy>1)          gy -= 2; // le fantome va en haut
    else if (alea==2 && gx<LAB_SIZE-2) gx += 2; // .. va a droite
    else if (alea==3 && gy<LAB_SIZE-2) gy += 2; // .. va en bas

    if (labyrinthe[gy][gx] == '.') {
      todig--;
      labyrinthe[gy][gx] = ' ';
      labyrinthe[(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
    }
  }

  labyrinthe[0][1]                   = ' '; // entree
  labyrinthe[LAB_SIZE-2][LAB_SIZE-1] = ' '; // sortie

  // Création du labyrinthe en char
  for (int j=1; j<LAB_SIZE-1; j++) {
    for (int i=1; i<LAB_SIZE-1; i++) {
      if (labyrinthe[j][i]==' ') {
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]==' ' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
          sides[j-1][i][0] = 1;// c'est un bout de couloir vers le haut 
        if (labyrinthe[j-1][i]==' ' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
          sides[j+1][i][3] = 1;// c'est un bout de couloir vers le bas 
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]==' ' && labyrinthe[j][i+1]=='#')
          sides[j][i+1][1] = 1;// c'est un bout de couloir vers la droite
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]==' ')
          sides[j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
      }
    }
  }

  // un affichage texte pour vous aider a visualiser le labyrinthe en 2D
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      print(labyrinthe[j][i]);
    }
    println("");
  }
  
  // ------------------------------
  
  // Variable pour les murs
  float murW = width/LAB_SIZE;
  float murH = height/LAB_SIZE;
  
  ceiling0 = createShape();
  ceiling1 = createShape();
  
  ceiling1.beginShape(QUADS);
  ceiling0.beginShape(QUADS);
  
  // Laby avec PShape
  laby = createShape();
  laby.beginShape(QUADS);
  laby.noStroke();
  
    // for pour relier les # au Pshape
    for(int j = 0; j < LAB_SIZE; j++){
      for(int i = 0; i < LAB_SIZE; i++){
        if(labyrinthe[j][i] == '#') {
          
          laby.fill(i*25, j*25, 255-i*10+j*10);
          if (j==0 || labyrinthe[j-1][i]==' ') {
            laby.normal(0, -1, 0);
            for (int k = 0; k < mur; k++)
              for(int l = -mur; l < mur; l++) {
                // on crée les vertices
                laby.vertex(i*murW-murW/2+(k+0)*murW/mur, j*murH-murH/2, (l+0)*50/mur, k/(float)mur*width,(0.5+l/2.0/mur)*height);
                laby.vertex(i*murW-murW/2+(k+1)*murW/mur, j*murH-murH/2, (l+0)*50/mur, (k+1)/(float)mur*width,(0.5+l/2.0/mur)*height);
                laby.vertex(i*murW-murW/2+(k+1)*murW/mur, j*murH-murH/2, (l+1)*50/mur, (k+1)/(float)mur*width,(0.5+(l+1)/2.0/mur)*height);
                laby.vertex(i*murW-murW/2+(k+0)*murW/mur, j*murH-murH/2, (l+1)*50/mur, k/(float)mur*width,(0.5+(l+1)/2.0/mur)*height);
              }
          }
            // 1
            if (j==LAB_SIZE-1 || labyrinthe[j+1][i]==' ') {
              laby.normal(0, 1, 0);
              for (int k = 0; k < mur; k++)
                for (int l = -mur; l < mur; l++) {
                  laby.vertex(i*murW-murW/2+(k+0)*murW/mur, j*murH+murH/2, (l+1)*50/mur,(k+0)/(float)mur*width, (0.5+(l+1)/2.0/mur)*height);
                  laby.vertex(i*murW-murW/2+(k+1)*murW/mur, j*murH+murH/2, (l+1)*50/mur,(k+1)/(float)mur*width, (0.5+(l+1)/2.0/mur)*height);
                  laby.vertex(i*murW-murW/2+(k+1)*murW/mur, j*murH+murH/2, (l+0)*50/mur,(k+1)/(float)mur*width, (0.5+(l+0)/2.0/mur)*height);
                  laby.vertex(i*murW-murW/2+(k+0)*murW/mur, j*murH+murH/2, (l+0)*50/mur,(k+0)/(float)mur*width, (0.5+(l+0)/2.0/mur)*height);
                }
            }
        // 2
        if (i==0 || labyrinthe[j][i-1]==' ') {
          laby.normal(-1, 0, 0);
          for (int k=0; k<mur; k++)
            for (int l=-mur; l<mur; l++) {
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+0)*murW/mur, (l+1)*50/mur, (k+0)/(float)mur*width,(0.5+(l+1)/2.0/mur)*height);
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+1)*murW/mur, (l+1)*50/mur, (k+1)/(float)mur*width,(0.5+(l+1)/2.0/mur)*height);
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+1)*murW/mur, (l+0)*50/mur, (k+1)/(float)mur*width,(0.5+(l+0)/2.0/mur)*height);
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+0)*murW/mur, (l+0)*50/mur, (k+0)/(float)mur*width,(0.5+(l+0)/2.0/mur)*height);
            }
        }
        // 3
        if (i==LAB_SIZE-1 || labyrinthe[j][i+1]==' ') {
          laby.normal(1, 0, 0);
          for (int k=0; k<mur; k++)
            for (int l=-mur; l<mur; l++) {
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+0)*murW/mur, (l+0)*50/mur, (k+0)/(float)mur*width, (0.5+(l+0)/2.0/mur)*height);
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+1)*murW/mur, (l+0)*50/mur, (k+1)/(float)mur*width, (0.5+(l+0)/2.0/mur)*height);
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+1)*murW/mur, (l+1)*50/mur, (k+1)/(float)mur*width, (0.5+(l+1)/2.0/mur)*height);
              laby.vertex(i*murW-murW/2, j*murH-murH/2+(k+0)*murW/mur, (l+1)*50/mur, (k+0)/(float)mur*width, (0.5+(l+1)/2.0/mur)*height);
            }  
        }
        ceiling1.fill(32, 255, 0);
        ceiling1.vertex(i*murW-murW/2, j*murH-murH/2, 50);
        ceiling1.vertex(i*murW+murW/2, j*murH-murH/2, 50);
        ceiling1.vertex(i*murW+murW/2, j*murH+murH/2, 50);
        ceiling1.vertex(i*murW-murW/2, j*murH+murH/2, 50);  
        
        } else {
        //laby.fill(192); // sol
        laby.vertex(i*murW-murW/2, j*murH-murH/2, -50, 0, 0);
        laby.vertex(i*murW+murW/2, j*murH-murH/2, -50, 0, 1);
        laby.vertex(i*murW+murW/2, j*murH+murH/2, -50, 1, 1);
        laby.vertex(i*murW-murW/2, j*murH+murH/2, -50, 1, 0);  
        
        ceiling0.fill(32); // top of walls
        ceiling0.vertex(i*murW-murW/2, j*murH-murH/2, 50);
        ceiling0.vertex(i*murW+murW/2, j*murH-murH/2, 50);
        ceiling0.vertex(i*murW+murW/2, j*murH+murH/2, 50);
        ceiling0.vertex(i*murW-murW/2, j*murH+murH/2, 50);
        }
      }
    }
  
    laby.endShape();
    ceiling0.endShape();
    ceiling1.endShape();
}

// _____________________________________________

// La map du Labyrinthe avec PShape

void draw(){
  background(192);
  
  int labW = width/LAB_SIZE;
  int labH = height/LAB_SIZE;
  
  stroke(0);
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++){
      if (labyrinthe[j][i] =='#') {
        fill(i*25, j*25, 255-i*10+j*10);
        pushMatrix();
        translate(50+i*labW/8, 50+j*labH/8, 50);
        box(labW/10, labH/10, 5);
        popMatrix();
      }
    }
  }
  
  stroke(0);
  
  noStroke();
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      pushMatrix();
      translate(i*labW, j*labH, 0);
      
      if (labyrinthe[j][i]=='#') {
        beginShape(QUADS);
        
        if (sides[j][i][3]==1) {
          pushMatrix();
          translate(0, -labH/2, 40);
          popMatrix();
        }
        
      if (sides[j][i][0]==1) {
          pushMatrix();
          translate(0, labH/2, 40);
          popMatrix();
      }
      
      if (sides[j][i][1]==1) {
          pushMatrix();
          translate(-labW/2, 0, 40);
          popMatrix();
      }
      
      if (sides[j][i][2]==1) {
          pushMatrix();
          translate(0, labH/2, 40);
          popMatrix();
      }
    }
    popMatrix();
  }
}

shape(laby, 0, 0);
}



// ___________________________________________________

// Brouillon et old lab...etc.

// ================================

// Labyrinthe avec des Quads
/*void draw(){
  background(230);
  int lab = 1000/LAB_SIZE;
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++){
      pushMatrix();
      if (labyrinthe[j][i] =='#') {
        //translate(i*(lab), j*(lab));
        fill(154,198, 247);
        beginShape(QUADS);
        vertex(lab*i, lab*j, 0);
        vertex(lab*i, lab*j+lab, 0);
        vertex(lab*i, lab*j+lab, lab);
        vertex(lab*i, lab*j, lab);
        
        vertex(lab*i, lab*j, 0);
        vertex(lab*i+lab, lab*j, 0);
        vertex(lab*i+lab, lab*j, lab);
        vertex(lab*i, lab*j, lab);
        
        vertex(lab*i+lab, lab*j, 0);
        vertex(lab*i+lab, lab*j+lab, 0);
        vertex(lab*i+lab, lab*j+lab, lab);
        vertex(lab*i+lab, lab*j, lab);
        
        vertex(lab*i, lab*j+lab, 0);
        vertex(lab*i+lab, lab*j+lab, 0);
        vertex(lab*i+lab, lab*j+lab, lab);
        vertex(lab*i, lab*j+lab, lab);
        endShape();
        
      } else {
        pushMatrix();
        fill(100);
        beginShape(QUADS);
        vertex(lab*i, lab*j, 0);
        vertex(lab*i, lab*j+lab, 0);
        vertex(lab*i+lab, lab*j+lab, 0);
        vertex(lab*i+lab, lab*j, 0);
        endShape();
        popMatrix();
      }
      popMatrix();
    }
  }
}*/

// ================================

// Labyrinthe avec des box
/*void draw(){
  background(230);
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++){
      pushMatrix();
      if (labyrinthe[j][i] =='#') {
        translate(i*(1000/LAB_SIZE), j*(1000/LAB_SIZE));
        box(1000/LAB_SIZE);
      }
      popMatrix();
    }
  }
}*/

// ================================

  
