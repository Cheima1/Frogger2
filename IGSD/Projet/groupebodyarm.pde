PShape armr;
PShape body;

void setup(){
  size(1200, 1200, P3D);
  frameRate(2);
  armr = createShape();
  body = createShape();
  
  armr.beginShape(QUAD_STRIP);
  body.beginShape(QUAD_STRIP);

  armr.strokeWeight(3);
  for (int i=-200; i<=250; i++){
    float a = i/50.0*2*PI;
    for (int j=-50; j<=50; j++){
      float R2 = 80+20*cos(i*PI/200);
      armr.vertex(R2*cos(a), R2*sin(a),i);
      armr.vertex(R2*cos(a), R2*sin(a),i+60);
      
      body.vertex(R2*cos(a), R2*sin(a),i);
      body.vertex(R2*cos(a), R2*sin(a),i+80);

    }
  }
  armr.endShape();
  body.endShape();
 
  
}


void draw(){
  translate (width/2, height/2);
  rotateX(PI/3);
  background(255,192,255);
  
  //CORPS
  pushMatrix();
  scale(1,1.5,1);
  shape(body,0,0);
  popMatrix();  
  
  
  // BRAS DROIT
  pushMatrix();
  translate(-180,100,0);
  rotateX(PI/1.50);
  rotateY(PI/5.0);
  scale(0.2,0.5,1);
  shape(armr,0,0);
  popMatrix();
  
  
  // BRAS GAUCHE
  pushMatrix();
  translate(170,0,0);
  rotateX(PI/1.50);
  rotateY(4*PI/5.0);
  scale(0.2,0.5,1);
  shape(armr,200,0);
  popMatrix();
  
  
  
     
    
  
  
}
