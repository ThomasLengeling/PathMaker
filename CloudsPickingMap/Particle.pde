Vec3D centeringForce = new Vec3D();

class Particle {
  Vec3D position, velocity, force;
  Vec3D localOffset;

  float speed = 24;
  float spread = 150;

  int soundEnable;
  int indexId;

  color col;
  color coltri;
  
  float alpha;

  boolean selected = false;

  float distanceToFocalPlane;

  AudioFile audioFile;

  Particle(int i) {
    velocity = new Vec3D();
    force = new Vec3D();
    position = new Vec3D();

    localOffset = Vec3D.randomVector();

    indexId = i;

    col = color(255, 255, 255);
    alpha = 0;
  }

  void reset() {
    velocity = new Vec3D();
    force = new Vec3D();
    position = new Vec3D();

    localOffset = Vec3D.randomVector();

    speed = 24;
    spread = 150;

    col = color(255, 255, 255);
    alpha = 0;

    int j = (int)random(0, 4);
    if (j==0) {
      coltri = color(#05CDE5);
    }
    if (j==1) {
      coltri = color(#FFB803);
    }
    if (j==2) {
      coltri = color(#FF035B);
    }
    if (j==3) {
      coltri = color(#3D3E3E);
    }
  }

  void addSpeed(float value) {
    speed = value;
  }

  void addSpread(float value) {
    spread = value;
  }

  void addAudioFile(AudioFile aF) {
    audioFile = aF;
  }

  void drawImage() {
    image(audioFile.img, width - 200, 0, 200, 200);
  }

  void resetPosition() {
    position = Vec3D.randomVector();
    position.scaleSelf(random(rebirthRadius));
  }


  void drawArc(PGraphics g) {

    g.strokeWeight(distanceToFocalPlane*8);
    g.point(position.x, position.y, position.z);

    g.strokeWeight(3);
    if (audioFile.isAudioLoaded() && selected) {
      g.stroke(0, 150, 220, alpha*1.2);
      g.noFill();
      g.beginShape();
      int buffer = audioFile.player.bufferSize ();
      for (int i = 0; i < buffer; i+=20) {

        float centerX = position.x +  cos( (i / (float)buffer)*PI*2)  * (distanceToFocalPlane * 7 +  audioFile.player.left.get(i)*30);
        float centerY = position.y +  sin( (i / (float)buffer)*PI*2)  * (distanceToFocalPlane * 7 +  audioFile.player.right.get(i)*30);

        g.vertex(centerX, centerY, position.z);

        //audioFile.player.left.get(i), 
        //audioFile.player.left.get(i+1)
      }
      g.endShape(CLOSE);
    }
  }

  void drawPG(PGraphics pg) {
    pg.strokeWeight(distanceToFocalPlane*9);
    pg.point(position.x, position.y, position.z);
  }

  void drawBuffer(PGraphics buffer) {
    color idColor = getColor(indexId);
    buffer.stroke(idColor);
    updateFocalPlane();
    drawPG(buffer);
  }

  void draw(PGraphics g) {
    if (!selected) {

      g.stroke(col, alpha);
    } else {
      g.stroke(0, 200, 255, alpha*1.2);
    } 

    drawArc(g);
    drawPG(g);
  }

  void drawInside(PGraphics g) {
    if (!selected) {
      if (audioFile.timeOfDay == 1) {
        col = color(red(col), red(col), 0);
        g.stroke(col, alpha);
      } else {
        col = color(red(col), 0, red(col));
        g.stroke(col, alpha);
      }
    } else {
      g.stroke(0, 200, 255, alpha*1.2);
    } 

    drawArc(g);
    drawPG(g);
  }


  void drawDay(PGraphics g) {
    if (!selected) {
      if (audioFile.ext == 1) {
        col = color(red(col), red(col), 0, alpha);
        g.stroke(col);
      } else {
        col = color( red(col), 0, red(col), alpha);
        g.stroke(col);
      }
    } else {
      g.stroke(0, 200, 255, alpha*1.2);
    } 

    drawArc(g);
    drawPG(g);
  }

  void drawMode(PGraphics pg, int drawMode)
  {
    switch(drawMode) {
    case 1:
      this.draw(pg);
      break;
    case 2:
      this.drawInside(pg);
      break;
    case 3:
      this.drawDay(pg);
      break;
    }
  }





  void updateFocalPlane() {
    distanceToFocalPlane  = focalPlane.getDistanceToPoint(position);
    distanceToFocalPlane *= 1 / dofRatio;
    distanceToFocalPlane  = constrain(distanceToFocalPlane, 1, 15);
    alpha = constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 5, 230);
  }

  void drawPoint() {
    strokeWeight(distanceToFocalPlane*8);
    stroke(255, constrain(255 / (distanceToFocalPlane * distanceToFocalPlane), 10, 200));
    point(position.x, position.y, position.z);
  }


  //Toggle
  void playAudio() {
    if (selected == false) {
      audioFile.loadAudio();
      audioFile.playAudio();
    }
  }

  void changeColor() {

    if (selected == true && audioFile.player.isPlaying()) {
      audioFile.player.rewind();
      audioFile.player.pause();
    }

    selected = !selected;
  }

  void checkAuddioPlaying() {
    if (audioFile.isAudioLoaded()) {
      if (!audioFile.player.isPlaying() && selected == true) {
        println("finish");
        audioFile.player.pause();
        audioFile.player.rewind();

        selected = false;
      }
    }
  }



  void applyFlockingForce() {
    force.addSelf(

    noise(
    position.x / neighborhood + globalOffset.x + localOffset.x * independence, 
    position.y / neighborhood, 
    position.z / neighborhood)
      - .5, 
    noise(
    position.x / neighborhood, 
    position.y / neighborhood + globalOffset.y  + localOffset.y * independence, 
    position.z / neighborhood)
      - .5, 
    noise(
    position.x / neighborhood, 
    position.y / neighborhood, 
    position.z / neighborhood + globalOffset.z + localOffset.z * independence)
      - .5);
  }

  void applyViscosityForce() {
    force.addSelf(velocity.scale(-viscosity));
  }

  void applyCenteringForce(Vec3D avg) {
    centeringForce.set(position);
    centeringForce.subSelf(avg);
    float distanceToCenter = centeringForce.magnitude();
    centeringForce.normalize();
    centeringForce.scaleSelf(-distanceToCenter / (spread * spread));
    force.addSelf(centeringForce);
  }

  void update(Vec3D avg) {
    force.clear();
    applyFlockingForce();
    applyViscosityForce();
    applyCenteringForce(avg);
    velocity.addSelf(force); // mass = 1
    position.addSelf(velocity.scale(speed));
  }
}

