class ParticleSystem {
  ArrayList<Particle> particles;

  PShape particleShape;

  ParticleSystem(int n) {
    particles = new ArrayList<Particle>();

    for (int i = 0; i < n; i++) {
      Particle p = new Particle();
      particles.add(p);
    }
  }

  void update() {
    for (Particle p : particles) {
      p.update();
    }
  }

  void setEmitter(float x, float y) {
    for (Particle p : particles) {
      if (p.isDead()) {
        p.rebirth(x, y);
      }
    }
  }

  void display() {
    for (Particle p : particles) {
      if (!p.isDead()) {
	p.display();
      }
    }
  }
}