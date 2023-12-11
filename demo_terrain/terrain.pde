public class Terrain {
  float noiseScale = 0.02;
  int densityMargin = 6;
  int pointSize = 2;

  float[][] pointRows;
  int rowsYOffset = 0;
  int noiseOffset = 0;

  public Terrain(int cols, int rows) {
    println("Generating new terrain...");

    println(cols * rows, "points on a " + cols + "x" + rows + " grid");

    pointRows = new float[rows][cols];
    for (int y = 0; y < rows; y++) {
      float[] row = new float[cols];

      for (int x = 0; x < cols; x++) {
        float z = getNoiseAtPoint(x, y);
        row[x] = z;
      }
      pointRows[y] = row;
    }

    draw();
  }

  float getNoiseAtPoint(int x, int y) {
    float noiseVal = noise(x * noiseScale, y * noiseScale);
    float z = map(noiseVal, 0, 1, 0, 255);

    return -z;
  }

  public void draw() {
    strokeWeight(pointSize);

    for (int y = 0; y < pointRows.length; y++) {
      noFill();
      stroke(128,128,128);
      if (y == pointRows.length - 1) {
        // last row, end of terrain away from camera
        // draw an actual wall corresponding to the terrain
        // so that it can hide the sun
        noStroke();
        fill(0);
        beginShape();
        vertex(0, (y * densityMargin) + rowsYOffset, 0);
        for (int x = 0; x < pointRows[y].length; x++) {
          float z = pointRows[y][x];
          vertex(x * densityMargin, (y * densityMargin) + rowsYOffset, z);
        }
        vertex(pointRows[y].length * densityMargin, (y * densityMargin) + rowsYOffset, 0);
        endShape(CLOSE);
        continue;
      }

      for (int x = 0; x < pointRows[y].length; x++) {
        float z = pointRows[y][x];
        point(x * densityMargin, (y * densityMargin) + rowsYOffset, z);
      }
    }
  }

  public void step() {
    rowsYOffset -= 2;

    if (rowsYOffset < -(densityMargin * 2)) {

      // shift all rows down
      for (int i = 0; i < pointRows.length - 1; i++) {
        arraycopy(pointRows[i + 1], 0, pointRows[i], 0, pointRows[i].length);
      }

      // make a new row

      noiseOffset += 1;
      int y = pointRows.length - 1;
      float[] newRow = new float[pointRows[y].length];
      for (int x = 0; x < pointRows[y].length; x++) {
        float z = getNoiseAtPoint(x, y + noiseOffset);
        newRow[x] = z;
      }

      // insert it at end
      pointRows[y] = newRow;

      rowsYOffset = -8;
    }
  }
}
