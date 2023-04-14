String[] vertSrc = { """
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;
attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
//varying vec4 vertColor;
varying vec3 vertNormal;
varying vec4 vertPosition;
varying vec4 vertColor;
void main() {
  gl_Position = transform * position;    
  //vec3 ecPosition = vec3(modelview * position);  
  //vec3 ecNormal = normalize(normalMatrix * normal);
  //vec3 direction = normalize(lightPosition.xyz - ecPosition);    
  //float intensity = max(0.0, dot(direction, ecNormal));
  //vertColor = vec4(intensity, intensity, intensity, 1) * color;     
  vertNormal   = normal;
  vertPosition = position;
  vertColor    = color;
}
""" };

String[] fragSrc = { """
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
varying vec4 vertColor;
void main() {
  gl_FragColor = vertColor;
}
""" };


PImage texture2;
PShader shade;

PShape armr;
PShape body;
PShape head;

float ry;
PShape hand1; 
PShape hand2;


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
int LAB_SIZE = 21;
char labyrinthe [][][];
char sides [][][];
int actuel = 0;

PShape laby;
PShape laby0[] = new PShape[NIVEAU];
PShape ceil;
PShape ceil1;
PShape ciel[] = new PShape[NIVEAU];
//PShape cone;

// Texture de la pyramide
PImage texture0;

// Ciel Bleu
PImage cielBleu;

  


// ____________________________________

