final int NUM_PARTICLES = 4;
Particle[] particles = new Particle[NUM_PARTICLES];

PImage backgroundImg;

//--------------------------------------------------
void setup(){
  initWindow();
  initParticles();
}
void initWindow() {
  size(640, 380);
  smooth();
  frameRate(30);
  
  backgroundImg = loadImage("img/IMG_0181_upd_mini.JPG");
}
void initParticles() {
  for (int i = 0; i < NUM_PARTICLES; i++) {
    createParticle(i);
  }
}
void createParticle(int i){
  float x = random(50, width - 50);
  float y = random(50, height - 50);
  float sx = random(-5, 5);
  float sy = random(-3, 3);
  particles[i] = new Particle(i, x, y, sx, sy);
}

//--------------------------------------------------
void draw(){
  background(0);
  image(backgroundImg, 0, 0);
  noStroke();
  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i].glow();
    particles[i].move();
    particles[i].bound();
  }
}
void keyPressed() {
  if (key == 'r') {
    saveFrame("output/frame-####.png");
  }
}

//--------------------------------------------------
class Particle {
  int id;
  float posx, posy;
  float speedx, speedy;

  float[] baseColorRGB = new float[3];
  final float LIGHT_POWER_MIN = 0;
  final float LIGHT_POWER_MAX = 4 * 4;
  float lightPower;
  float lightPowerDelta;
  final int PIXEL_BORDER = 100;
  final int LIGHT_DISTANCE= 100 * 100;

  final int BOUND_DISTANCE_BUF = 50;

  Particle(int i, float x, float y, float sx, float sy) {
    id = i;
    posx = x;
    posy = y;
    speedx = sx;
    speedy = sy;

    setColor();
    lightPower = random(LIGHT_POWER_MIN, LIGHT_POWER_MAX);
    lightPowerDelta = 1.5;
  }

  void setColor() {
    baseColorRGB[0] = random(50, 100);
    baseColorRGB[1] = random(100, 220);
    baseColorRGB[2] = random(50, 100);
  }

  void glow() {
    loadPixels();

    int pixelIndex = 0;
    color c;
    float r, g, b;
    float dx, dy, dista;

    int left = (int)(max(0, posx - PIXEL_BORDER));
    int right = (int)(min(width, posx + PIXEL_BORDER));
    int top = (int)(max(0, posy - PIXEL_BORDER));
    int bottom = (int)(min(height, posy + PIXEL_BORDER));

    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        pixelIndex = y * width + x;
        c = pixels[pixelIndex];
        r = red(c);
        g = green(c);
        b = blue(c);
        dx = posx - x;
        dy = posy - y;
        dista = dx * dx + dy * dy;
        if (dista < LIGHT_DISTANCE) {
          r += baseColorRGB[0] * lightPower / dista;
          g += baseColorRGB[1] * lightPower / dista;
          b += baseColorRGB[2] * lightPower / dista;
          pixels[pixelIndex] = color(r, g, b);
        }
      }
    }
    updatePixels();
    
    lightPower += lightPowerDelta;
    if (lightPower >= LIGHT_POWER_MAX) {
      lightPower = LIGHT_POWER_MAX;
      lightPowerDelta *= -1;
    }else if (lightPower < LIGHT_POWER_MIN) {
      lightPower = LIGHT_POWER_MIN;
      lightPowerDelta *= -1;
    }
  }

  void move() {
    int plmi = getPlusMinus();
    float nx = plmi * noise(posx / 100) * speedx;
    float ny = plmi * noise(posy / 100) * speedy;
    posx += speedx + nx;
    posy += speedy + ny;
  }

  int getPlusMinus() {
    float r = random(-0.5, 0.5);
    if (r < 0) {
      return -1;
    }else{
      return 1;
    }
  }
  
  void bound() {
    if (posx + BOUND_DISTANCE_BUF >= width) {
      speedx *= -1;
      posx = width - BOUND_DISTANCE_BUF;
    }
    if (posx - BOUND_DISTANCE_BUF <= 0) {
      speedx *= -1;
      posx = BOUND_DISTANCE_BUF;
    }
    if (posy + BOUND_DISTANCE_BUF >= height) {
      speedy *= -1;
      posy = height - BOUND_DISTANCE_BUF;
    }
    if (posy - BOUND_DISTANCE_BUF <= 0) {
      speedy *= -1;
      posy = BOUND_DISTANCE_BUF;
    }
  }
}
