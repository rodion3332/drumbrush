//brushstroke + wekinator integration hopefully

//importing sound library
import processing.sound.*;
AudioIn input;
Amplitude loudness;

//necessary for OSC communication with Wekinator
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

//initialize pdf export tools
import processing.pdf.*;
boolean record;

float myX, myY, scale, red; //parameters for Wekinator to control

//parameters for manual control by mouse
float prevMouseX = 0;
float prevMouseY = 0;

//initialize brush image and font
PImage brush; 
PFont myFont;


void setup() {
  
  //initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost

  //initialize microphone input and start listening
  input = new AudioIn(this, 0); 
  input.start();

  // Create a new Amplitude analyzer
  loudness = new Amplitude(this);

  // Path the input to the volume analyzer
  loudness.input(input);

  //setup canvas
  size(1920, 1080, P2D);
  background(255);  
  
  //load brush
  imageMode(CENTER);
  brush = loadImage("brush_white.png");

  myX = width/2;
  myY = height/2;
  scale = 0;
  red = 255;
  //opacity = 0;
  sendOscNames();
  myFont = createFont("Arial", 14);
}

void draw() {
  
  //PDF saving
  //if (record){beginRecord(PDF, "frame-####.pdf");}

  //microphone section
  float inputLevel = map(mouseY, 0, height, 1.0, 0.0);
  input.amp(inputLevel);

  float volume = loudness.analyze();
  int size = int(map(volume, 0, 0.5, 1, 350));
  //ellipse (1720, 200, size, size);

  if (size > 8) {
    //int lifespan = 0;
    tint(random(255), random(255), 170);
    //rotate(random(radians(180)));
    image(brush, myX + random(-100, 100), myY + random(-100, 100), random(50), random(50));
  


  //brush section
    float brushAngle = atan2(mouseX-prevMouseX, mouseY - prevMouseY); //adjust angle while painting
    boolean brushState = true;
    brushState = true;
  
    for (int i = 0; i <5; i++) {   //multiple little brushstrokes
  
      float jiggleColor = random(-50, 50);
      float jiggleOpacity = random(-40, 40);
      tint(red + jiggleColor, 170 + jiggleColor, random(255) + jiggleColor, 200 + jiggleOpacity); //color
  
  
      //pushMatrix();
  
      float jiggle =  random(-30, 30);
      float jiggleAngle = random(-20, 20);
      float jiggleScale = random(-0.04, 0.04);
  
      translate(myX + jiggle, myY+ jiggle);
      rotate(brushAngle + radians(90+jiggleAngle));
      scale(scale+jiggleScale);
      image(brush, 0, 0);
  
  
      //popMatrix();
      drawtext();
      //if(brushState){brushState = false; lifespan-= 5;}
      
    }
  }
  //if (record){
  //  endRecord();
  //  record = false;
  //}
  
  
}

void mousePressed(){
  //prevMouseX = mouseX;
  //prevMouseY = mouseY;
  record = true;
}


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

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("ffff")) {
      float receivedX = theOscMessage.get(0).floatValue();
      float receivedY = theOscMessage.get(1).floatValue();
      float receivedScale = theOscMessage.get(2).floatValue();
      float receivedRed = theOscMessage.get(3).floatValue();
      //float receivedOpacity = theOscMessage.get(4).floatValue();
      myX = map(receivedX, 0, 1, 0, width);
      myY = map(receivedY, 0, 1, 0, height);
      scale = map(receivedScale, 0, 1, 0, 0.2);
      red = map(receivedRed, 0, 1, 0, 255);
      //opacity = map(receivedOpacity, 0, 1, 0, 255);
    } else {
      println("Error: unexpected OSC message received by Processing: ");
      theOscMessage.print();
    }
  }
}


void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("X");
  msg.add("Y");
  msg.add("Scale");
  msg.add("Red");
  //msg.add("Opacity");
  oscP5.send(msg, dest);
}

void drawtext() {
  stroke(0);
  textFont(myFont);
  textAlign(LEFT, TOP); 
  fill(0, 0, 255);

  text("Listening for message /wek/inputs on port 12000", 10, 10);
  text("Expecting 5 continuous numeric outputs, all in range 0 to 1:", 10, 25);
  text("   x, y, size, hue, rotation", 10, 40);
}
