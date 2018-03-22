class PathManager {

  ArrayList<Path> mPaths;
  float[][] singlePoints;


  PathManager() {
    mPaths = new ArrayList<Path>();
  }

  void addPath(Path path) {
    mPaths.add(path);
  }

  void drawPath() {
    for (Path path : mPaths) {
      path.draw();
    }
  }

  void animatePath(int step) {
    for (Path path : mPaths) {
      path.animateDraw(step);
    }
  }


  float[][] getSinglePoints() {
    return singlePoints;
  }

  void makeSinglePointArray() {
    singlePoints = new float[mPaths.size()][2];

    println(mPaths.size());
    for (int i = 0; i < mPaths.size (); i++) {
      singlePoints[i][0] = map.getScreenPosition( new Location( mPaths.get(i).singlePoint.x, mPaths.get(i).singlePoint.y)).x;
      singlePoints[i][1] = map.getScreenPosition( new Location( mPaths.get(i).singlePoint.x, mPaths.get(i).singlePoint.y)).y;
    }
  }

  int getNumPaths() {
    return mPaths.size();
  }


  String getAudioPath(int index) {
    return mPaths.get(index).soundStr;
  }

  void stopAudio(int index) {
    mPaths.get(index).stopAudio();
  }

  void triggerAudio(int index) {
    mPaths.get(index).triggerAudio();
  }





  void drawAudioReactive(int index) {
    float centerX = singlePoints[index][0];
    float centerY = singlePoints[index][1];
    for (int i = 0; i < mPaths.get (index).mAudio.bufferSize(); i++) {
      // float  waveR = player.right.get(i);
      //float  waveL = player.left.get(i);
      //line( centerX, centerY,
    }
  }
}

