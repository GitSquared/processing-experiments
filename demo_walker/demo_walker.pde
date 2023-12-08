class Walker {
  int radius = 5;
  int moveOffset = 8;
  float[] moveProbabilities = {0.2, 0.5, 0.2, 0.1}; // north, east, south, west
  
  int walkedScreens = 0;
  int x;
  int y;
  float[] prob;

  Walker() {
    x = 0;
    y = height/2;

    prob = new float[moveProbabilities.length];
    prob[0] = moveProbabilities[0];
    for(int i = 1; i < moveProbabilities.length; i++) {
      prob[i] = prob[i-1] + moveProbabilities[i];
    }

    println("weights (north, east, south, west):");
    println(prob);
  }

  void step() {
    int oldY = y;

    float random = random(1);

    if (random < prob[0]) {
      y += moveOffset;
    } else if (random < prob[1]) {
      x += moveOffset;
    } else if (random < prob[2]) {
      y -= moveOffset;
    } else if (random < prob[3]) {
      x -= moveOffset;
    }

    if (x > width) {
      x = 0;
      walkedScreens++;
      if (walkedScreens >= 4) {
        background(0);
        walkedScreens = 0;
        y = height / 2;
      }
    } else if (x < 0) {
      x = width;
    }

    int upperBound = height / 2 + height / 4;
    int lowerBound = height / 2 - height / 4;

    if (y > upperBound) {
      y = upperBound;
      oldY = y;
    } else if (y < lowerBound) {
      y = lowerBound;
      oldY = y;
    }

    fill(255, 90);
    ellipse(x, y - 30, radius, radius);
    stroke(255, 75);
    strokeWeight(2);
    line(x, oldY, x, y);
  }
}

Walker w;

void setup() {
  size(600, 400);
  // fullScreen();
  background(0);
  frameRate(120);
  // frameRate(2);

  w = new Walker();
}

void draw() {
  w.step();
}
