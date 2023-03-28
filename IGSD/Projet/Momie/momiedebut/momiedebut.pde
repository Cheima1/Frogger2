void setup() {
  size(600, 600, P3D);
  
}

void draw() {
  translate(width/2, height/2);
  rotateX(PI/3);
  background(255,192,255);
  
  strokeWeight(3);
  beginShape(QUAD_STRIP);
  for(int i = -100; i <= 200; i++) {
    float a = i/50.0*2*PI;
    float R2 = 150-abs(i)+ 50*cos(a);
    float R3 = 50*sin(a);
    vertex(200*cos(a), 200*sin(a), R3+i);
    vertex(200*cos(a), 200*sin(a), R3+i+40);
    
  }
  endShape();
  endShape();
}
  