void setup() { 
  frameRate(20);
  randomSeed(2);
   texture0 = loadImage("bandages.png");
 shade = new PShader(g.parent, vertSrc, fragSrc );
  //for(int i = 0; i < vertSrc.length;i++) {
  //shade = loadShader(vertSrc[i], fragSrc[i]);
  //}
  hand1 = loadShape("hand1.obj");
  hand2 = loadShape("hand2.obj");
    
  armr = createShape();
  body = createShape();
  head = createShape();
  
  armr.beginShape(QUAD_STRIP);
  body.beginShape(QUAD_STRIP);
  
  armr.noStroke();
  body.noStroke();
  
  for (int i=-200; i<=250; i++){
    float a = i/50.0*2*PI;
    for (int j=-50; j<=50; j++){
      float R2 = 80+20*cos(i*PI/200);
      
      //Armr
      /*float xnoise = 0.0;
      float ynoise = 0.0;
      float znoise = 0.0;*/
      
      /*xnoise =+ 1.0;
      ynoise =+ 1.0;
      znoise =+ 1.0;*/
      float n = noise(i, j) * 256;
      // il faut avoir the perfect balance of color to get it yellow
      // ca affiche du vert jauné :/
      armr.fill(n*7,n*5,n+40);
      armr.vertex(R2*cos(a), R2*sin(a),i);
      armr.vertex(R2*cos(a), R2*sin(a),i+60);

      //Body
      textureMode(NORMAL);
      texture(texture2);
      
      body.fill(n*7,n*5,n+40);
      body.vertex(R2*cos(a), R2*sin(a),i, 10, 30);
      body.vertex(R2*cos(a), R2*sin(a),i+80, 20, 30);
      body.tint(n*7,n*5,n+40);
      
    }
  }
  armr.endShape();
  body.endShape();
  body.setTexture(texture2);
  head.setTexture(texture2);
  // on dessine la tête 
  head.beginShape(QUAD_STRIP);
  head.noStroke();
  for (int i=-100; i<=200; i++){
    float a = i/50.0*2*PI;
    for (int j=-50; j<=50; j++){
      float RBig = 160+40*cos(i*PI/200);
      float R2 = RBig;
      
      // Head
      float n = noise(i, j) * 256;
      fill(n*7,n*5,n+40);
      head.vertex(R2*cos(a), R2*sin(a),i, 100, 10);
      head.vertex(R2*cos(a), R2*sin(a),i+60, 100, 20);
      head.tint(n*7,n*5,n+40);
      shader(shade);
     }
  }
  head.endShape();
 
  //pixelDensity(2);
  
  texture0 = loadImage("stones.jpg");
  size(1000, 1000, P3D);
  // ______________________
  cielBleu = loadImage("cielbleu.jpg");
  cielBleu.resize(1000, 1000);
  
  
  // ______________________
  
  labyrinthe = new char[NIVEAU][LAB_SIZE][LAB_SIZE];
  sides = new char[LAB_SIZE][LAB_SIZE][4];
  
  for(int n = 0; n < NIVEAU; n++) {
  int todig = 0;
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      sides[j][i][0] = 0;
      sides[j][i][1] = 0;
      sides[j][i][2] = 0;
      sides[j][i][3] = 0;
      if (j%2==1 && i%2==1) {
        labyrinthe[n][j][i] = '.';
        todig ++;
      } else
        labyrinthe[n][j][i] = '#';
    }
  }
  int gx = 1;
  int gy = 1;
  while (todig>0) {
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
            sides[j-1][i][0] = 1;// c'est un bout de couloir vers le haut 
          if (labyrinthe[niv][j-1][i]==' ' && labyrinthe[niv][j+1][i]=='#' &&
            labyrinthe[niv][j][i-1]=='#' && labyrinthe[niv][j][i+1]=='#')
            sides[j+1][i][3] = 1;// c'est un bout de couloir vers le bas 
          if (labyrinthe[niv][j-1][i]=='#' && labyrinthe[niv][j+1][i]=='#' &&
            labyrinthe[niv][j][i-1]==' ' && labyrinthe[niv][j][i+1]=='#')
            sides[j][i+1][1] = 1;// c'est un bout de couloir vers la droite
          if (labyrinthe[niv][j-1][i]=='#' && labyrinthe[niv][j+1][i]=='#' &&
            labyrinthe[niv][j][i-1]=='#' && labyrinthe[niv][j][i+1]==' ')
            sides[j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
        }
      }
    }
    LAB_SIZE = LAB_SIZE - 3 ;
    LAB_SIZE = 21;

  // un affichage texte pour vous aider a visualiser le labyrinthe en 2D
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      print(labyrinthe[niv][j][i]);
    }
    println("");
  }
  }
  
  // _______________________________________
  
   float wallW = width/LAB_SIZE;
   float wallH = height/LAB_SIZE;
   
  for(int n = 0; n < NIVEAU; n++){
     translate(width/2, height/2);
     pushMatrix();
     ciel[n] = createShape();
     ciel[n].beginShape(QUADS);
     laby0[n] = createShape();
     laby0[n].beginShape(QUADS);
     laby0[n].texture(texture0);
     laby0[n].noStroke();
     
     // ----------
     
     //for(int n = 0; n < NIVEAU; n++) {
       
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      if (labyrinthe[n][j][i]=='#') {
        laby0[n].fill(i*25, j*25, 255-i*10+j*10);
        if (j==0 || labyrinthe[n][j-1][i]==' ') {
          laby0[n].normal(0, -1, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              // on crée les vertices
              laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH-wallH/2, (l+0)*50/MUR+n*100, k/(float)MUR*texture0.width, (0.5+l/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH-wallH/2, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+l/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH-wallH/2, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH-wallH/2, (l+1)*50/MUR+n*100, k/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
            }
        }
        
        // 1
        if (j==LAB_SIZE-1 || labyrinthe[n][j+1][i]==' ') {
          laby0[n].normal(0, 1, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH+wallH/2, (l+1)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH+wallH/2, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/MUR, j*wallH+wallH/2, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/MUR, j*wallH+wallH/2, (l+0)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
            }
        }
        // 2
        if (i==0 || labyrinthe[n][j][i-1]==' ') {
          laby0[n].normal(-1, 0, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+1)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+0)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
            }
        }
        // 3
        if (i==LAB_SIZE-1 || labyrinthe[n][j][i+1]==' ') {
          laby0[n].normal(1, 0, 0);
          for (int k=0; k<MUR; k++)
            for (int l=-MUR; l<MUR; l++) {
              laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+0)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+0)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+0)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/MUR, (l+1)*50/MUR+n*100, (k+1)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
              laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/MUR, (l+1)*50/MUR+n*100, (k+0)/(float)MUR*texture0.width, (0.5+(l+1)/2.0/MUR)*texture0.height);
            }
        }
        //ciel[n].fill(32, 255, 0);
        ciel[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50+n*100);
        ciel[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50+n*100);
        ciel[n].vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50+n*100);
        ciel[n].vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50+n*100);  
      } else {
        laby0[n].fill(i*25, j*25, 255-i*10+j*10); // ground
        laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50+n*100, 0, 0);
        laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50+n*100, 0, 1);
        laby0[n].vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50+n*100, 1, 1);
        laby0[n].vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50+n*100, 1, 0);
        
        ciel[n].fill(32); // top of walls
        ciel[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50+n*100);
        ciel[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50+n*100);
        ciel[n].vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50+n*100);
        ciel[n].vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50+n*100);
      }
    }
  }
  //}
  
  laby0[n].endShape();
  ciel[n].endShape();
  //ceil.endShape();
  //ceil1.endShape();
  LAB_SIZE = LAB_SIZE - 4;
}
  
  // ____- INIT LAB -____
  //InitLab();
  // ____- INIT LAB FIN -____
  //Labyramide(5);
  
 
}

