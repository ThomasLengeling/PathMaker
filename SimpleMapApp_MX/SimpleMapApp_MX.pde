/**
 * An application with a basic interactive map. You can zoom and pan the map.
 */

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.providers.OpenStreetMap.*;

UnfoldingMap map;
Location mediaLocation = new Location(42.357778f, -71.061667f);
Location mexCity =  new Location(19.422234, -99.169164);

boolean startRecording = false;
Location prevLoc;
Location currLoc;

ArrayList<Float> Lat;
ArrayList<Float> Log;

int count = 149;

float frameTime;


void setup() {
  size(800, 600, P2D);

  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  map.zoomAndPanTo(mexCity, 15);
  MapUtils.createDefaultEventDispatcher(this, map);

  frameRate(15);

  prevLoc = new Location(0, 0);
  currLoc = new Location(0, 0);

  Lat = new ArrayList<Float>();
  Log = new ArrayList<Float>();
}

void draw() {
  map.draw();

  if (startRecording) {
    prevLoc = currLoc;
    currLoc =  map.getLocation(new ScreenPosition(mouseX, mouseY));
    if (prevLoc.x != currLoc.x && prevLoc.y != currLoc.y) {
      println(currLoc.x, currLoc.y);
      Lat.add(currLoc.x);
      Log.add(currLoc.y);
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

