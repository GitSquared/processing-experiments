public class Maus extends Mover {
  color tint = #ffec51;
  float size = 14;

  public Maus() {
    super();
  }

  public void draw() {
    noFill();
    stroke(tint);
    strokeWeight(2);

    pushMatrix();
    translate(location.x, location.y);
    rotate(acceleration.heading());
    triangle(
      -(size / 2), -(size / 2),
      -(size / 2), size / 2,
      size / 2, 0
    );
    popMatrix();
  }
}
