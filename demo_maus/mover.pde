public class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float topspeed;

  public Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    topspeed = 8;
  }

  public void prepare() {
    acceleration.mult(0);
  }

  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  public void update() {
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
  }
}
