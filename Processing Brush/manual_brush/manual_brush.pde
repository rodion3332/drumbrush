//manual brush

import processing.serial.*;
Serial myPort;

int pot = 0;
float red = 0;
float green = 0;
float blue = 0;

//parameters for manual control by mouse
float prevMouseX = 0;
float prevMouseY = 0;

//initialize brush image
PImage brush; 


void setup() {
  
  //myPort = new Serial(this, "COM5", 9600);

  //setup canvas
  size(1920, 1080, P2D);
  background(0);  
  
  //load brush
  imageMode(CENTER);
  brush = loadImage("brush_white.png");

}

void draw() {
  println(red + " " + green + " " + blue);
  noStroke();
  //fill(255, 8);
  //rect(0,0,width,height);
  //pot = myPort.read();
  //bgcolor = map(pot, 0, 1024, 0, 255);

}

void mousePressed(){
  prevMouseX = mouseX;
  prevMouseY = mouseY;
  //background(255);
}

void keyPressed(){
  if (key == 'R' || key == 'r'){
    saveFrame("frame-####.png");
  }
  else if (key == ']'){
    red = red + 15;
  }
  else if (key == '['){
    red = red - 15;
  }
    else if (key == '='){
    green = green + 15;
  }
    else if (key == '-'){
    green = green - 15;
  }
    else if (key == '.'){
    blue = blue + 15;
  }
    else if (key == ','){
    blue = blue - 15;
  }
    else if (key == 'c'){
      background(0);
    }
  
}


void mouseDragged(){

  float chance = random(100);

  


  //brush section
  float brushAngle = atan2(mouseX-prevMouseX, mouseY-prevMouseY); //adjust angle while painting

  for (int i = 0; i <5; i++) {   //multiple little brushstrokes

    float jiggleColor = random(-50, 50);
    float jiggleOpacity = random(-40, 40);
    tint(red, green, blue, 200 + jiggleOpacity); //color


    pushMatrix();

    float jiggle =  random(-100, 100);
    float jiggleAngle = random(-20, 20);
    float jiggleScale = random(-0.04, 0.04);

    translate(mouseX + jiggle, mouseY + jiggle);
    
    //if(chance > 60){
    //  tint(random(255), random(255), 170);
    //  //rotate(random(radians(180)));
    //  image(brush, 100 + random(-50, 50), 0 + random(-50, 50), 100+random(-50, 50), random(50));
    //}
    
    rotate(brushAngle + radians(90+jiggleAngle));
    scale(0.15+jiggleScale);
    image(brush, 0, 0);


    popMatrix();
    
  } 
}
