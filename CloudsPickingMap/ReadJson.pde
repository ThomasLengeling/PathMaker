
ArrayList<AudioFile> musicFiles;

int timesAudio = 10;

//load this
boolean loadAudioDynamic = true;


void resetParticles(ParticleManager pm, int mode) {
  int idCounter = 0;

  for (int i = 0; i < pm.getNumParticles (); i++) {
    Particle p = (Particle)pm.particles.get(i);
    p.reset();

    if (mode == 2) {
      if (p.audioFile.timeOfDay == 1) {
        p.addSpeed(60);
      } else {
        p.addSpeed(10);
      }
    }

    if (mode == 3) {
      if (p.audioFile.ext == 1) {
        p.addSpread(200);
      } else {
        p.addSpread(20);
      }
    }
  }
}

void readAudioJSON(ParticleManager pm, int mode) {
  musicFiles = new ArrayList<AudioFile>();

  JSONArray json = loadJSONArray("data_audio.json");

  println("num items "+json.size());

  int idCounter = 0;
  for (int i = 0; i < json.size (); i++) {
    JSONObject item = json.getJSONObject(i); 
    String audioStr = item.getString("audio");
    String imageStr = item.getString("img");

    int audioActive = item.getInt("audioActive");
    int imgActive   = item.getInt("imgActive");

    float lat  = item.getFloat("lat");
    float lng  = item.getFloat("lng");

    int when  = item.getInt("when");
    int where  = item.getInt("where");

    if (audioActive == 1 && imgActive == 1) {
      println("loaded: "+i);

      for (int j = 0; j < timesAudio; j++) {

        AudioFile audioFile = new AudioFile();
        audioFile.audioStr = audioStr;
        audioFile.imageStr = imageStr;

        audioFile.lat = lat;
        audioFile.lng = lng;

        audioFile.timeOfDay = when;
        audioFile.ext = where;


        audioFile.index = idCounter;
        audioFile.audioActive = audioActive == 1 ? true : false;
        audioFile.imgActive   = imgActive == 1 ? true : false;

        if (!loadAudioDynamic) {
          println(idCounter);
          audioFile.loadAudio();
        }

        //audioFile.printInfo();

        musicFiles.add(audioFile);

        Particle p = new Particle(idCounter);
        p.addAudioFile(audioFile);

        if (mode == 2) {
          if (audioFile.timeOfDay == 1) {
            p.addSpeed(70);
            p.addSpread(150);
          } else {
            p.addSpread(120);
            p.addSpeed(15);
          }
        }

        if (mode == 3) {
          if (audioFile.ext == 1) {
            p.addSpread(200);
            p.addSpeed(40);
          } else {
            p.addSpread(50);
            p.addSpeed(20);
          }
        }



        pm.addParticle(p);
        idCounter++;
      }
    } else {
      println("not loaded: "+i);
    }
  }

  println("num :"+pm.getNumParticles());
}

void readTestAudioJSON() {
  musicFiles = new ArrayList<AudioFile>();

  JSONArray json = loadJSONArray("data.json");

  println("num items "+json.size());
  for (int i = 0; i < json.size (); i++) {
    JSONObject item = json.getJSONObject(i); 

    AudioFile audioFile = new AudioFile();
    String strAudio = item.getString("audio");
    String strImg = item.getString("img");

    String day = item.getString("when");
    String ext = item.getString("where");

    float lat = item.getJSONObject("location").getFloat("lat");
    float lng = item.getJSONObject("location").getFloat("lng");

    //audio Check
    boolean loadedAudio = true;
    try {
      AudioPlayer player = minim.loadFile(strAudio);
      loadedAudio = true;
    }
    catch(Exception e) {
      //println(e);
      loadedAudio = false;
    }

    if (loadedAudio) {
      println("Audio loaded: "+i);
    } else {
      println("Audio not loaded: "+i);
    }


    //audio Check
    boolean loadedImg = true;
    try {
      PImage testImg = loadImage(strImg);
      loadedImg = true;
    }
    catch(Exception e) {
      //println(e);
      loadedImg = false;
    }

    if (loadedImg) {
      println("Img loaded: "+i);
    } else {
      println("Img not loaded: "+i);
    }


    audioFile.audioStr = strAudio;
    audioFile.imageStr = strImg;

    audioFile.index = i;
    audioFile.audioActive = loadedAudio;
    audioFile.imgActive = loadedImg;

    audioFile.timeOfDay  = day.equals("day") ? 1 : 0;
    audioFile.ext        = ext.equals("ext") ? 1 : 0;
    audioFile.lat        = lat;
    audioFile.lng        = lng;

    musicFiles.add(audioFile);
    //println(item.getString("_id"));
  }

  writeJSONAudio();
}

void writeJSONAudio() {
  JSONArray jsonArray = new JSONArray();

  for (int i = 0; i < musicFiles.size (); i++) {
    JSONObject audio = new JSONObject();

    AudioFile audioFile = (AudioFile)musicFiles.get(i);
    audio.setString("audio", audioFile.audioStr);
    audio.setString("img", audioFile.imageStr);

    audio.setInt("audioActive", audioFile.audioActive ? 1 : 0);
    audio.setInt("imgActive", audioFile.imgActive ? 1 : 0);

    audio.setFloat("lat", audioFile.lat);
    audio.setFloat("lng", audioFile.lng);

    audio.setInt("when", audioFile.timeOfDay);
    audio.setInt("where", audioFile.ext);

    jsonArray.setJSONObject(i, audio);
  }

  saveJSONArray(jsonArray, "data/data_audio.json");
}
