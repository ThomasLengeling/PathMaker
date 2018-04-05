/**
 * An application with a basic interactive map. You can zoom and pan the map.
 */
boolean startRecording = false;
PVector prevLoc;
PVector currLoc;

ArrayList<Float> Lat;
ArrayList<Float> Log;

int count = 149;

float frameTime;

PImage wanxiang;

void setup() {
  size(1920, 1240, P2D);

  wanxiang = loadImage("wanxiang.png");

  frameRate(30);

  prevLoc = new PVector(0, 0);
  currLoc = new PVector(0, 0);

  Lat = new ArrayList<Float>();
  Log = new ArrayList<Float>();
}

void draw() {
  fill(255);
  image(wanxiang, 0, 0);

  if (startRecording) {
    prevLoc = currLoc;
    currLoc =  new PVector(mouseX, mouseY);
    if (prevLoc.x != currLoc.x && prevLoc.y != currLoc.y) {
      println(currLoc.x, currLoc.y);
      Lat.add(currLoc.x);
      Log.add(currLoc.y);
    }

    for (int i = 0; i < Lat.size (); i++) {
      float valLat = Lat.get(i);
      float valLog = Log.get(i);

      fill(255, 0, 0);
      ellipse(valLat, valLog, 5, 5);
    }
  }
  
}

void mousePressed() {
  //startRecording = true;
}

void mouseDragged() {
  //Location loc =  map.getLocation(new ScreenPosition(mouseX, mouseY));
  //println(loc.x, loc.y);
}

void mouseReleased() {
  //println("off");
  //releasePath();
}


void keyPressed() {

  if (key == '1') {
    startRecording = true;
    frameTime = millis();
  }

  if (key == '2') {
    releasePath();
  }
}


void releasePath() {
  float now = millis()- frameTime;
  now /= 1000.0;


  println(now+" "+count);

  startRecording = false;

  JSONObject json = new JSONObject();

  JSONArray valuesLat = new JSONArray();
  for (int i = 0; i < Lat.size (); i++) {
    float val = Lat.get(i);
    valuesLat.setFloat(i, val);
  }

  JSONArray valuesLog = new JSONArray();
  for (int i = 0; i < Log.size (); i++) {
    float val = Log.get(i);
    valuesLog.setFloat(i, val);
  }

  json.setJSONArray("Latitude", valuesLat);
  json.setJSONArray("Longitude", valuesLog);
  json.setFloat("duration", now);
  json.setString("audio", "jingle.mp3");

  saveJSONObject(json, "data/test_"+count+".json");

  Lat = new ArrayList<Float>();
  Log = new ArrayList<Float>();

  println("writing JSON");
  count++;
}

