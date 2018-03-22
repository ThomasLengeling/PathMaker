class Path {

  ArrayList<PVector> mPoints;

  //JSON
  JSONObject json;
  float duration;

  PVector singlePoint;
  String soundStr;

  color currentColor;
  color activateColor;

  AudioSample mAudio;

  int animateIndex = 0;

  Path(String nameFile) {

    currentColor  = color(255, 0, 0, 150);
    activateColor = color(0, 255, 255);

    mPoints = new ArrayList<PVector>();
    
    println("loading "+nameFile);

    json = loadJSONObject(nameFile);//"test_32.797.json");

    JSONArray valuesLat = json.getJSONArray("Latitude"); //Latitude
    JSONArray valuesLong = json.getJSONArray("Longitude");

    for (int i = 0; i < valuesLat.size (); i++) {
      float lat =  valuesLat.getFloat(i);
      float log = valuesLong.getFloat(i);

      if (i == 0) {
        singlePoint = new PVector(lat, log);
      }

      mPoints.add(new PVector(lat, log));
    }
    
    println("done loading, points: "+valuesLat.size());


    duration = json.getFloat("duration");
    soundStr = json.getString("audio");


    mAudio = minim.loadSample(soundStr, 512 );

    //println("Duration "+duration);
    //println("Sound "+soundStr);
  }

  void triggerAudio() {
    mAudio.trigger();
  }

  void stopAudio() {
    mAudio.stop();
  }

  String getAudioStr() {
    return soundStr;
  }

  void animateDraw(int step) {

    strokeWeight(2);

    if (mPoints.size() >=2 ) {
      noFill();
      stroke(currentColor);
      beginShape();
      for (int i = 0; i < animateIndex; i++) {
        ScreenPosition sc = map.getScreenPosition( new Location( mPoints.get(i).x, mPoints.get(i).y ));


        vertex(sc.x, sc.y);
      }
      endShape();

      if (frameCount % step == 0) { 
        if (animateIndex < mPoints.size()) {
          animateIndex++;
        }
      }
    }
  }
/*
  void animateSingleDraw() {

    ScreenPosition sc = map.getScreenPosition( new Location( mPoints.get(i).x, mPoints.get(i).y ));
    ScreenPosition sc = map.getScreenPosition( new Location( mPoints.get(i + 1).x, mPoints.get(i + 1).y ));

    if (frameCount % step == 0) { 
      if (animateIndex < mPoints.size()) {
        animateIndex++;
      }
    }
    
  }
  */

  void draw() {
    strokeWeight(2);

    if (mPoints.size() >=2 ) {
      noFill();
      stroke(currentColor);
      beginShape();
      for (int i = 0; i < mPoints.size () - 1; i++) {
        ScreenPosition sc = map.getScreenPosition( new Location( mPoints.get(i).x, mPoints.get(i).y ));
        vertex(sc.x, sc.y);
      }
      endShape();
    } else if ( mPoints.size() == 1) {
      fill(currentColor);
      ScreenPosition sc = map.getScreenPosition( new Location( mPoints.get(0).x, mPoints.get(0).y ));
      ellipse(sc.x, sc.y, 3, 3);
    }
  }
}

