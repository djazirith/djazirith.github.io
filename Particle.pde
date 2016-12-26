class Particle {

  PVector velocity;
  float lifespan;
  
  float px;
  float py;

  float partSize;
  float a;
  float speed;
  
  PVector gravity;


  Particle() {
    gravity = new PVector(random(-0.1,0.1),random(-0.1,0.1));
    partSize = random(16,32);
    a = random(TWO_PI);
    speed = random(1,4);
    velocity = new PVector(cos(a), sin(a));
    velocity.mult(speed);
    lifespan = 0;
  }
  
  void rebirth(float x, float y) {
    a = random(TWO_PI);
    speed = random(1,4);
    velocity = new PVector(cos(a), sin(a));
    velocity.mult(speed);
    lifespan = 12;
    px = x;
    py = y;
  }
  
  boolean isDead() {
    if (lifespan < 0) {
     return true;
    } else {
     return false;
    } 
  }
  

  void update() {
    lifespan = lifespan - 1;
    velocity.add(gravity);
    
    px += velocity.x;
    py += velocity.y;
  }
  
  void display() {
    pushMatrix();
    noStroke();
    tint(color(228,0,124,lifespan*lifespan));
    image(particleSprite, px, py, partSize, partSize);
    noTint();
    popMatrix();
  }
}