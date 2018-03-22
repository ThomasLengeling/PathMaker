import peasy.*;
import toxi.geom.*;
import java.util.Vector;
import processing.opengl.*;
import ddf.minim.*;

//variables
color bkgColor = color(10);

boolean recording;
boolean viewGUI = false;
boolean viewParticles;

Vec3D globalOffset, cameraCenter;
public float neighborhood, viscosity, turbulence, cameraRate, rebirthRadius, independence, dofRatio;
public int n, rebirth;
public boolean averageRebirth, paused;
boolean debugBuffer = false;

Plane focalPlane;
PeasyCam cam;
ParticleManager mParticleManager;
PMatrix mat_scene;

PGraphics pgBuffer;
PGraphics3D g3;

Minim minim;

int currentIndex = -1;

int mDrawMode = 1;
int frameCounter = 0;

boolean inside = false;

PImage bkgImg;


void setup() {
  size(1920, 1080, OPENGL);
  mat_scene = getMatrix();

  g3 = (PGraphics3D)g;
  pgBuffer = createGraphics(width, height, OPENGL);
  cam = new PeasyCam(this, 2000); //1600
  cam.setResetOnDoubleClick(false);
  //cam.setMinimumDistance(50);

  minim = new Minim(this);


  frameRate(30);

  noiseSeed(0);
  randomSeed(0);

  setParameters();
  makeControls();

  cameraCenter = new Vec3D();
  globalOffset = new Vec3D(0, 1. / 3, 2. / 3);

  mParticleManager = new ParticleManager();

  //mParticleManger.createParticles(n);

  //readTestAudioJSON();

  readAudioJSON(mParticleManager, mDrawMode);

  bkgImg = loadImage("gradient_01.png");
}

void draw() {  

  // background(bkgImg);//bkgColor);
  background(bkgColor);
  {

    pushMatrix();
    //background(bkgColor);
    hint(ENABLE_DEPTH_TEST);

    Vec3D avg = mParticleManager.getAvgfPos();
    avg.scaleSelf(1. / mParticleManager.getNumParticles());

    cameraCenter.scaleSelf(1 - cameraRate);
    cameraCenter.addSelf(avg.scale(cameraRate));

    translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);

    float[] camPosition = cam.getPosition();
    focalPlane = new Plane(avg, new Vec3D(camPosition[0], camPosition[1], camPosition[2]));

    hint(DISABLE_DEPTH_TEST);

   // if (frameCounter >= 205) {
   //   mParticleManager.drawLines(this.g, avg);
    //} else {
      mParticleManager.drawPoints(this.g, avg);
   // }
    //drawPoints

    globalOffset.addSelf( 
    turbulence / neighborhood, 
    turbulence / neighborhood, 
    turbulence / neighborhood
      );

    popMatrix();
  }



  /*
  cam.beginHUD();
   image(pg, 0, 0);
   
   */
  if (viewGUI) {
    gui();
  }
  if (frameCounter == 305) { //205
    paused = true;
    println("num :"+mParticleManager.getNumParticles());
  } else {
    frameCounter++;
  }

  if (debugBuffer) {
    cam.beginHUD();
    image(pgBuffer, 0, 0, 300, 300);
    cam.endHUD();
  }


  if (currentIndex > 0) {
    cam.beginHUD();
    mParticleManager.drawImage(currentIndex);
    cam.endHUD();
  }


  //save("img_"+frameCount+".png");
}


void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  control.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void mouseClicked() {
  pgBuffer.beginDraw();
  pgBuffer.background(getColor(-1)); // since background is not an object, its id is -1
  pgBuffer.noStroke();
  pgBuffer.setMatrix(g3.camera);

  pgBuffer.translate(-cameraCenter.x, -cameraCenter.y, -cameraCenter.z);

  mParticleManager.drawBuffer(pgBuffer);
  pgBuffer.endDraw();
  // get the pixel color under the mouse
  color pick = pgBuffer.get(mouseX, mouseY);
  // get object id
  int id = getId(pick);
  // if id > 0 (background id = -1)
  if (id >= 0) {

    mParticleManager.toggleParticle(id);
    currentIndex = id;
  }
}

// id 0 gives color -2, etc.
color getColor(int id) {
  return -(id + 2);
}
// color -2 gives 0, etc.
int getId(color c) {
  println(-(c+2));
  return -(c + 2);
}

void keyPressed() {

  if (key == 'p') {
    paused = !paused;
    println("fs: "+frameCount);
  }

  if (key == 'g') {
    viewGUI = !viewGUI;
  }

  if (key == 'f') {
    viewParticles = !viewParticles;
  }

  if (key == 'd') {
    debugBuffer = !debugBuffer;
  }

  if (key == 's') {
    save("img_"+frameCount+".png");
  }


  if ( key == '1') {
    mDrawMode = 1;
    frameCounter = 0;
    paused = false;
    resetParticles(mParticleManager, mDrawMode);
  }

  if (key == '2') {
    mDrawMode = 2;
    frameCounter = 0;
    paused = false;
    resetParticles(mParticleManager, mDrawMode);
  }

  if (key == '3') {
    mDrawMode = 3;
    frameCounter = 0;
    paused = false;
    resetParticles(mParticleManager, mDrawMode);
  }
}
