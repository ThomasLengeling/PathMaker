/*

 GPS + color
 */
class JSONPath {

  //JSON
  JSONObject json;

  int indexPath;
  int numPoints;
  float time;
  PVector startPos;
  PVector targetPos;
  boolean stopAnim = false;
  
  ArrayList<Box> boxes;
  
  ArrayList<PVector> mPoints;
  
  
  
  JSONPath() {
    startPos =  new PVector();
    targetPos = new PVector();
    time = 0;
    indexPath = 0;
    
    boxes = new ArrayList<Box>();
  }



  void readJSON(String nameFile) {
    mPoints = new ArrayList<PVector>();

    println("loading "+nameFile);

    json = loadJSONObject(nameFile);//"test_32.797.json");

    JSONArray valuesLat = json.getJSONArray("Latitude"); //Latitude
    JSONArray valuesLong = json.getJSONArray("Longitude");

    for (int i = 0; i < valuesLat.size (); i++) {
      float lat =  valuesLat.getFloat(i);
      float log = valuesLong.getFloat(i);

      ScreenPosition position = map.getScreenPosition(new Location(lat, log));
      
      

      mPoints.add(new PVector(position.x, position.y));
      
      Box box = new Box(position.x, position.y);
      box.setDetectionType(lat+","+log+":  "+audiotype[ (int)random(0, 5) ] );
      boxes.add(box);
    }

    println("done loading, points: "+valuesLat.size());

    numPoints = mPoints.size();
    if (numPoints >= 2) {
      startPos = mPoints.get(indexPath);
      targetPos =  mPoints.get(indexPath + 1);
    }
  }
  
  void drawBoxes(){
    for (Box boxs : boxes) {
      boxs.drawBox();
    }
    
  }
  
  void draw() {
    for (PVector points : mPoints) {
      fill(150);
      ellipse(points.x, points.y, 2, 2);
    }
  }

  void drawShape() {

    noFill();
    stroke(180);
    beginShape();
    for (PVector points : mPoints) {
      vertex(points.x, points.y);
    }
    endShape();
  }

  void drawShapeTransition() {
    noFill();
    beginShape();
    for (PVector points : mPoints) {
      vertex(points.x, points.y);
    }
    endShape();
  }

  void createTargetPositions() {
    
  }
  
  void drawInicial(){
    
  }

  void animatePath() {

    float x = (targetPos.x - startPos.x) * time + startPos.x;
    float y = (targetPos.y - startPos.y) * time + startPos.y;

    //update
    float d = PVector.dist(targetPos, startPos);
    if (!stopAnim) {
      time += 2.0/d; //lowe slower
    }
    
    if (time >= 1.0) {
      indexPath++;
      boxes.get(indexPath).activated = true;
      
      if (indexPath < numPoints - 1) {
        startPos = mPoints.get(indexPath);
        targetPos =  mPoints.get(indexPath +1 );
      } else {
        stopAnim = true;
        startPos = targetPos;
      }
      time = 0.0;
    }

    fill(50);
    ellipse(x, y, 5, 5);
  }
}

