// Camera et deplacement
int iposX = 1;
int iposY = -1;
int iposZ = 0;

int posX = iposX;
int posY = iposY;

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
int LAB_SIZE = 21;
char labyrinthe [][];
char sides [][][];

PShape laby;
PShape ceil;
PShape ceil1;

PImage texture0;

//____________________ SABLE _____________________

/*int cols, rows;
int scl = 20;
int w = 4000;
int h = 4000;*/
PImage texture;
PShape sand; 
PShape sable;
//float[][] terrain;

PShape ground;

// ___________

/*void smoothTerrain(int iterations) {
  // Lissage du terrain
  for (int i = 0; i < iterations; i++) {
    float[][] smoothedTerrain = new float[cols][rows];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        float total = 0;
        int count = 0;
        for (int ny = y-1; ny <= y+1; ny++) {
          for (int nx = x-1; nx <= x+1; nx++) {
            if (nx >= 0 && nx < cols && ny >= 0 && ny < rows) {
              total += terrain[nx][ny];
              count++;
            }
          }
        }
        smoothedTerrain[x][y] = total / count;
      }
    }
    terrain = smoothedTerrain;
  }
}*/

PShape dunes(){
  
  PShape all = createShape(GROUP);
  sable = createShape();
  sable.beginShape(QUAD_STRIP);
  sable.fill(150, 200, 100);
  sable.noStroke();
  //sable.strokeWeight(1);
  float tileSize = 109;
  //int rows = height / tileSize;
  //int cols = width / tileSize;
  /*int rows = int(height / tileSize);
  int cols = int(width / tileSize);*/
  
  int rows = 700;
  int cols = 700;

  float[][] heights = new float[cols + 1][rows + 1];
  
  // Generate random heights for each vertex
  for (int x = 0; x <= cols; x++) {
    for (int y = 0; y <= rows; y++) {
      heights[x][y] = random(-50, 50);
    }
  }
  
  // Use bilinear interpolation to smooth the heights
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x <= cols; x++) {
      float top = heights[x][y];
      float bottom = heights[x][y+1];
      if (x > 0) {
        top = lerp(top, heights[x-1][y], 0.5);
        bottom = lerp(bottom, heights[x-1][y+1], 0.5);
      }
      if (x < cols) {
        top = lerp(top, heights[x+1][y], 0.5);
        bottom = lerp(bottom, heights[x+1][y+1], 0.5);
      }
      sable.vertex(x * tileSize, y * tileSize, top);
      sable.vertex(x * tileSize, (y + 1) * tileSize, bottom);
    }
  }
  
  sable.endShape();
  
  /*cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float noiseVal = noise(x * 0.05, y * 0.05, 0.05);
      terrain[x][y] = map(noiseVal, 0, 1, -10, 10);
    }
   }
   
  sable = createShape();
  //directionalLight(255, 255, 255, 0, 0, -1);
  //ambientLight(127, 127, 127);
  noStroke();
  fill(194, 178, 128);
  //translate(width/2, height/2 + 400);
  
  //rotateX(PI/2.5);
  //translate(-w/2, -h/2);
  //smoothTerrain(2);
  sable.beginShape(QUAD_STRIP);
  for (int y = 0; y < rows-1; y++) {
    for (int x = 0; x < cols; x++) {
      sable.vertex(x*scl, y*scl, terrain[x][y]);
      sable.vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
       
      //translate(0,0,-1600);
    }
  }*/
  sable.endShape();
  //translate(0,0,-1000);
  all.addChild(sable);
  return all;
  
  
}





// ___________________ SETUP _____________________

