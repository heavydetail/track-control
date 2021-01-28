class RemoteServo {
  int servoIndex;
  int position = 0;
  Serial port;

  public RemoteServo(int servoIndex) {
    this.servoIndex  = servoIndex;
  }

  public int getPosition() {
    return position;
  }

  public void move(float position) {
    int newPosition = int(max(position, min(position, 180), 0));
    
    if (newPosition != this.position) {
      // build RemoteServo command
      String command = "p" + servoIndex + "m" + position + "g";
      // println(command);
      port.write(command);
      this.position = newPosition;
    }
  }

  public void setPort(Serial port) {
    this.port = port;
  }
}


