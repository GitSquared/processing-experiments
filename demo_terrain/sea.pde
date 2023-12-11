public class Sea {
  float seaLevel;
  float seaWidth;
  float seaHeight;

  public Sea(float targetSeaWidth, float targetSeaHeight, float targetSeaLevel) {
    println("Generating the sea...");

    seaWidth = targetSeaWidth;
    seaHeight = targetSeaHeight;
    seaLevel = targetSeaLevel;

    draw();
  }

  public void draw() {
    noStroke();
    fill(0, 0, 0);

    beginShape();
    vertex(0, 0, seaLevel);
    vertex(0, seaHeight, seaLevel);
    vertex(seaWidth, seaHeight, seaLevel);
    vertex(seaWidth, 0, seaLevel);
    endShape(CLOSE);
  }
}
