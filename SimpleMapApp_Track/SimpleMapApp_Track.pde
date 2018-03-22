/**
 * An application with a basic interactive map. You can zoom and pan the map.
 */

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.providers.OpenStreetMap.*;


UnfoldingMap map;
Location mediaLocation = new Location(42.36035700000001, -71.087264);

boolean startRecording = false;
Location prevLoc;
Location currLoc;

ArrayList<Float> Lat;
ArrayList<Float> Log;

float frameTime;

String pathType = "normal";
int counter = 0;

void setup() {
  size(1280, 720, P2D);
  
  //  ThunderforestProvider.Transport()
  
  //EsriProvider.WorldGrayCanvas()
  // WorldTopoMap 
  
  
  map = new UnfoldingMap(this, new EsriProvider.WorldGrayCanvas() );//OpenMapSurferProvider.Grayscale() );//.TonerLite());
  map.zoomAndPanTo(mediaLocation, 16);
  MapUtils.createDefaultEventDispatcher(this, map);

  frameRate(15);

  prevLoc = new Location(0, 0);
  currLoc = new Location(0, 0);

  Lat = new ArrayList<Float>();
  Log = new ArrayList<Float>();
}

void draw() {
  map.draw();

  for (int i = 0; i < Lat.size (); i++) {
    float val = Lat.get(i);
    float vla = Log.get(i);
    
    ScreenPosition position = map.getScreenPosition(new Location(val, vla));
   
    
    ellipse(position.x, position.y, 5, 5);
    
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
    currLoc =  map.getLocation(new ScreenPosition(mouseX, mouseY));
    Lat.add(currLoc.x);
    Log.add(currLoc.y);
  }

  if (key == '2') {
    releasePath();
  }
}


void releasePath() {

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

  saveJSONObject(json, "data/"+pathType+"_"+counter+".json");

  Lat = new ArrayList<Float>();
  Log = new ArrayList<Float>();

  println("writing JSON");
  counter++;
}

