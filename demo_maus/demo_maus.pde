Maus maus;

void setup() {
  size(600, 400);
  // fullScreen();
  background(0);
  frameRate(30);

  maus = new Maus();
}

void draw() {
  background(#19231a);

  PVector mouse = new PVector(mouseX, mouseY);
  PVector mausToMouse = PVector.sub(mouse, maus.location);
  mausToMouse.normalize();
  mausToMouse.mult(0.5);

  maus.prepare();

  maus.applyForce(mausToMouse);

  maus.update();
  maus.draw();
}