void cone(int size) {
  //beginShape(TRIANGLE);
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0);
  vertex(-size, -size, -size);
  vertex(size,  -size, -size);
  vertex(size,   size, -size);
  vertex(-size,  size, -size);
  vertex(-size, -size,- size);
  endShape();
  
  terrainSable();
}
// ______________________________________________________________________


void draw() {
  background(192);
  
  //MOMIE
 // perspective();
  lights();
  //spotLight(51, 102, 126, 200, 200, 1600, 
         // 0, 0, -1, PI/16, 30); 
  //pointLight(51, 102, 126, 140, 160, 144);
  //pointLight(50, 0, 50, 7, 50, 15);
  translate(width/2, (height/2) -50);
  rotateX(2*PI);
  background(255,192,255);
  
  //CORPS
  pushMatrix();
  //shader(shade);
  scale(1,1.5,1);
  shape(body,0,0);
  popMatrix();  
  
  
  // BRAS DROIT
  pushMatrix();
  translate(-100,90,100);
  rotateX(PI/1.50);
  rotateY(PI);
  scale(0.2,0.5,0.5);
  shape(armr,0,0);
  popMatrix();
  
  // BRAS GAUCHE
  pushMatrix();
  translate(140,100,100);
  rotateX(PI/1.50);
  rotateY(PI);
  scale(0.2,0.5,0.5);
  shape(armr,200,0);
  popMatrix();
  
  // main objet left
  pushMatrix();
  translate(-115,225,190);
  scale(5);
  rotateX(2.5*PI/1.5);
  shape(hand2);
  translate(45,0,0);
  shape(hand1);
  popMatrix();
  
  //TETE
  scale(0.5);
  translate(0,0,600);
  shape(head,0,0);
 
  //OEIL DROIT
  pushMatrix();
  noStroke();
  fill(255);
  translate(-50,180,100);
  sphere(30);
  
  //PUPILLE
  fill(0);
  translate(0,20,0);
  sphere(15);
  popMatrix();
  
  //OEIL GAUCHE
  pushMatrix();
  translate(70,180,100);
  fill(255);
  sphere(30);
  
  // PUPILLE
  fill(0);
  translate(0,20,0);
  sphere(15);
  popMatrix(); 
  //FIN MOMIE
  
  
  
  
  //terrainSable();
  //image(cielBleu, 0,0);
  if(anim>0) anim--;
  LAB_SIZE=21-3*actuel;
  float labW = width/LAB_SIZE;
  float labH = height/LAB_SIZE;
  
  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();
 
 // map du labytinthe
  stroke(0);
  //for(int n = 0; n < NIVEAU; n++){
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        if (labyrinthe[actuel][j][i]=='#') {
          fill(i*25, j*25, 255-i*10+j*10);
          pushMatrix();
          translate(150+i*labW/8, 150+j*labH/8, actuel*100);
          //translate(50+i*labW/8, 50+j*labH/8, 50);
          //translate(50+i*labW/8, 50+j*labH/8, actuel);
          box(labW/10, labH/10, 10);
          popMatrix();
        }
      }
    }
  //}
  
  // sphere dans la map
  pushMatrix();
  fill(0, 255, 0);
  //noStroke();
  stroke(255);
  translate(150+posX*labW/8, 150+posY*labH/8, actuel*100);
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
    //translate(-1500, -500, -180);
    background(cielBleu);
    //terrainSable();
    rotateX(PI/3.5);
    lights();
    
    pointLight(255, 255, 255, posX*labW, posY*labH, 15);
  }
  
  
