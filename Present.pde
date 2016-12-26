class Present {

  PVector velocity;
  float maxspeed = 1;
  PVector acceleration;
  PVector position;
  float maxforce = 0.1;
  float w = 70;
  float h = 70;
  
  boolean falling = true;
  
  Present(float x, float y) {
    position = new PVector(x, y);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  void applyBehaviors(ArrayList<Present> presents) {
    if (!falling) {
     PVector separateForce = separate(presents);
     applyForce(separateForce);
    }
  }
  
    // Separation
  // Method checks for nearby individuals and steers away
  PVector separate (ArrayList<Present> presents) {
    PVector sum = new PVector();
    int count = 0;
    // For every boid in the group, check if it's too close
    for (Present other : presents) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount
      if (other != this && d < w) {
        if (d > 0) {
          // Calculate vector pointing away from neighbor
          PVector diff = PVector.sub(position, other.position);
          diff.normalize();
          diff.div(d);        // Weight by distance
          sum.add(diff);
          
        } else if (d == 0 ) {
          sum.add(new PVector(random(-1,1), random(-1,1)));
        }
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
    if (w > 32) {
      h = (float) Math.floor(h / --w * --w);
    } else {
       falling = false; 
    }
    
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
  
  void display() {
    image(presentImage, position.x - w/2, position.y - h/2, w, h);
  }
}