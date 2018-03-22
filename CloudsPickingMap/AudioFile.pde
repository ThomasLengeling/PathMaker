class AudioFile {
  String audioStr;
  String imageStr;

  float duration; //duration of the sound file

  int ext;  // 0 interior or  1 exterior
  int timeOfDay; //day, night

  int dynamic;
  int tone;
  int origin; //object, animal, object

  int index;

  String user;
  String time;

  float lat;
  float lng;

  boolean audioActive = false;
  boolean imgActive = false;

  boolean loadedAudio = false;

  AudioPlayer player;
  PImage      img;

  AudioFile() {
  }

  void loadAudio() {
    if (!loadedAudio) {
      player = minim.loadFile(audioStr);
      img    = loadImage(imageStr);
      
      println("buffer "+player.bufferSize ());
      loadedAudio = true;
    }
  }

  void printInfo() {
    println(audioActive+" audioStr "+audioStr);
    println(imgActive+" imageStr "+imageStr);
    println("lat "+lat);
    println("lng "+lng);
    println("ext "+ext);
    println("timeOfDay "+timeOfDay);
  }


  boolean isAudioLoaded() {
    return loadedAudio;
  }

  void playAudio() {
    player.rewind();
    player.play();
  }

  void setAudioActivation(boolean on) {
    audioActive = on;
  }

  void setImgActivation(boolean on) {
    imgActive = on;
  }
}

