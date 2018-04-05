import geomerative.*;

RShape grp;
RPoint[][] pointPaths;

PointPath [] paths;

int numPaths;

float xmag, ymag, newYmag, newXmag = 0;
float z = 0;

boolean ignoringStyles = false;

int numPoints = 2000;

PImage map;

void setup() {


  map = loadImage("LLL.png");
  size(1920, 1080, P3D);

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles(ignoringStyles);

  RG.setPolygonizer(RG.ADAPTATIVE);

  grp = RG.loadShape("simple_path.svg");
  grp.centerIn(g, 100, 1, 1);

  pointPaths = grp.getPointsInPaths();

  numPaths = pointPaths.length;

  if (numPaths == 0) {
    println("no paths are in the SVG file");
  }

  paths = new PointPath[numPoints];

  println(pointPaths.length);

  for (int i = 0; i < numPoints; i++) {

    int indexPath = (int)random(0, pointPaths.length - 1);
    paths[i] = new PointPath(indexPath);

    int lengthP = pointPaths[indexPath].length;


    paths[i].setNumPoints(lengthP);

    paths[i].reset();
    int curr = paths[i].getCurrInc();
    int next = paths[i].getNexInt();

    RPoint sp = pointPaths[lengthP][curr];
    RPoint fp = pointPaths[lengthP][next];

    paths[i].setStart(sp.x, sp.y);
    paths[i].setFinal(fp.x, fp.y);
  }
}

void draw() {
  strokeWeight(1);
  noStroke();
  fill(0, 255);
  rect(0, 0, width, height);

  pushMatrix();

  translate(width/2, height/2);

  //newXmag = mouseX/float(width) * TWO_PI;
  //newYmag = mouseY/float(height) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0;
  }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0;
  }

  rotateX(-ymag); 
  rotateY(-xmag); 


  //update Points
  updatePoints();

  //intersection()
  drawConnections();

  // draw lines
  strokeWeight(3);
  stroke(155, 150);
  noFill();
  drawLinePaths();

  popMatrix();
}

void mousePressed() {
  ignoringStyles = !ignoringStyles;
  RG.ignoreStyles(ignoringStyles);
}