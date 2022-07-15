
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A random walker class!

class Walker {
  PVector position;
  int lifespan = 60;

  PVector noff;

  Walker() {
    position = new PVector(myX, myY);
    noff = new PVector(random(1000),random(1000));
  }

  void display() {
    scale(0.05);
    tint(random(255), 0, random(255));
    //tint(255, lifespan);
    image(brush, 0, 0);
  }

  // Randomly move up, down, left, right, or stay in one place
  void walk() {
    
    position.x = map(noise(noff.x),0,1,0,width);
    position.y = map(noise(noff.y),0,1,0,height);
    
    noff.add(0.01,0.01,0);
    
    lifespan --;
  }
}
