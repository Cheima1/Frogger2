
int WALLD = 1;
int LAB_SIZE = 21;
char labyrinthe [][];
char sides [][][];

PShape laby0;
PShape ceiling0;
PShape ceiling1;

//PImage  texture0;

void setup() { 
  //pixelDensity(2);
  frameRate(20);
  randomSeed(2);
  //texture0 = loadImage("stones.jpg");
  
  size(1000, 1000, P3D);
  
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
  while (todig>0 ) {
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
  //---------------------------------
  
  
  float wallW = width/LAB_SIZE;
  float wallH = height/LAB_SIZE;

  ceiling0 = createShape();
  ceiling1 = createShape();
  
  ceiling1.beginShape(QUADS);
  ceiling0.beginShape(QUADS);
  
  laby0 = createShape();
  laby0.beginShape(QUADS);
  //laby0.texture(texture0);
  laby0.noStroke();
  //laby0.stroke(255, 32);
  //laby0.strokeWeight(0.5);
  
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      if (labyrinthe[j][i]=='#') {
        
        laby0.fill(i*25, j*25, 255-i*10+j*10);
        if (j==0 || labyrinthe[j-1][i]==' ') {
          laby0.normal(0, -1, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              // on crée les vertices
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, k/(float)WALLD*width, (0.5+l/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+l/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, k/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
            }
        }
        
        // 1
        if (j==LAB_SIZE-1 || labyrinthe[j+1][i]==' ') {
          laby0.normal(0, 1, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, (k+0)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+0)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, (k+0)/(float)WALLD*width, (0.5+(l+0)/2.0/WALLD)*height);
            }
        }
        // 2
        if (i==0 || labyrinthe[j][i-1]==' ') {
          laby0.normal(-1, 0, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, (k+0)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+0)/2.0/WALLD)*height);
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, (k+0)/(float)WALLD*width, (0.5+(l+0)/2.0/WALLD)*height);
            }
        }
        // 3
        if (i==LAB_SIZE-1 || labyrinthe[j][i+1]==' ') {
          laby0.normal(1, 0, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, (k+0)/(float)WALLD*width, (0.5+(l+0)/2.0/WALLD)*height);
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+0)/2.0/WALLD)*height);
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, (k+1)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, (k+0)/(float)WALLD*width, (0.5+(l+1)/2.0/WALLD)*height);
            }
        }
        ceiling1.fill(32, 255, 0);
        ceiling1.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
        ceiling1.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
        ceiling1.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
        ceiling1.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);        
      } else {
        laby0.fill(192); // ground
        laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 0, 0);
        laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 0, 1);
        laby0.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 1, 1);
        laby0.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 1, 0);
        
        ceiling0.fill(32); // top of walls
        ceiling0.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
        ceiling0.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
        ceiling0.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
        ceiling0.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);
      }
    }
  }
  
  laby0.endShape();
  ceiling0.endShape();
  ceiling1.endShape();
}

void draw() {
  background(192);

  float wallW = width/LAB_SIZE;
  float wallH = height/LAB_SIZE;

  stroke(0);
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      if (labyrinthe[j][i]=='#') {
        fill(i*25, j*25, 255-i*10+j*10);
        pushMatrix();
        translate(50+i*wallW/8, 50+j*wallH/8, 50);
        box(wallW/10, wallH/10, 5);
        popMatrix();
      }
    }
  }
 
  stroke(0);
  
  noStroke();
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      pushMatrix();
      translate(i*wallW, j*wallH, 0);
      
      if (labyrinthe[j][i]=='#') {
        beginShape(QUADS);
        
        if (sides[j][i][3]==1) {
          pushMatrix();
          translate(0, -wallH/2, 40);
          popMatrix();
        }

        if (sides[j][i][0]==1) {
          pushMatrix();
          translate(0, wallH/2, 40);
          popMatrix();
        }
         
         if (sides[j][i][1]==1) {
          pushMatrix();
          translate(-wallW/2, 0, 40);
          popMatrix();
        }
         
        if (sides[j][i][2]==1) {
          pushMatrix();
          translate(0, wallH/2, 40);
          popMatrix();
        }
      } 
      popMatrix();
    }
  }
  
  shape(laby0, 0, 0);

}
