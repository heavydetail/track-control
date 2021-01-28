import controlP5.*;

//Import Shit
import cc.arduino.*;
import processing.serial.*;   
import processing.video.*;

//Define Everything
Serial port;
static final int SERVO_COUNT = 4;
static final int START_POSITION = 0;
static final int END_POSITION = 180;

//Display Properties
static final int W4DISP = 320;
static final int H4DISP = 240;

static final int ARDUINO_COM = 2;
RemoteServo[] servos = new RemoteServo[SERVO_COUNT];
Capture video;
trackThread tracker1, tracker2, tracker3, tracker4;
boolean firstrun1 = true, firstrun2 = true, firstrun3 = true;

// A variable for each color we are searching for.
color trackColor1;
color trackColor2; 
color trackColor3; 
color trackColor4;

//ArrayList for drawingObjects
ArrayList doa;

//UI Elements
ControlP5 cp5;
CheckBox checkbox;

void setup() {
  size(640, 480);
  
  doa = new ArrayList();
  
  //Init Arduino / Servos / Cam
  setupSerial();
  setupServos();
  initCams();     
  initUI(); 
  
  //Start off tracking
  trackColor1 = color(255, 0, 255); //random
  trackColor2 = color(255, 0, 255); //random
  trackColor3 = color(255, 0, 255); //random
  trackColor4 = color(255, 0, 255); //random
  
  //Init & Start Tracker Threads:
  //MODI:
  //  1 ROUNDABOUT
  //  2 BACK AND FORTH
  //  3 OPPOSITE
  //  4 VIBRATE
  
  tracker1 = new trackThread("Blue Tracker", trackColor1, 1, 1000);
  tracker2 = new trackThread("Red Tracker", trackColor2, 2, 1000); //was 600
  tracker3 = new trackThread("Yellow Tracker", trackColor3, 3, 1000);
  tracker4 = new trackThread("Vibro", trackColor4, 4, 250);
  
  tracker1.start();
  tracker2.start();
  tracker3.start();
  tracker4.start();

  smooth();
}

void draw() {
  //Show Video
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  image(video, 0, 0);
  
  drawstuff();
}

void mousePressed() {
  int loc = mouseX + mouseY*video.width;
  
  if (mouseButton == LEFT) {
    //if(firstrun1) tracker1.start();
    
    tracker1._track = video.pixels[loc];
    trackColor1 = tracker1._track;
    
    firstrun1 = false;
  } else if (mouseButton == RIGHT) {
    //if(firstrun3) tracker3.start();
    
    tracker3._track = video.pixels[loc];
    trackColor3 = tracker3._track;
    
    tracker4._track = video.pixels[loc]; //sets color for tracker4 too!
    trackColor4 = tracker4._track;
    
    firstrun3 = false;
  } else {
    //if(firstrun2) tracker2.start();
    tracker2._track = video.pixels[loc];
    trackColor2 = tracker2._track;
    
    firstrun2 = false;
  }
  
  //Reset Servos:
  for (int i=0; i<SERVO_COUNT; i++) {
    servos[i].move(0);
  }
  println("Colors: " + trackColor1 + " " + trackColor2 + " " + trackColor3);
  
  //delay(2500);
}

void drawstuff() {
  for (int i = doa.size()-1; i > 0; i--) { 
    // An ArrayList doesn't know what it is storing,
    // so we have to cast the object coming out.
    drawingObject doa1 = (drawingObject) doa.get(i);

    doa1.drawit();

    if (doa1.finished()) {
      // Items can be deleted with remove().
      doa.remove(i);
    }
  }  
}
