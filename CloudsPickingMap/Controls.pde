import controlP5.*;

public ControlP5 control;

void setParameters() {
  n = 300;
  dofRatio = 50;
  neighborhood = 800;
  viscosity = .1;
 // spread = 150;
  independence = .25; //.15
  rebirth = 0;
  rebirthRadius = 250;
  turbulence = 1.3;
  cameraRate = .1;
  averageRebirth = false;
}

void makeControls() {
  control = new ControlP5(this);
 
  
  int y = 0;
  control.addSlider("n", 1, 20000, n, 10, y += 10, 256, 9);
  control.addSlider("dofRatio", 1, 200, dofRatio, 10, y += 10, 256, 9);
  control.addSlider("neighborhood", 1, width * 2, neighborhood, 10, y += 10, 256, 9);
 // control.addSlider("speed", 0, 100, speed, 10, y += 10, 256, 9);
  control.addSlider("viscosity", 0, 1, viscosity, 10, y += 10, 256, 9);
  //control.addSlider("spread", 50, 200, spread, 10, y += 10, 256, 9);
  control.addSlider("independence", 0, 1, independence, 10, y += 10, 256, 9);
  control.addSlider("rebirth", 0, 100, rebirth, 10, y += 10, 256, 9);
  control.addSlider("rebirthRadius", 1, width, rebirthRadius, 10, y += 10, 256, 9);
  control.addSlider("turbulence", 0, 4, turbulence, 10, y += 10, 256, 9);
  control.addToggle("paused", false, 10, y += 11, 9, 9);
  control.setAutoInitialization(true);
  control.setAutoDraw(false);
}
