
Delaunay myDelaunay;
Voronoi myVoronoi;

boolean drawDelaunay = false;
boolean drawVoronoi  = false;

void generateDelaunay() {
  mPathManager.makeSinglePointArray();
  float[][] points  = mPathManager.getSinglePoints();
  myDelaunay = new Delaunay( points );
}

void generateVoronoi() {
  mPathManager.makeSinglePointArray();
  float[][] points  = mPathManager.getSinglePoints();
  myVoronoi = new Voronoi( points );
}


void drawDelaunay() {
  float[][] myEdges = myDelaunay.getEdges();

  strokeWeight(2);
  stroke(0, 200, 255, 200);
  for (int i=0; i<myEdges.length; i++) {
    float startX = myEdges[i][0];
    float startY = myEdges[i][1];
    float endX = myEdges[i][2];
    float endY = myEdges[i][3];
    line( startX, startY, endX, endY );
  }
}

void drawVoronoi() {
  float[][] myEdges = myVoronoi.getEdges();

  strokeWeight(2);
  stroke(0, 255, 200, 200);
  for (int i=0; i<myEdges.length; i++) {
    float startX = myEdges[i][0];
    float startY = myEdges[i][1];
    float endX = myEdges[i][2];
    float endY = myEdges[i][3];
    line( startX, startY, endX, endY );
  }
}

