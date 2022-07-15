float prevMouseX = 0;
float prevMouseY = 0;


PImage brush;


void setup(){
  size(1280, 720, P2D);
  imageMode(CENTER);
  brush = loadImage("brush_white.png");
}

void draw(){

}

void mousePressed(){
  prevMouseX = mouseX;
  prevMouseY = mouseY;
}

void mouseDragged(){
  
  float brushAngle = atan2(mouseX-prevMouseX, mouseY - prevMouseY);
  
  for (int i = 0; i <5; i++){
  pushMatrix();
  
  float jiggle =  random(-30,30);
  float jiggleAngle = random(-20, 20);
  float jiggleScale = random(-0.04, 0.04);
  
  translate(mouseX + jiggle, mouseY+ jiggle);
  rotate(brushAngle + radians(90+jiggleAngle));
  scale(0.05 + jiggleScale);
  image(brush, 0, 0);
  
  popMatrix();
  
  }

}
