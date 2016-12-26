/* @pjs preload="data/sprite.png"; */
/* @pjs preload="data/bg2.png"; */
/* @pjs preload="data/hat2.png"; */
/* @pjs preload="data/roundGiftBox.png"; */

// Based on examples from "The Nature of Code" by Daniel Shiffman
// http://natureofcode.com

ParticleSystem ps;
PImage agentImage, presentImage, particleSprite;

ArrayList<Individual> individuals;
ArrayList<Present> presents;

boolean clicked = false;

void setup() {
  frameRate(32);
  
  PImage bg = loadImage("data/bg2.png");
  if (window.innerWidth > 868 || window.innerHeight > 620) {
    size(868,620, P2D);
  } else {
    size(window.innerWidth, window.innerHeight, P2D);
	bg.resize(window.innerWidth, window.innerHeight);
  }
  background(bg);
  
  agentImage = requestImage("data/hat2.png");
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