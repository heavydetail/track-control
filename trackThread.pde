class trackThread extends Thread {
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String id;                 // Thread name
  int count;                 // counter
  int _mode;                 // Moving Mode
  
  color _track;              // Color to Track
  boolean foundit = false;
  float grad = 1;

  trackThread (String name, color track, int mode, int time) {
    wait = time;
    running = false;
    id = name;
    count = 0;
    _track = track;
    _mode = mode;
  }

  void start () {
    running = true;
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    super.start();
  }


  // We must implement run, this gets triggered by start()
  void run () {
    //while (running && count < 10) {
    while (running) {

      count++;


      // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
      float worldRecord = 500; 

      // XY coordinate of closest color
      int closestX = 0;
      int closestY = 0;

      // Begin loop to walk through every pixel
      for (int x = 0; x < video.width; x ++ ) {
        for (int y = 0; y < video.height; y ++ ) {
          int loc = x + y*video.width;
          // What is current color
          color currentColor = video.pixels[loc];
          float r1 = red(currentColor);
          float g1 = green(currentColor);
          float b1 = blue(currentColor);
          float r2 = red(_track);
          float g2 = green(_track);
          float b2 = blue(_track);

          // Using euclidean distance to compare colors
          float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

          // If current color is more similar to tracked color than
          // closest color, save current location and current difference
          if (d < worldRecord) {
            worldRecord = d;
            closestX = x;
            closestY = y;
          }
        }
      }

      foundit = false;
      // We only consider the color found if its color distance is less than 10. 
      // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
      if (worldRecord < 2) { 
//        // Draw a circle at the tracked pixel
//        fill(_track);
//        strokeWeight(4.0); //AUSLAGERN WENN GEHT!?!?
//        stroke(0);
//        ellipse(closestX, closestY, 16, 16);
//        line(320, 240, closestX, closestY);
        
        doa.add(new drawingObject(closestX, closestY, _track));
        
        foundit = true;
      }
      println(id + ": " + foundit);

      //Calculate quadrant:
      float xc =0, yc=0;
      xc = closestX - W4DISP;
      yc = closestY - H4DISP;
      
      
      
      println("Dist: X" + xc + " Y" + yc);
      float grad = degrees(atan(yc/xc));
      if(xc < 0)
        grad+=180;
      else if(yc < 0)
        grad+=360;
      
//      if(grad < 0)
//        grad = grad + 360; //For converting -90° to +90° to 0 - 360°
      
      float distance = 500;
      println("Degree: " + grad);
      
      if (foundit == true)
      {
        //Scale Force:
        
        switch(_mode) {
          case 1: //ROUND MOVE
          if (grad <= 90) {
            //Servo 0
            //distance = dist(closestX, closestY, 160, 160);
            //println("!!! " + distance);
            servos[2].move(180);
            servos[1].move(0);
            servos[0].move(0); 
            servos[3].move(0);
            //println("Point reached.");
          }
          if (grad <= 180 && grad > 90) {
            //Servo 1
            //distance = dist(closestX, closestY, 480, 160); //Coords Right???
            servos[1].move(180);
            servos[2].move(0);
            servos[3].move(0);
            servos[0].move(0);
          }
          if (grad > 180 && grad <= 240) {
            //Servo 2
            //distance = dist(closestX, closestY, 160, 480);
            servos[0].move(180);
            servos[3].move(0);
            servos[1].move(0);
            servos[2].move(0);
          }
          if (grad > 240) {
            //Servo 3
            //distance = dist(closestX, closestY, 480, 480);
            servos[3].move(180);
            servos[2].move(0);
            servos[1].move(0);
            servos[0].move(0);
          }
            break;
          case 2: //2 BACK AND FORTH
          if (grad > 180) {
            //Servo 0
            distance = dist(closestX, closestY, 160, 160);
            //println("!!! " + distance);
            servos[2].move(180);
            servos[3].move(180);
            servos[0].move(0);
            servos[1].move(0);
          }
          if (grad <= 180) {
            //Servo 1
            distance = dist(closestX, closestY, 480, 160); //Coords Right???
            //println("### " + distance);
            servos[0].move(180);
            servos[1].move(180);
            servos[2].move(0);
            servos[3].move(0);
          }
          break;
          
          case 3: //OPPOSITE MOVE
            if (grad <= 45 || grad > 315) {
            //Servo 0
            //distance = dist(closestX, closestY, 160, 160);
            //println("!!! " + distance);
            servos[2].move(180);
            servos[1].move(0);
            servos[0].move(0); 
            servos[3].move(0);
            //println("Point reached.");
          }
          if (grad <= 315 && grad > 225) {
            //Servo 1
            //distance = dist(closestX, closestY, 480, 160); //Coords Right???
            servos[3].move(180);
            servos[2].move(0);
            servos[1].move(0);
            servos[0].move(0);
          }
          if (grad <= 225 && grad > 135) {
            //Servo 2
            //distance = dist(closestX, closestY, 160, 480);
            servos[0].move(180);
            servos[3].move(0);
            servos[1].move(0);
            servos[2].move(0);
          }
          if (grad <= 135 && grad > 45) {
            //Servo 3
            //distance = dist(closestX, closestY, 480, 480);
            servos[1].move(180);
            servos[2].move(0);
            servos[3].move(0);
            servos[0].move(0);
          }
            break;
          
          case 4: //VIBRATE
            servos[0].move(180);
            servos[1].move(180);
            servos[2].move(180);
            servos[3].move(180);
            try { 
        sleep((long)(20));
      }
      catch (Exception e) {
      }
            
            servos[0].move(0);
            servos[1].move(0);
            servos[2].move(0);
            servos[3].move(0);
            try {
        sleep((long)(20));
      }
      catch (Exception e) {
      }
            break;
        }
      } 
      else
      {
        for (int i=0; i<SERVO_COUNT; i++) {
          servos[i].move(0);
        }
      }

      // Ok, let's wait for however long we should wait
      try {
        sleep((long)(wait));
      }
      catch (Exception e) {
      }
    }
    System.out.println(id + " thread is done!");  // The thread is done when we get to the end of run()
  }

  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // In case the thread is waiting. . .
    interrupt();
  }

  int getCount() {
    return count;
  }
}

