// Camera et deplacement
int iposX = 1;
int iposY = -1;
int iposZ = 0;


int posX = iposX;
int posY = iposY;
int posZ = iposZ;

int dirX = 0;
int dirY = 1;
int odirX = 0;
int odirY = 1;

// animation 
int anim = 0;
boolean animT=false;
boolean animR=false;

boolean inLab = true;


int MUR = 1;
int NIVEAU = 5;

// Impaire
int LAB_SIZE = 21;
int ni = LAB_SIZE;
int mazeWidth = 80;
int mazeHeight = 80;
char labyrinthe [][][];
char sides [][][][];

PShape laby;
PShape ceil;
PShape ceil1;

PImage texture0;

// ____________________________________



// ____________________________________

void setup() { 
  //pixelDensity(2);
  frameRate(20);
  randomSeed(2);
  texture0 = loadImage("stones.jpg");
  size(1000, 1000, P3D);
  
  ni = ni - NIVEAU;
  
  labyrinthe = new char[NIVEAU][LAB_SIZE][LAB_SIZE];
  sides = new char[LAB_SIZE][LAB_SIZE][LAB_SIZE][4];
  for(int n = 0; n < NIVEAU; n++) {
  int todig = 0;
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      sides[n][j][i][0] = 0;
      sides[n][j][i][1] = 0;
      sides[n][j][i][2] = 0;
      sides[n][j][i][3] = 0;
      if (j%2==1 && i%2==1) {
        labyrinthe[n][j][i] = '.';
        todig ++;
      } else
        labyrinthe[n][j][i] = '#';
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

    if (labyrinthe[n][gy][gx] == '.') {
      todig--;
      labyrinthe[n][gy][gx] = ' ';
      labyrinthe[n][(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
    }
  }
  }

  labyrinthe[0][0][1]                   = ' '; // entree
  labyrinthe[0][LAB_SIZE-2][LAB_SIZE-1] = ' '; // sortie
  

  for(int niv = 0; niv < NIVEAU; niv++) {
    for (int j=1; j<LAB_SIZE-1; j++) {
      for (int i=1; i<LAB_SIZE-1; i++) {
        if (labyrinthe[niv][j][i]==' ') {
          if (labyrinthe[niv][j-1][i]=='#' && labyrinthe[niv][j+1][i]==' ' &&
            labyrinthe[niv][j][i-1]=='#' && labyrinthe[niv][j][i+1]=='#')
            sides[niv][j-1][i][0] = 1;// c'est un bout de couloir vers le haut 
          if (labyrinthe[niv][j-1][i]==' ' && labyrinthe[niv][j+1][i]=='#' &&
            labyrinthe[niv][j][i-1]=='#' && labyrinthe[niv][j][i+1]=='#')
            sides[niv][j+1][i][3] = 1;// c'est un bout de couloir vers le bas 
          if (labyrinthe[niv][j-1][i]=='#' && labyrinthe[niv][j+1][i]=='#' &&
            labyrinthe[niv][j][i-1]==' ' && labyrinthe[niv][j][i+1]=='#')
            sides[niv][j][i+1][1] = 1;// c'est un bout de couloir vers la droite
          if (labyrinthe[niv][j-1][i]=='#' && labyrinthe[niv][j+1][i]=='#' &&
            labyrinthe[niv][j][i-1]=='#' && labyrinthe[niv][j][i+1]==' ')
            sides[niv][j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
        }
      }
    }
  

  // un affichage texte pour vous aider a visualiser le labyrinthe en 2D
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      print(labyrinthe[niv][j][i]);
    }
    println("");
  }
  }
  //LAB_SIZE -= 2;
  /*int size = LAB_SIZE/2;
  LAB_SIZE = size;*/
  //---------------------------------
  

  
  float wallW = width/LAB_SIZE;
  float wallH = height/LAB_SIZE;

  ceil = createShape();
  ceil1 = createShape();
  
  ceil1.beginShape(QUADS);
  ceil.beginShape(QUADS);
  
  laby = createShape();
  laby.beginShape(QUADS);
  laby.texture(texture0);
  laby.noStroke();
  laby.stroke(255, 32);
  laby.strokeWeight(0.5);
  

  laby.tint(255,255,0);
  for(int n = 0; n < NIVEAU; n++) {
    for (int j=0; j<LAB_SIZE-n*2; j++) {
      for (int i=0; i<LAB_SIZE-n*2; i++) {
        if (labyrinthe[n][j][i]=='#') {
        
          laby.fill(i*25, j*25, 255-i*10+j*10);
          if (j==0 || labyrinthe[n][j-1][i]==' ') {
            laby.normal(0, -1, 0);
            for (int k=0; k<MUR; k++)
              for (int l=-MUR; l<MUR; l++) {
                // on crée les vertices
                laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR+n*50, j*wallH-wallH/2+n*50, (l+0)*50/MUR+n*100, k/(float)MUR*texture0.width, (0.5+l/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR+n*50, j*wallH-wallH/2+n*50, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+l/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR+n*50, j*wallH-wallH/2+n*50, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR+n*50, j*wallH-wallH/2+n*50, (l+1)*50/MUR+n*100, k/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              }
          }
          
          // 1
          if (j==LAB_SIZE-1 || labyrinthe[n][j+1][i]==' ') {
            laby.normal(0, 1, 0);
            for (int k=0; k<MUR; k++)
              for (int l=-MUR; l<MUR; l++) {
                laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR+n*50, j*wallH+wallH/2+n*50, (l+1)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR+n*50, j*wallH+wallH/2+n*50, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR+n*50, j*wallH+wallH/2+n*50, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR+n*50, j*wallH+wallH/2+n*50, (l+0)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              }
          }
          // 2
          if (i==0 || labyrinthe[n][j][i-1]==' ') {
            laby.normal(-1, 0, 0);
            for (int k=0; k<MUR; k++)
              for (int l=-MUR; l<MUR; l++) {
                laby.vertex(i*wallW-wallW/2+n*50, j*wallH-wallH/2+(k+0)*wallW/MUR+n*50, (l+1)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+n*50, j*wallH-wallH/2+(k+1)*wallW/MUR+n*50, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+n*50, j*wallH-wallH/2+(k+1)*wallW/MUR+n*50, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW-wallW/2+n*50, j*wallH-wallH/2+(k+0)*wallW/MUR+n*50, (l+0)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              }
          }
          // 3
          if (i==LAB_SIZE-1 || labyrinthe[n][j][i+1]==' ') {
            laby.normal(1, 0, 0);
            for (int k=0; k<MUR; k++)
              for (int l=-MUR; l<MUR; l++) {
                laby.vertex(i*wallW+wallW/2+n*50, j*wallH-wallH/2+(k+0)*wallW/MUR+n*50, (l+0)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW+wallW/2+n*50, j*wallH-wallH/2+(k+1)*wallW/MUR+n*50, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW+wallW/2+n*50, j*wallH-wallH/2+(k+1)*wallW/MUR+n*50, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
                laby.vertex(i*wallW+wallW/2+n*50, j*wallH-wallH/2+(k+0)*wallW/MUR+n*50, (l+1)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              }
          }
          ceil1.fill(32, 255, 0);
          ceil1.vertex(i*wallW-wallW/2+n*50, j*wallH-wallH/2+n*50, 50+n*100);
          ceil1.vertex(i*wallW+wallW/2+n*50, j*wallH-wallH/2+n*50, 50+n*100);
          ceil1.vertex(i*wallW+wallW/2+n*50, j*wallH+wallH/2+n*50, 50+n*100);
          ceil1.vertex(i*wallW-wallW/2+n*50, j*wallH+wallH/2+n*50, 50+n*100);  
        } else {
          laby.fill(i*25, j*25, 255-i*10+j*10); // ground
          laby.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 0, 0);
          laby.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 0, 1);
          laby.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 1, 1);
          laby.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 1, 0);
          
          ceil.fill(32); // top of walls
          ceil.vertex(i*wallW-wallW/2+n*50, j*wallH-wallH/2+n*50, 50+n*100);
          ceil.vertex(i*wallW+wallW/2+n*50, j*wallH-wallH/2+n*50, 50+n*100);
          ceil.vertex(i*wallW+wallW/2+n*50, j*wallH+wallH/2+n*50, 50+n*100);
          ceil.vertex(i*wallW-wallW/2+n*50, j*wallH+wallH/2+n*50, 50+n*100);
        }
      }
    }
  }
  
  laby.endShape();
  ceil.endShape();
  ceil1.endShape();
}


