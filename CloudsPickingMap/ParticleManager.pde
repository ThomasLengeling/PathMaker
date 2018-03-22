class ParticleManager {
  Vector<Particle> particles;

  ParticleManager() {
    particles = new Vector<Particle>();
  }

  void createParticles(int num) {
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(i));
    }

    println(particles.size());
  }


  void addParticle(Particle particle) {
    particles.add(particle);
  }

  //toggle
  void toggleParticle(int index) {
    particles.get(index).playAudio();
    particles.get(index).changeColor();
  }


  void drawImage(int index) {
    particles.get(index).drawImage();
  }



  Vec3D getAvgfPos() {
    Vec3D avg =  new Vec3D();

    for (int i = 0; i < particles.size (); i++) {
      Particle cur = ((Particle) particles.get(i));
      avg.addSelf(cur.position);
    }

    return avg;
  }

  void drawPoints(PGraphics pg, Vec3D avg) {
    for (int i = 0; i < particles.size (); i++) {
      Particle cur = ((Particle) particles.get(i));

      if (!paused) {
        cur.update(avg);
      }

      cur.checkAuddioPlaying();

      cur.updateFocalPlane();

      cur.drawMode(pg, mDrawMode);
    }
  }

  void drawLines(PGraphics pg, Vec3D avg) {
    for (int i = 0; i < particles.size (); i++) {
      Particle curI = ((Particle) particles.get(i));

      if (!paused) {
        curI.update(avg);
      }

      curI.checkAuddioPlaying();

      curI.updateFocalPlane();

      for (int j = i + 1; j < particles.size (); j++) {

        Particle curJ = ((Particle) particles.get(j));
        
        float dis = dist(curI.position.x, curI.position.y, curI.position.z, curJ.position.x, curJ.position.y, curJ.position.z);
        if ( dis > 60 && dis < 200) {

          for (int k = j + 1; k < particles.size (); k++) {
            Particle curK = ((Particle) particles.get(k));
            
            float dis2 = dist(curK.position.x, curK.position.y, curK.position.z, curJ.position.x, curJ.position.y, curJ.position.z);
            if (dis2 > 50 && dis2 < 200) {
         
              strokeWeight(1);
              fill(curK.col, 5);
              stroke(200, 10);

              beginShape(TRIANGLES);
              vertex(curI.position.x, curI.position.y, curI.position.z);
              vertex(curJ.position.x, curJ.position.y, curJ.position.z);
              vertex(curK.position.x, curK.position.y, curK.position.z);
              endShape();
            }
          }
        }
      }

      //draw

      curI.drawMode(pg, mDrawMode);
    }
  }


  void drawBuffer(PGraphics pg) {
    for (int i = 0; i < particles.size (); i++) {
      Particle cur = ((Particle) particles.get(i));
      cur.drawBuffer(pg);
    }
  }


  int getNumParticles() {
    return particles.size();
  }
}

