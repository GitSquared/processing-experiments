import processing.sound.*;

AudioIn in;
Amplitude amp;
FFT fft;
BeatDetector beat;
boolean isBeat = false;

Terrain terrain;
Sea sea;
Sun sun;

int cameraX;
int cameraY;
int cameraZDistance = 300;
int cameraZAngle = 50;
float cameraZ = -(cameraZDistance * tan(radians(cameraZAngle)));
int cameraLookOffset = 400;

void updateCamera() {
  camera(cameraX, cameraY, cameraZ, cameraX, cameraY+cameraLookOffset, 0, 0, 0, 1);
}

void setup() {
  size(602, 399, P3D);
  // fullScreen(P3D);
  frameRate(60);

  int cols = 180;
  int rows = 90;

  cameraX = int((float)cols / 0.3);
  cameraY = 0;

  updateCamera();

  in = new AudioIn(this, 0);
  in.start();
  amp = new Amplitude(this);
  amp.input(in);
  fft = new FFT(this, 4096);
  fft.input(in);
  beat = new BeatDetector(this);
  beat.sensitivity(16);
  beat.input(in);

  terrain = new Terrain(cols, rows);
  sea = new Sea(1200, 630, -95);
  sun = new Sun(cameraX, 600, -95);
}

void draw() {
  isBeat = beat.isBeat();

  background(0);

  terrain.step();
  terrain.draw();

  sea.draw();

  sun.draw();
}