// ______________________________________________________________________


void draw() {
  background(192);
  //LAB_SIZE = LAB_SIZE / 2;
  if(anim>0) anim--;


  float labW = width/LAB_SIZE;
  float labH = height/LAB_SIZE;
  
  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();
 
 // map du labytinthe
  stroke(0);
  
  for(int n = 0; n < NIVEAU; n++){
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        if (labyrinthe[n][j][i]=='#') {
          fill(i*25, j*25, 255-i*10+j*10);
          pushMatrix();
          translate(150+i*labW/8, 150+j*labH/8, n*100);
          //translate(50+i*labW/8, 50+j*labH/8, 50);
          box(labW/10, labH/10, 10);
          popMatrix();
        }
      }
    }
  }
  
  // sphere dans la map
  pushMatrix();
  fill(0, 255, 0);
  //noStroke();
  stroke(255);
  translate(150+posX*labW/8, 150+posY*labH/8, 50);
  sphere(3);
  popMatrix();
  
  // camera de l'aventurier
  if (inLab) {
    perspective(2*PI/3, float(width)/float(height), 1, 1000);
    if (animT)
      camera((posX-dirX*anim/20.0)*labW,      (posY-dirY*anim/20.0)*labH,      -15+2*sin(anim*PI/5.0), 
             (posX-dirX*anim/20.0+dirX)*labW, (posY-dirY*anim/20.0+dirY)*labH, -15+4*sin(anim*PI/5.0), 0, 0, -1);
    else if (animR)
      camera(posX*labW, posY*labH, -15, 
            (posX+(odirX*anim+dirX*(20-anim))/20.0)*labW, (posY+(odirY*anim+dirY*(20-anim))/20.0)*labH, -15-5*sin(anim*PI/20.0), 0, 0, -1);
    else {
      camera(posX*labW, posY*labH, -15, 
             (posX+dirX)*labW, (posY+dirY)*labH, -15, 0, 0, -1);
    }
    //camera((posX-dirX*anim/20.0)*wallW, (posY-dirY*anim/20.0)*wallH, -15+6*sin(anim*PI/20.0), 
    //  (posX+dirX-dirX*anim/20.0)*wallW, (posY+dirY-dirY*anim/20.0)*wallH, -15+10*sin(anim*PI/20.0), 0, 0, -1);

    lightFalloff(0.0, 0.01, 0.0001);
    pointLight(255, 255, 255, posX*labW, posY*labH, 15);
  } else {
    //lightFalloff(0.0, 0.05, 0.0001);
    //camera(70.0, 35.0, 420.0, 50.0, 50.0, 0.0, 0.0, 1.0, 0.0);
    //translate(-width/8, 100/2, 100);
    translate(0, 0, -1000);
    rotateX(50*PI/8);
    pointLight(255, 255, 255, posX*labW, posY*labH, 15);
  }
  
  