void setup() { 
  frameRate(20);
  randomSeed(2);
  texture0 = loadImage("stones.jpg");
  texture = loadImage("sable.jpg");
  size(1000, 1000, P3D);
  // __________________
  
  sand = dunes();
  
  // __________________
  
  ground = createShape();
  ground.setTexture(texture);
  ground.texture(texture);
  textureWrap(REPEAT);
  ground.beginShape(QUADS);
  ground.normal(0, 1, 0);
  ground.vertex(-1000, 0, -1000, 0, 0);
  ground.vertex(1000, 0, -1000, 1000, 0);
  ground.vertex(1000, 0, 1000, 1000, 1000);
  ground.vertex(-1000, 0, 1000, 0, 1000);
  ground.endShape();
  

// _____________________________

/*float xOff = 0.0;
float zOff = 0.0;
float scale = 0.02;

ground = createShape();
ground.setTexture(texture);
ground.texture(texture);
textureWrap(REPEAT);
ground.beginShape(QUAD_STRIP);
ground.normal(0, 1, 0);

// Boucle pour créer les points de la bande de terrain
for (int z = -1000; z <= 1000; z += 20) {
  // Définir la hauteur de chaque point avec le bruit de Perlin
  float height = map(noise(xOff, zOff), 0, 1, -100, 100);

  // Ajouter un facteur de forme pour créer une forme de dune
  height += map(cos(z/100.0), -1, 1, 0, 50);

  // Ajouter les sommets pour la bande de terrain
  ground.vertex(-1000, height, z, 0, z * scale);
  ground.vertex(1000, height, z, 1, z * scale);


  // Incrémenter la variable de bruit
  zOff += 0.1;
}

ground.endShape();*/

// _____________________________

/*float xOff = 0.0;
float zOff = 0.0;
float scale = 0.02;

ground = createShape();
ground.setTexture(texture);
ground.texture(texture);
textureWrap(REPEAT);
ground.beginShape(QUAD_STRIP);
ground.normal(0, 1, 0);

// Boucle pour créer des quads sur le terrain
for (int x = -1000; x < 1000; x += 20) {
  for (int z = -1000; z < 1000; z += 20) {

    // Utilisation du bruit de Perlin pour générer une hauteur de terrain aléatoire
    float height = map(noise(xOff, zOff), 0, 1, -100, 100);

    // Ajout d'une déformation en forme de dune en fonction de la position en z
    height += map(cos(z/100.0), -1, 1, 0, 50);

    // Définition des sommets pour chaque quad
    ground.vertex(x, height, z, x * scale, z * scale);
    ground.vertex(x + 20, height, z, (x + 20) * scale, z * scale);
    ground.vertex(x + 20, height, z + 20, (x + 20) * scale, (z + 20) * scale);
    ground.vertex(x, height, z + 20, x * scale, (z + 20) * scale);

    // Incrément des variables de bruit
    zOff += 0.1;
  }
  xOff += 0.1;
  zOff = 0.0;
}

ground.endShape();*/

// _____________________________
  
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

  ceil = createShape();
  ceil1 = createShape();
  
  ceil1.beginShape(QUADS);
  ceil.beginShape(QUADS);
  
  laby = createShape();
  laby.beginShape(QUADS);
  laby.texture(texture0);
  laby.noStroke();
  //laby.stroke(255, 32);
  //laby.strokeWeight(0.5);
  
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      if (labyrinthe[j][i]=='#') {
        
        laby.fill(i*25, j*25, 255-i*10+j*10);
        if (j==0 || labyrinthe[j-1][i]==' ') {
          laby.normal(0, -1, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              // on crée les vertices
              laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH-wallH/2, (l+0)*50/MUR, k/(float)MUR*texture0.width, (0.5+l/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH-wallH/2, (l+0)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+l/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH-wallH/2, (l+1)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH-wallH/2, (l+1)*50/MUR, k/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
            }
        }
        
        // 1
        if (j==LAB_SIZE-1 || labyrinthe[j+1][i]==' ') {
          laby.normal(0, 1, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH+wallH/2, (l+1)*50/MUR, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH+wallH/2, (l+1)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH+wallH/2, (l+0)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH+wallH/2, (l+0)*50/MUR, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
            }
        }
        // 2
        if (i==0 || labyrinthe[j][i-1]==' ') {
          laby.normal(-1, 0, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              laby.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+1)*50/MUR, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+1)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+0)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+0)*50/MUR, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
            }
        }
        // 3
        if (i==LAB_SIZE-1 || labyrinthe[j][i+1]==' ') {
          laby.normal(1, 0, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              laby.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+0)*50/MUR, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+0)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+1)*50/MUR, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+1)*50/MUR, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
            }
        }
        ceil1.fill(32, 255, 0);
        ceil1.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
        ceil1.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
        ceil1.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
        ceil1.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);  
      } else {
        laby.fill(i*25, j*25, 255-i*10+j*10); // ground
        laby.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 0, 0);
        laby.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 0, 1);
        laby.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 1, 1);
        laby.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 1, 0);
        
        ceil.fill(32); // top of walls
        ceil.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
        ceil.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
        ceil.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
        ceil.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);
      }
    }
  }
  
  laby.endShape();
  ceil.endShape();
  ceil1.endShape();
  
  // _______________________________________________________
  
  
}

