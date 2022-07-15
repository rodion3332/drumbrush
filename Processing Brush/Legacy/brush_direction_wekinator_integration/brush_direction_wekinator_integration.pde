//brushstroke + wekinator integration hopefully

//necessary for OSC communication with Wekinator
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

float myX, myY, scale, red, opacity; //parameters for Wekinator to control


float prevMouseX = 0;
float prevMouseY = 0;


PImage brush; 
PFont myFont;


void setup(){
  //initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost
  
  
  size(1280, 720, P2D);        //setup canvas
  background(252, 252, 227);   //creamy background
  imageMode(CENTER);           //center brush
  brush = loadImage("brush_white.png");
  
  myX = width/2;
  myY = height/2;
  scale = 0;
  red = 255;
  opacity = 0;
  sendOscNames();
  myFont = createFont("Arial", 14);
}

void draw(){
    float brushAngle = atan2(mouseX-prevMouseX, mouseY - prevMouseY); //adjust angle while painting
  
  for (int i = 0; i <5; i++){   //multiple little brushstrokes
    
    float jiggleColor = random(-50, 50);
    float jiggleOpacity = random(-40, 40);
    tint(red + jiggleColor, 0, 170 + jiggleColor, opacity + jiggleOpacity); //color
    
    
    pushMatrix();
    
    float jiggle =  random(-30,30);
    float jiggleAngle = random(-20, 20);
    float jiggleScale = random(-0.04, 0.04);
    
    translate(myX + jiggle, myY+ jiggle);
    rotate(brushAngle + radians(90+jiggleAngle));
    scale(scale);
    image(brush, 0, 0);
    
    
    popMatrix();
    drawtext();
  
  }
}

//void mousePressed(){
//  prevMouseX = mouseX;
//  prevMouseY = mouseY;
//}

//void mouseDragged(){
  
//  float brushAngle = atan2(mouseX-prevMouseX, mouseY - prevMouseY); //adjust angle while painting
  
//  for (int i = 0; i <5; i++){   //multiple little brushstrokes
    
//    float jiggleColor = random(-50, 50);
//    float jiggleOpacity = random(-40, 40);
//    tint(100 + jiggleColor, 0, 170 + jiggleColor, 200 + jiggleOpacity); //color
    
    
//    pushMatrix();
    
//    float jiggle =  random(-30,30);
//    float jiggleAngle = random(-20, 20);
//    float jiggleScale = random(-0.04, 0.04);
    
//    translate(mouseX + jiggle, mouseY+ jiggle);
//    rotate(brushAngle + radians(90+jiggleAngle));
//    scale(0.05 + jiggleScale, 0.05 + jiggleScale);
//    image(brush, 0, 0);
    
//    popMatrix();
  
//  }

//}

void oscEvent(OscMessage theOscMessage){
    if(theOscMessage.checkAddrPattern("/wek/outputs") == true){
      if(theOscMessage.checkTypetag("fffff")){
        float receivedX = theOscMessage.get(0).floatValue();
        float receivedY = theOscMessage.get(1).floatValue();
        float receivedScale = theOscMessage.get(2).floatValue();
        float receivedRed = theOscMessage.get(3).floatValue();
        float receivedOpacity = theOscMessage.get(4).floatValue();
        myX = map(receivedX, 0, 1, 0, width);
        myY = map(receivedY, 0, 1, 0, height);
        scale = map(receivedScale, 0, 1, 0, 0.2);
        red = map(receivedRed, 0, 1, 0, 255);
        opacity = map(receivedOpacity, 0, 1, 0, 255);
        
      } else{
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
    }
    
}


void sendOscNames(){
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("X");
  msg.add("Y");
  msg.add("Scale");
  msg.add("Red");
  msg.add("Opacity");
  oscP5.send(msg, dest);

}

void drawtext() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(0, 0, 255);

    text("Listening for message /wek/inputs on port 12000", 10, 10);
    text("Expecting 5 continuous numeric outputs, all in range 0 to 1:", 10, 25);
    text("   x, y, size, hue, rotation" , 10, 40);
}
