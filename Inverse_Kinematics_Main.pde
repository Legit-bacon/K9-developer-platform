//Now with 100% more GIT!!
import peasy.*;

PeasyCam cam;

import processing.serial.*;
Serial myPort;

int servo1, servo2, servo3;
byte[] servo_bytes1, servo_bytes2, servo_bytes3;

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
Configuration config;
ControlDevice gpad;

float forwardsSpeed, turnSpeed;

PVector upArmPos, midArmPos, lowArmPos;
PVector halfPos, halfVec;
public float targetX, targetY, targetZ, a1, a2, a3;
public float leg0TargetX, leg0TargetY, leg0TargetZ;
public float leg1TargetX, leg1TargetY, leg1TargetZ;
public float leg2TargetX, leg2TargetY, leg2TargetZ;
public float leg3TargetX, leg3TargetY, leg3TargetZ;

IK Leg0 = new IK(0, 115, 0, -60);      //FIX Z ISSUE!!!
IK Leg1 = new IK(1, -115, 0, -60);      //FIX Z ISSUE!!!
IK Leg2 = new IK(2, -115, 0, 60);      //FIX Z ISSUE!!!
IK Leg3 = new IK(3, 115, 0, 60);      //FIX Z ISSUE!!!


Gait Gait0 = new Gait(0, -60, 115);
Gait Gait1 = new Gait(1, -60, -115);
Gait Gait2 = new Gait(2, 60, -115);
Gait Gait3 = new Gait(3, 60, 115);

float leg0Zoffset = 0;
float leg1Zoffset = 15;
float leg2Zoffset = 10;
float leg3Zoffset = -5;

void setup(){
  size(1280, 750, P3D);
  frameRate(100);
  
  control = ControlIO.getInstance(this);
  // Find a device that matches the configuration file
  gpad = control.getMatchedDevice("gamepad_doggo");
  if (gpad == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  
  cam = new PeasyCam(this, 400);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(800);
  smooth();


  
  lowArmPos = new PVector(0, 0, 0);
  midArmPos = new PVector(0, 0, 0);
  upArmPos = new PVector(0, 0, 0);
  halfPos = new PVector(0, 0, 0);
  halfVec = new PVector(150, 0, 0);
  
  myPort = new Serial(this, "COM3", 115200, 'N', 8, 2.0);
   myPort.write(0xAA);
   myPort.write(0x0C); 
   myPort.write(0x04);  
   myPort.write(0x00); 
   myPort.write(0x70); 
   myPort.write(0x2E);
  
}

void draw(){
  forwardsSpeed = map(gpad.getSlider("YPOS").getValue(), 1, -1, -0.01, 0.01);
  turnSpeed = map(gpad.getSlider("XPOS").getValue(), 1, -1, 60, -60);
  
  Gait0.update();
  Gait1.update();
  Gait2.update();
  Gait3.update();
  background(0);
  lights();

  Leg0.update();
  Leg1.update();
  Leg2.update();
  Leg3.update();
}