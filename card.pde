/* @pjs preload="data/bg2.png,data/sprite.png,data/hat2.png,data/roundGiftBox.png"; */

// Based on examples from "The Nature of Code" by Daniel Shiffman
// http://natureofcode.com

ParticleSystem ps;
PImage agentImage, presentImage, particleSprite;

ArrayList<Individual> individuals;
ArrayList<Present> presents;

boolean clicked = false;

boolean mobile = false;

void setup() {
  frameRate(32);
  
  bg = loadImage("data/bg2.png");
  if (window.innerWidth > 868 || window.innerHeight > 620) {
    size(868,620, P2D);
  } else {
    size(window.innerWidth - 15, window.innerHeight - 15, P2D);
	mobile = true;
  }
  
  agentImage = loadImage("data/hat2.png");
  presentImage = loadImage("data/roundGiftBox.png");
  particleSprite = loadImage("data/sprite.png");
  
  ps = new ParticleSystem(12);
  
  presents = new ArrayList<Present>();
  
  float radius;
  if (mobile) {
    radius = 24;
  } else {
    radius = 50;
  }
  
  individuals = new ArrayList<Individual>();
  for (int i = 0; i < 14; i++) {
    individuals.add(new Individual(random(width),random(height), radius));
  }
}

void draw() {
  if (mobile) {
    bg.resize(window.innerWidth - 15, window.innerHeight - 15);
	agentImage.resize(24, 24);
	image(bg, 0, 0);
  } else {
	background(bg);
  }
  
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
	if (mobile) {
	  text("Drop down presents by touching the screen.", 10, height-16);
	} else {
	  text("Drop down presents by clicking any mouse button.", 10, height-16);
	}
  }
}


void mouseClicked() {
  clicked = true;
  presents.add(new Present(mouseX, mouseY));
}