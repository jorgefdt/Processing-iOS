void setup() {
   size(screenWidth, screenHeight);
   background(102);
}

void draw() {
   stroke(255);
   if (mousePressed == true) {
      line(mouseX, mouseY, pmouseX, pmouseY);
   }
}
