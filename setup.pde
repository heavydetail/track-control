void initUI() {
  cp5 = new ControlP5(this);                
  cp5.addToggle("toggle1", true, 200, 10, 20, 20);
  cp5.addToggle("toggle2", true, 250, 10, 20, 20);
  cp5.addToggle("toggle3", true, 300, 10, 20, 20);
  cp5.addToggle("toggle4", true, 350, 10, 20, 20);
}

void controlEvent(ControlEvent theEvent) {
  /* events triggered by controllers are automatically forwarded to 
   the controlEvent method. by checking the name of a controller one can 
   distinguish which of the controllers has been changed.
   */

  /* check if the event is from a controller otherwise you'll get an error
   when clicking other interface elements like Radiobutton that don't support
   the controller() methods
   */

  if (theEvent.isController()) { 

    print("control event from : "+theEvent.controller().name());
    println(", value : "+theEvent.controller().value());

    if (theEvent.controller().name()=="toggle1") {
      if (theEvent.controller().value()==1) { tracker1 = new trackThread("Blue Tracker", trackColor1, 1, 500); tracker1.start(); }
      else                                  tracker1.quit();
    }
    
    if (theEvent.controller().name()=="toggle2") {
      if (theEvent.controller().value()==1) { tracker2 = new trackThread("Red Tracker", trackColor2, 2, 600); tracker2.start(); }
      else                                  tracker2.quit();
    }
    
    if (theEvent.controller().name()=="toggle3") {
      if (theEvent.controller().value()==1) { tracker3 = new trackThread("Yellow Tracker", trackColor3, 3, 400); tracker3.start(); }
      else                                  tracker3.quit();
    }
    
    if (theEvent.controller().name()=="toggle4") {
      if (theEvent.controller().value()==1) { tracker4 = new trackThread("Vibro", trackColor4, 4, 250); tracker4.start(); }
      else                                  tracker4.quit();
    }

//    if (theEvent.controller().name()=="slider1") {
//      colors[3] = color(theEvent.controller().value(), 0, 0);
//    }
//
//    if (theEvent.controller().name()=="slider2") {
//      colors[4] = color(0, theEvent.controller().value(), 0);
//    }
  }
}

void setupServos() {
  for (int i=0; i<SERVO_COUNT; i++) {
    servos[i] = new RemoteServo(i);
    servos[i].setPort(port);
  }
}

void setupSerial() {
  println("Getting serial list, may take a while...");
  String[] serialPorts = Serial.list();
  println(serialPorts);

  // warning hardcoded port number in list
  String   myPortName = serialPorts[ARDUINO_COM];

  port = new Serial(this, myPortName, 115200); 
  println("Opened serial port " + myPortName);
}

void initCams() {
  //Init Cam:
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    video = new Capture(this, cameras[3]);
    video.start();
  }
}

