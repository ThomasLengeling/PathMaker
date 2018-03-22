String currentAudio;


void intersection() {
  float[][] points  = mPathManager.getSinglePoints();

  for (int  i = 0; i < mPathManager.getNumPaths(); i++) {

    if ( dist(mouseX, mouseY, points[i][0], points[i][1]) < 10 ) {
       fill(255);
       
       ellipse(points[i][0], points[i][1], 15, 15);
      
       //play soung
       //start animation
       currentAudio =  mPathManager.getAudioPath(i);
       mPathManager.triggerAudio(i);

       
      // println(currentAudio);
    }else{
      mPathManager.stopAudio(i);
    }
    
  }
  
}

