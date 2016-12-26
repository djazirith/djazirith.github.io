static long mostRecentPickup = 0;

class Individual
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  long patience = 500; //milliseconds

  Individual(float x, float y) {
    position = new PVector(x, y);
    r = 50;
    maxspeed = 8;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  void applyBehaviors(ArrayList<Individual> individuals) {
     PVector separateForce = separate(individuals);
     PVector seekForce = seek();
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
     if (!p.falling) {
       float d = PVector.dist(position, p.position);
       if (d < r/2 + p.w/2) {
         ps.setEmitter(p.position.x - p.w/2, p.position.y - p.h/2);
         it.remove();
         mostRecentPickup = millis();
         chosen = null;
       }
     }
    }
  }
    
  void careAboutPresents() {
    long currentTime = millis();
    //if there is something to pick up and there hasn't been a recent pick-up
    if (presents.size() > 1 
      && currentTime - mostRecentPickup > patience) 
    {
      //if this individual hasn't picked up her present of choise and no other individual picked up her present of choice
      if (chosen == null || !presents.contains(chosen)) {
        //pick randomly
        chosen = presents.get((int) random(0, presents.size()));
      }
    } else {
      //reset choice so that each present attracts equally strong
      chosen = null;
    }
  }
  
  Present chosen = null;
  
  boolean ignorePresent(Present p) {
    if (chosen == null) {
      return false;
    }
    if (chosen.equals(p)) {
      return false;
    }
    return true;
  }
  
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek() {
    PVector BuridansAss = new PVector();
    for (Present p : presents) {
      if (chosen != null && ignorePresent(p)) {
        continue;
      }
            
      PVector desired = PVector.sub(p.position,position);  // A vector pointing from the position to the target
      desired.normalize();
      desired.mult(maxspeed);
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      
      BuridansAss.add(steer);
    }
    
    return BuridansAss;
  }

  // Separation
  // Method checks for nearby individuals and steers away
  PVector separate (ArrayList<Individual> individuals) {
    float desiredseparation = r;
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the group, check if it's too close
    for (Individual other : individuals) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount
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
    rotate(velocity.heading() + PI/2);
    image(agentImage,0,0);
    popMatrix();
  }

}