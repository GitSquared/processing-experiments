public class Sun {
  float sunX;
  float sunY;
  float sunZ;

  public Sun(float targetSunX, float targetSunY, float targetSunZ) {
    println("Generating the sun...");

    sunX = targetSunX;
    sunY = targetSunY;
    sunZ = targetSunZ;

    draw();
  }

  public void draw() {
    stroke(0xFFFFFFFF);
    noFill();
    translate(sunX, sunY, sunZ);
    sphereDetail(150);
    sphere(60);
  }
}