// --------------------------------------------
 
  stroke(0);
  noStroke();
  for(int n = 0; n < NIVEAU; n++) {
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        pushMatrix();
        translate(i*labW, j*labH, 0);
        
          if (labyrinthe[n][j][i]=='#') {
            beginShape(QUADS);
            
            if (sides[n][j][i][3]==1) {
              pushMatrix();
              translate(0, -labH/2, 40);
              if(i == posX || j == posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);
                //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              }
              popMatrix();
            }
    
            if (sides[n][j][i][0]==1) {
              pushMatrix();
              translate(0, labH/2, 40);
              if (i==posX || j==posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);              
               // spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              }
              popMatrix();
            }
             
             if (sides[n][j][i][1]==1) {
              pushMatrix();
              translate(-labW/2, 0, 40);
              if (i==posX || j==posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);              
                //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
             }
              popMatrix();
            }
             
            if (sides[n][j][i][2]==1) {
              pushMatrix();
              translate(0, labH/2, 40);
              if (i==posX || j==posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);              
                //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              }
              popMatrix();
            }
      } 
      popMatrix();
    }
  }
  }
  
  shape(laby, 0, 0);
  //shape(ceil, 0, 0);
  
  if (inLab)
    shape(ceil, 0, 0);
  else
    shape(ceil1, 0, 0);
}

void keyPressed() {

  if (key=='l') inLab = !inLab;

  if (anim==0 && keyCode==38) {
    if (posX+dirX>=0 && posX+dirX<LAB_SIZE && posY+dirY>=0 && posY+dirY<LAB_SIZE &&
      labyrinthe[posZ][posY+dirY][posX+dirX]!='#') {
      posX+=dirX; 
      posY+=dirY;
      anim=20;
      animT = true;
      animR = false;
    }
  }

  // Touche reculer
  /*if (anim==0 && keyCode==40 && labyrinthe[posY-dirY][posX-dirX]!='#') {
    posX-=dirX; 
    posY-=dirY;
  }*/
  
  if (anim==0 && keyCode==37) {
    odirX = dirX;
    odirY = dirY;
    anim = 20;
    int tmp = dirX; 
    dirX=dirY; 
    dirY=-tmp;
    animT = false;
    animR = true;
  }
  if (anim==0 && keyCode==39) {
    odirX = dirX;
    odirY = dirY;
    anim = 20;
    animT = false;
    animR = true;
    int tmp = dirX; 
    dirX=-dirY; 
    dirY=tmp;
  }
}
