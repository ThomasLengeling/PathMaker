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

String pathType = "normal_";

ArrayList<JSONPath> mPath;

int numPaths = 1;


PGraphics pg;

String audiotype[] = {"car horn", "children playing", "trafic", "people talking", "noise", "machine work" };

void setup() {
  size(1280, 720, P2D);

  map = new UnfoldingMap(this, new EsriProvider.WorldGrayCanvas() );
  map.zoomAndPanTo(mediaLocation, 16);
  MapUtils.createDefaultEventDispatcher(this, map);

  frameRate(15);
  textSize(11);

  prevLoc = new Location(0, 0);
  currLoc = new Location(0, 0);

  Lat = new ArrayList<Float>();
  Log = new ArrayList<Float>();

  mPath = new ArrayList<JSONPath>();

  for (int i = 0; i < numPaths; i++) {
    String path = pathType+""+i+".json";
    JSONPath jsonpath = new JSONPath();
    jsonpath.readJSON(path);
    mPath.add(jsonpath);
  }

  pg = createGraphics(width, height);
  
  randomSeed(0);
}

void draw() {


  map.draw();

  for (JSONPath path : mPath) {
    path.draw();
    path.drawShape();
  }

  for (JSONPath path : mPath) {
    path.drawBoxes();
    path.animatePath();
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

