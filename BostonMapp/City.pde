
void loadMexicoCity(int paths) {
  map.panTo(mexicoLocation);
  mPathManager = new PathManager();

  for (int i = 1; i < paths; i++) {
    String fileName = "cdmx/test_"+i+".json";
    mPathManager.addPath(new Path(fileName));
    println("done loading "+fileName);
  }
  
  println("cdmx");
  
}

void loadBoston() {

  map.panTo(mediaLocation);
  mPathManager = new PathManager();

  for (int i = 0; i < 22; i++) {
    String fileName= "";
    if (i <= 9) {
      fileName = "boston/test_0"+i+".json";
    }
    if (i >= 10) {
      fileName = "boston/test_"+i+".json";
    }

    mPathManager.addPath(new Path(fileName));
  }
  
}

