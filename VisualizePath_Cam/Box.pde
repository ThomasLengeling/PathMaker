class Box {
  float x = 0; 
  float y = 0;

  String detection = "";

  boolean activated = false;

  Box(float x, float y) {
    this.x = x + random(-3, 3);
    this.y = y + random(-2, 2);
  }

  void setDetectionType(String str) {
    detection = str;
  }


  void drawBox() {
    if (activated) {
      noStroke();
      fill(200, 150);
      rect(x, y, 170, 20);

      fill(50);
      text(detection, x + 2, y + 10);
    }
  }
  
}

