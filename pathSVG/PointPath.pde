class PointPath {

  //positions
  float startX;
  float startY;

  float finalX;
  float finalY;

  float currentX;
  float currentY;

  //times
  float time;  
  float timeSpeed;


  //path index in relation with the SVG file
  int pathIndex =0;

  int numPoints = 0;

  int currPoint = 0;
  int nextPoint = 0;

  boolean done = false;

  //color and mobility
  int typeMobility;
  color typeColor;
  int alphaColor = 10;

  int pointSize = 1;

  PointPath(int  pi) {
    time = 0;
    currPoint = 0;
    nextPoint  = 1;
    pathIndex = pi;
    timeSpeed = random(0.001, 0.01);
    typeMobility = int(random(1, 4));

    if (typeMobility == 1) {
      typeColor = color(0, 255, 255, alphaColor);
    } else if (typeMobility == 2) {
      typeColor = color(255, 205, 0, alphaColor);
    } else if (typeMobility == 3) {
      typeColor = color(0, 200, 155, alphaColor);
    } else if (typeMobility == 4) {
      typeColor = color(0, 105, 255, alphaColor);
    }

    pointSize = 5;//int(random(6, 10));
  }

  color getTypeColor() {
    return typeColor;
  }

  //set index path of the SVG file
  void setPathIndex(int pi){
    pathIndex = pi;
  }
  
  //get index path of the SVG file
  int getPathIndex() {
    return pathIndex;
  }

  void setNumPoints(int num) {
    numPoints = num;
  }


  void setStart(float sx, float sy) {
    this.startX = sx;
    this.startY = sy;
  }

  void setFinal(float fx, float fy) {
    this.finalX = fx;
    this.finalY = fy;
  }

  void update() {
    currentX =  time*(finalX - startX) + startX;
    currentY =  time*(finalY - startY) + startY;

    if (done == false) {
      time += timeSpeed;

      if (time > 1.0) {
        time = 1.0;
        done = true;
      }
    }
  }


  void reset() {
    time = 0;
    done = false;
    timeSpeed = random(0.001, 0.01);
  }

  boolean isDone() {
    return done;
  }

  void incPath() {
    currPoint++;
    nextPoint++;
  }

  boolean isDonePath() {
    if (currPoint == numPoints - 1) {
      currPoint = 0; //start
      nextPoint = 1; //start + 1

       //reset index of SVG Path

      return true;
    }
    return false;
  }

  int getCurrInc() {
    return currPoint;
  }

  int getNexInt() {
    return nextPoint;
  }

  void setColor() {
    if (typeMobility == 1) {
    }
  }

  void draw() {
    fill(150, 200);
    noStroke();
    ellipse(currentX, currentY, pointSize, pointSize);
  }
}

