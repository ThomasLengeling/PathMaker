void drawLinePaths() {
  for (int i = 0; i < pointPaths.length; i++) {
    if (pointPaths[i] != null) {
      beginShape();
      for (int j = 0; j<pointPaths[i].length; j++) {
        vertex(pointPaths[i][j].x, pointPaths[i][j].y);
      }
      endShape();
    }
  }
}


void drawConnections() {
  for (int i = 0; i < paths.length; i++) {
    float sX = paths[i].currentX;
    float sY = paths[i].currentY;

    for (int j = 0; j < paths.length; j++) {
      float fX = paths[j].currentX;
      float fY = paths[j].currentY;

      float dis = dist(sX, sY, fX, fY);

      color typeColor = paths[i].getTypeColor();
      if (dis > 20 && dis < 50) {
        stroke(typeColor);
        line(sX, sY, fX, fY);
      }
    }
  }
}

void updatePoints() {
  for (int i = 0; i < paths.length; i++) {
    translate(0, 0, z);

    paths[i].draw();
    paths[i].update();

    noFill();

    if (paths[i].isDone()) {
      //update new first and last
      paths[i].reset();
      paths[i].incPath();

      //reset path index SVG 
      if (paths[i].isDonePath()) {
        int indexPath = (int)random(0, pointPaths.length - 1);
        paths[i].setPathIndex(indexPath);

        int lengthP = pointPaths[indexPath].length;
        paths[i].setNumPoints(lengthP);

       // println(indexPath+" "+i);
      }

      int curr = paths[i].getCurrInc();
      int next = paths[i].getNexInt();
      int indexSVG =  paths[i].getPathIndex();

      RPoint sp = pointPaths[indexSVG][curr];
      RPoint fp = pointPaths[indexSVG][next];

      paths[i].setStart(sp.x, sp.y);
      paths[i].setFinal(fp.x, fp.y);
    }
  }
}

