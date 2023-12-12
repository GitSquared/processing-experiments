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
      // background terrain shape
      fill(0);
      stroke(#3d4b4c);

      if (y == pointRows.length-1 && amp.analyze() > 0.06) {
        fill(#ffffff);
        stroke(#ffffff);
      }

      beginShape();
      vertex(0, (y * densityMargin) + rowsYOffset, 0);

      for (int x = 0; x < pointRows[y].length; x++) {
        float z = pointRows[y][x];
        vertex(x * densityMargin, (y * densityMargin) + rowsYOffset, z);
      }

      vertex(pointRows[y].length * densityMargin, (y * densityMargin) + rowsYOffset, 0);
      endShape(CLOSE);

      // surface matrix
      noFill();
      for (int x = 0; x < pointRows[y].length; x++) {
        float z = pointRows[y][x];
        if (x % 5 == 0 && y % 5 == 0) {
          // 5x5 sea-level grid
          if (isBeat) {
            stroke(#ffffff);
          } else {
            stroke(#677e7f);
          }
          point(x * densityMargin, (y * densityMargin) + rowsYOffset, -96);
        };

        if (x % 20 == 0 || y % 20 == 0) {
          // 15x15 terrain surface grid
          if (isBeat) {
            stroke(#ffffff);
          } else {
            // stroke(#aacfd1);
            stroke(#677e7f);
          }
          point(x * densityMargin, (y * densityMargin) + rowsYOffset, z - 3);
        }
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

      float[] wave = fft.analyze();
      int totalBands = wave.length;
      float logMax = log(totalBands);
      float scalingFactor = 0.75;
      float compressionFactor = 0.1;

      for (int x = 0; x < pointRows[y].length; x++) {
        float noiseZ = getNoiseAtPoint(x, y + noiseOffset);

        // Map x-coordinate to a logarithmic index in the FFT bands
        float logIndex = exp(map(x, 0, pointRows[y].length, 0, logMax)) - 1;

        // Ensure logIndex is within the bounds of the FFT bands array
        int bandIndex = min(totalBands - 1, int(logIndex));

        // Calculate scaled amplitude (you can use the compression technique from earlier)
        float scaledAmplitude = pow(wave[bandIndex], compressionFactor) * scalingFactor;

        float spectrogramZ = -70 + -(scaledAmplitude * (255 - 70));

        newRow[x] = spectrogramZ;
        newRow[x] = min(spectrogramZ, noiseZ);
      }


      int height = -170;
      int beginX = 480;
      int depth = 130;
      int spectroWidth = 256;

      if (amp.analyze() > 0.06) {
        noFill();
        stroke(#00ff41);
        strokeWeight(3);
        beginShape();
        // vertex(beginX, 300, height);
        for(int i = 0; i < totalBands; i++){
          float logIndex = log(i+1) / logMax; // Add 1 to avoid log(0)

          // Map logarithmic index to the width of your display area
          float x = map(logIndex, 0, 1, 0, spectroWidth);

          // Scale amplitude to reveal subtler sounds
          float scaledAmplitude = pow(wave[i], compressionFactor) * scalingFactor;

          vertex(beginX+x, depth, height - scaledAmplitude * 170);
        }
        // vertex(beginX+spectroWidth, 300, height+1);
        endShape();
      }

      // insert it at end
      pointRows[y] = newRow;

      rowsYOffset = -8;
    }
  }
}