// --------------------------------------------
 
  stroke(0);
  noStroke();
  for(int n = 0; n < NIVEAU; n++) {
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        //translate(50, 50, n);
        pushMatrix();
        //translate(i*labW, j*labH, 0);
        //translate(i, j, 0);
        
          if (labyrinthe[n][j][i]=='#') {
            beginShape(QUADS);
            
            if (sides[j][i][3]==1) {
              pushMatrix();
              translate(0, -labH/2, 40);
              if(i == posX || j == posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);
                //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              }
              popMatrix();
            }
    
            if (sides[j][i][0]==1) {
              pushMatrix();
              translate(0, labH/2, 40);
              if (i==posX || j==posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);              
               // spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              }
              popMatrix();
            }
             
             if (sides[j][i][1]==1) {
              pushMatrix();
              translate(-labW/2, 0, 40);
              if (i==posX || j==posY) {
                fill(i*25, j*25, 255-i*10+j*10);
                sphere(5);              
                //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
             }
              popMatrix();
            }
             
            if (sides[j][i][2]==1) {
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
  for(int t=0; t < NIVEAU; t++){
      //translate(labW, labH, 0);
  //shape(laby0[t], 0, 0);
  //shape(ceil, 0, 0);
  
  if (inLab){
    //shape(ceil, 0, 0);
    shape(laby0[t], 0, 0);
    shape(ciel[t], 0, 0);
  }else{
    //shape(ceil1, 0, 0);
    
    //translate(100, 0, t);
    shape(laby0[t], 0, 0);
    shape(ciel[t], 0, 0);
    
    //cone(100);
    
  }
  }
  //translate(0, 0, -60);
  
  //translate(10, 10, 0);
  translate(-1600, -1000, -800);
  terrainSable();
  
  translate(472,472,96);
    box(900, 900,90);
    translate(0, 0, 90);
    fill(255);
    box(800, 800,90);
    translate(0, 0, 90);
    fill(0);
    box(700, 700,90);
    translate(0, 0, 90);
    fill(150);
    box(600, 600,90);
    translate(0, 0, 90);
    fill(255);
    box(500, 500,90);
    translate(0, 0, 90);
    fill(0);
    box(400, 400,90);
    translate(0, 0, 90);
    fill(255);
    box(300, 300,90);
    translate(0, 0, 90);
    fill(0);
    box(200, 200,90);
    
     beginShape(TRIANGLES);
  int t = 210;
  fill(255, 150); 
  vertex(-t, -t, -t);
  vertex( t, -t, -t);
  vertex( 0, 0, t);

  fill(150, 150);
  vertex( t, -t, -t);
  vertex( t, t, -t);
  vertex( 0, 0, t);

  fill(255, 150);
  vertex( t, t, -t);
  vertex(-t, t, -t);
  vertex( 0, 0, t);

  fill(150, 150);
  vertex(-t, t, -t);
  vertex(-t, -t, -t);
  vertex( 0, 0, t);

  endShape();
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