void draw() {
  background(192);
  
  if(anim>0) anim--;

  float labW = width/LAB_SIZE;
  float labH = height/LAB_SIZE;
  
  // _________________________ MAP _________________________
  
  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();

  stroke(0);
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      if (labyrinthe[j][i]=='#') {
        fill(i*25, j*25, 255-i*10+j*10);
        pushMatrix();
        translate(50+i*labW/8, 50+j*labH/8, 50);
        box(labW/10, labH/10, 5);
        popMatrix();
      }
    }
  }
  
  // sphere dans la map
  pushMatrix();
  fill(0, 255, 0);
  noStroke();
  translate(50+posX*labW/8, 50+posY*labH/8, 50);
  sphere(3);
  popMatrix();
  
  // ______________________ FIN MAP _________________________
  
  // camera
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
    lights();
    
  } else {
    //lightFalloff(0.0, 0.05, 0.0001);
    lights();
    pointLight(255, 255, 255, posX*labW, posY*labH, 15);
    //rotateX(PI/3.5);
    camera(width/2.0, height*3, height/2, width/2.0, height/2.0, 0, 0, 1, 0);
    //translate(0, -1000, -1200);
  }
  
  
// --------------------------------------------
  
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
          if(i == posX || j == posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          }
          popMatrix();
        }

        if (sides[j][i][0]==1) {
          pushMatrix();
          translate(0, labH/2, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);              
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          }
          popMatrix();
        }
         
         if (sides[j][i][1]==1) {
          pushMatrix();
          translate(-labW/2, 0, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);              
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
         }
          popMatrix();
        }
         
        if (sides[j][i][2]==1) {
          pushMatrix();
          translate(0, labH/2, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);              
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          }
          popMatrix();
        }
      } 
      popMatrix();
    }
  }
  
  pushMatrix();

  //translate(-2000, -900, -120);
  //translate(0, 0, -100);
  //translate(0, 0, -1000);
  //rotateX(PI / 3);
    //scale(100, 100);
   
    //scale(100, 100);
  popMatrix();
  shape(laby, 0, 0);
  if (inLab){
    shape(ceil, 0, 0);
    
  }else{
    pushMatrix();
  //translate(0,0,-1000);
  
    shape(ceil1, 0, 0);
    //translate(0,0,-1600);
     
    popMatrix();
  }
  //dunes();
  translate(0, 0, -100);
  //shape(sand, 0, 0);
  //scale(100);
  //scale(100, 100);
  
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(PI/2);
  shape(ground);
  popMatrix();
  //scale(1200);
  
  //popMatrix();
}


// ______________________ FIN DRAW __________________________


void keyPressed() {

  if (key=='l') inLab = !inLab;

  if (anim==0 && keyCode==38) {
    if (posX+dirX>=0 && posX+dirX<LAB_SIZE && posY+dirY>=0 && posY+dirY<LAB_SIZE &&
      labyrinthe[posY+dirY][posX+dirX]!='#') {
      posX+=dirX; 
      posY+=dirY;
      anim=20;
      animT = true;
      animR = false;
    }
      posX+=dirX; 
      posY+=dirY;
      anim=20;
      animT = true;
      animR = false;
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
