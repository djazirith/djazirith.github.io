/* @pjs preload="data/sprite.png"; */
/* @pjs preload="data/bg2.png"; */
/* @pjs preload="data/hat2.png"; */
/* @pjs preload="data/roundGiftBox.png"; */

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
  
  bg = requestImage("data/bg2.png");
  agentImage = requestImage("data/hat2.png");
  agentImage.resize(24, 24);
  presentImage = requestImage("data/roundGiftBox.png");
  particleSprite = requestImage("data/sprite.png");
  
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