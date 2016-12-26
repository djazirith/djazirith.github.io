/* @pjs preload="sprite.png" */
/* @pjs preload="bg2.png" */
/* @pjs preload="hat2.png" */
/* @pjs preload="roundGiftBox.png" */

// Based on examples from "The Nature of Code" by Daniel Shiffman
// http://natureofcode.com

ParticleSystem ps;
PImage bg, agentImage, presentImage, particleSprite;

ArrayList<Individual> individuals;
ArrayList<Present> presents;

boolean clicked = false;

void setup() {
  size(868,620, P2D);
  frameRate(32);
  
  bg = requestImage("bg2.png");
  agentImage = requestImage("hat2.png");
  presentImage = requestImage("roundGiftBox.png");
  particleSprite = requestImage("sprite.png");
  
  ps = new ParticleSystem(12);
  
  individuals = new ArrayList<Individual>();
  presents = new ArrayList<Present>();
  for (int i = 0; i < 14; i++) {
    individuals.add(new Individual(random(width),random(height)));
  }
}

void draw() {
  background(bg);

  for (Individual v : individuals) {
    v.applyBehaviors(individuals);
    v.update();
    v.display();
  }

  for (Present p : presents) {
    p.applyBehaviors(presents);
    p.update();
    p.display(); 
  }
  
  ps.update();
  ps.display();
  
  if (!clicked)
  {
    fill(32);
    textSize(18);
    text("Drop down presents by clicking any mouse button or touching the screen.", 10, height-16);
  }
}


void mouseClicked() {
  clicked = true;
  presents.add(new Present(mouseX, mouseY));
}


/*
static long mostRecentPickup = 0;

class Individual {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  long patience;
  long threshold = 1000; //in milliseconds

  Individual(float x, float y) {
    patience = (long) random(0, 250); //in milliseconds
    
    position = new PVector(x, y);
    r = 24;
    maxspeed = 2;
    maxforce = 0.02;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    
    currentDirection = 1;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  void applyBehaviors(ArrayList<Individual> individuals) {
     PVector separateForce = separate(individuals);
     PVector seekForce = seek(new PVector(mouseX,mouseY));
     separateForce.mult(2);
     seekForce.mult(1);
     applyForce(separateForce);
     applyForce(seekForce);
     
     collectPresents();
     careAboutPresents();
  }
  
  void collectPresents() {
   for (Iterator<Present> it = presents.iterator(); it.hasNext();) {
     Present p = it.next();
     float d = PVector.dist(position, p.position);
     if (d < r/2 + p.w/2) {
       ps.setEmitter(p.position.x, p.position.y);
       //particleSystem.addParticles(new PVector(p.position.x, p.position.y), 100);
       it.remove();
       mostRecentPickup = millis();
     }
    }
  }
  
  long mostRecentAttempt = 0; 
  void careAboutPresents() {
    long currentTime = millis();
    if (currentTime - mostRecentPickup > threshold) {
      if (currentTime - mostRecentAttempt > patience) {
        chosen = (int) random(0, presents.size());
        mostRecentAttempt = currentTime; 
      }
    } else {
      chosen = -1;
    }
  }
  
  int chosen = -1;
  boolean ignorePresent(int index) {
    if (chosen != index) {
      return true;
    }
    return false;
  }
  
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector magare = new PVector();
    int c = 0;
    for (Present t : presents) {
      if (chosen >= 0 && ignorePresent(c))
        continue;
      PVector desired = PVector.sub(t.position,position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
      desired.normalize();
      desired.mult(maxspeed);
    // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      magare.add(steer);
      c++;
    }
    
    return magare;
  }

  // Separation
  // Method checks for nearby individuals and steers away
  PVector separate (ArrayList<Individual> individuals) {
    float desiredseparation = r * 1.5;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the particleSystem, check if it's too close
    for (Individual other : individuals) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    pushMatrix();
    translate(position.x - r/2, position.y - r/2);
    rotate(velocity.heading2D() + PI/2);
    image(agentImage);
    popMatrix();
  }

}

class Present {

  PVector position;
  float w = 81;
  float h = 87;
  
  Present(float x, float y) {
    position = new PVector(x, y);
  }
  
  void display() {   
    if (w > 32) {
      h = Math.floor(h / --w * --w);
    }
    //tint(color(239, 228));
    image(presentImage, position.x - w/2, position.y - h/2, w, h);
    //noTint();
  }
}
*/