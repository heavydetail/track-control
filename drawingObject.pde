class drawingObject {
 int x1=0, y1=0; //line coords
 color tracked;
 boolean finished = false;
 
 drawingObject(int _x, int _y, color _tracked) {
   x1 = _x;
   y1 = _y;
   tracked = _tracked;
 }
  
  void drawit(){
    fill(tracked);
    strokeWeight(2.0);
    stroke(0);
    ellipse(x1, y1, 16, 16);
    line(W4DISP, H4DISP, x1, y1);
    finished = true;
  }
  
  boolean finished() {
   if(finished == true)
    return true;
   else 
    return false; 
  }
}
