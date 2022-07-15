//brushstroke + wekinator integration hopefully

//importing sound library
import processing.sound.*;
AudioIn input;
Amplitude loudness;
BeatDetector beatDetector;

//necessary for OSC communication with Wekinator
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

//initialize pdf export tools
import processing.pdf.*;
boolean record;

float myX, myY, red, green, blue; //parameters for Wekinator to control

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

  beatDetector = new BeatDetector(this);
  beatDetector.input(input);
  
  //setup canvas
  size(1920, 1080, P2D);
  background(255);  
  
  //load brush
  imageMode(CENTER);
  brush = loadImage("brush_white.png");

  myX = width/2;
  myY = height/2;
  //scale = 0;
  red = 255;
  green = 255;
  blue = 255;
  //opacity = 0;
  sendOscNames();
  myFont = createFont("Arial", 14);
  
}

void draw() {
  noStroke();
  //fill(255, 1.1); //1.1 for paint-drying effect
  //rect(0,0,width,height);
  
  //microphone section
  float inputLevel = map(mouseY, 0, height, 1.0, 0.0);
  input.amp(inputLevel);

  float volume = loudness.analyze();
  int size = int(map(volume, 0, 0.5, 1, 350));
  //ellipse (1720, 200, size, size);

    if (size > 8) {
    if(beatDetector.isBeat()){
      float chance = random(100);
      if(chance > 50){
        tint(size, random(255), 170);
        image(brush, myX + random(-100, 100), myY + random(-100, 100), random(50), random(50));
      }
    //}
  


  //brush section
    float brushAngle = atan2(myX-prevMouseX, myY-prevMouseY); //adjust angle while painting
  
    for (int i = 0; i <5; i++) {   //multiple little brushstrokes
  
      float jiggleColor = random(-50, 50);
      float jiggleOpacity = random(-40, 40);
      
  
  
      //pushMatrix();
  
      float jiggle =  random(-100, 100);
      float jiggleAngle = random(-20, 20);
      float jiggleScale = random(-0.04, 0.04);
      
      tint(red +jiggleColor, green + jiggleColor, blue + jiggleColor, 200 + jiggleOpacity); //color
      translate(myX + jiggle, myY+ jiggle);
      rotate(brushAngle + radians(90+jiggleAngle));
      scale(map(volume, 0, 0.5, 0.07, 0.38)+jiggleScale);
      image(brush, 0, 0);

  
  
      //popMatrix();
      
    }
  }
}


void mousePressed(){
  //prevMouseX = mouseX;
  //prevMouseY = mouseY;
  background(255);
}


void keyPressed(){
  if (key == 'R' || key == 'r'){
    saveFrame("frame-####.png");
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("fffff")) {
      
      float receivedX = theOscMessage.get(0).floatValue();
      float receivedY = theOscMessage.get(1).floatValue();
      float receivedRed = theOscMessage.get(2).floatValue();
      float receivedGreen = theOscMessage.get(3).floatValue();
      float receivedBlue = theOscMessage.get(4).floatValue();
      
      myX = map(receivedX, 0, 1, 0, width);
      myY = map(receivedY, 0, 1, 0, height);
      red = map(receivedRed, 0, 1, 0, 255);
      green = map(receivedGreen, 0, 1, 0, 255);
      blue = map(receivedBlue, 0, 1, 0, 255);
      
    } else {
      println("Error: unexpected OSC message received by Processing: ");
      theOscMessage.print();
      
      prevMouseX = myX;
      prevMouseY = myY;
    }
  }
}


void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("X");
  msg.add("Y");
  //msg.add("Scale");
  msg.add("Red");
  msg.add("Green");
  msg.add("Blue");
  //msg.add("Opacity");
  oscP5.send(msg, dest);
}
