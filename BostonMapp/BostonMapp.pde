import megamu.mesh.*;

/**
 * Displays the subway lines of Boston, read from a GeoJSON file.
 * 
 * This example shows how to load data features and create markers manually in order to map specific properties; in this
 * case the colors according to the MBTA schema.
 */
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.OpenStreetMap.*;
import de.fhpotsdam.unfolding.providers.MapBox.*;
import java.util.List;

import ddf.minim.analysis.*;
import ddf.minim.*;




//Media Lab
//42.360173, -71.087573
//Boston
//42.357778f, -71.061667f
Location mediaLocation = new Location(42.360173, -71.087573); 
Location bostonLocation = new Location(42.357778f, -71.061667f);
Location mexicoLocation = new Location(19.422234, -99.169164);

UnfoldingMap map;

boolean drawMap = true;

PathManager  mPathManager;

//Audio
Minim       minim;
AudioPlayer mAudioPlayer;
FFT         fft;

int indexSound = 0;


PGraphics pg;


int numPaths = 249;


void setup() {
  size(1920, 1080, OPENGL);
  smooth(8);

  pg = createGraphics(width, height);
  minim = new Minim(this);

  //satellite  Microsoft.AerialProvider()
  //WaterColor
  //StamenMapProvider.TonerBackground())

  //new OpenStreetMapProvider()
  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());//StamenMapProvider.TonerBackground()); //WaterColor());
  map.zoomToLevel(16); //11
  //14 cdmx
  map.panTo(mexicoLocation);
  map.setZoomRange(9, 18); // prevent zooming too far out
  map.setPanningRestriction(mexicoLocation, 50);

  MapUtils.createDefaultEventDispatcher(this, map);

  loadMexicoCity(numPaths);

  //loadBoston();

  //generateDelaunay();
  ///generateVoronoi();
}

void draw() {
  noStroke();
  if (drawMap) {
    map.draw();
    fill(0, 230);
    rect(0, 0, width, height);
  } else {
    background(0);
  }

  //mPathManager.drawPath();

  pg.beginDraw();
  mPathManager.animatePath(10);

  if (drawDelaunay) {
    drawDelaunay();
  }

  if (drawVoronoi) {
    drawVoronoi();
  }

  pg.endDraw();
  
}

void mousePressed() {
  //intersection();
}


void keyPressed() {
  if (key == '1') {
    map.panTo(mediaLocation);
  }

  if (key == '2') {
    map.panTo(bostonLocation);
  }

  if (key == '3') {
    map.panTo(mexicoLocation);
  }

  if (key == 'm') {
    drawMap = !drawMap;
  }

  if (key == 'z') {
    generateDelaunay();
  }

  if (key == 'x') {
    generateVoronoi();
  }

  if (key == 'd') {
    drawDelaunay = !drawDelaunay;
  }

  if (key == 'v') {
    drawVoronoi = !drawVoronoi;
  }
}

