/* 
*  Author: Faisal Hoda
*  Kepler - Tycho Brache Data Plot for Mars Obrbit
*/

import processing.pdf.*;

float center; // Center of drawing
float orbitalDiameter; // radius of Earth's orbit
float orbitalRadius;
float sunRadius = 20;
float earthRadius = 15;

FloatList marsCoords = new FloatList(); // Store mars coordinates

void setup(){
  int canvas_size = displayHeight - 100;
  size(canvas_size,canvas_size);
  center = canvas_size/2; // Center of drawing
  orbitalDiameter = canvas_size/3.5; // radius of Earth's orbit
  orbitalRadius = orbitalDiameter/2;
  
  background(255);
  smooth();
  noLoop();
  beginRecord(PDF, "mars_orbit.pdf"); // Begin writing to pdf file
}


void draw(){
  // Draw Earth's orbital 
  fill(255);
  stroke(0);
  ellipse(center,center,orbitalDiameter,orbitalDiameter); //Earth's Orbital
  
  // Draw the sun
  fill(255,255,0);
  stroke(255,255,0);
  ellipse(center,center,sunRadius,sunRadius); // Sun
  
  plotEarth(47.5, 4.0, 47.5, 90.0, orbitalRadius, center); // 8

  plotEarth(66.5, 22.5, 66.5, 107.0, orbitalRadius, center);  // 1
  
  plotEarth(92.5, 48.0, 92.5, 130.5, orbitalRadius, center); // 9
    
  plotEarth(107.0, 62.5, 107.0, 144.0, orbitalRadius, center); // 2
  plotEarth(141.5, 97.5, 141.5, 177.0, orbitalRadius, center); // 3
  plotEarth(175.5, 132.0, 175.5, 212.0, orbitalRadius, center); // 4
  
  
  plotEarth(214.5, 171.5, 214.5, 253.5, orbitalRadius, center); // 5
  plotEarth(266.5, 225.0, 266.5, 311.0, orbitalRadius, center); // 6
  plotEarth(342.5, 300.5, 342.5, 29.5, orbitalRadius, center); // 7  

// plotEarth(277.0, 235.0, 208.5, 272.5, orbitalRadius, center); // 10
//  plotEarth(308.0, 266.5, 260.5, 335.0, orbitalRadius, center); // 11
//  plotEarth(345.5, 304.0, 273.0, 347.5, orbitalRadius, center); // 12
//  plotEarth(9.5, 327.0, 337.5, 44.5, orbitalRadius, center); // 13
//  plotEarth(60.5, 17.0, 350.5, 56.0, orbitalRadius, center); // 14 

  // Draw Curve connection mars plots
  noFill();
  stroke(0);
  beginShape();
  curveVertex(marsCoords.get(0), marsCoords.get(1));
  int i; 
  for(i=0; i<=marsCoords.size()-2; i+=2){
    curveVertex(marsCoords.get(i), marsCoords.get(i+1));
  }  
  curveVertex(marsCoords.get(0), marsCoords.get(1));
  curveVertex(marsCoords.get(0), marsCoords.get(1));
  endShape();
  
  endRecord(); // Finish writing to PDF file
}

/* Calculates and plots both positions for Earth given a data set */
void plotEarth(float angle1, float angle2, float marsAngle1, float marsAngle2, float radius, float origin){
  // First Earth position
  float x1 = origin + radius*cos(radians(angle1));
  float y1 = origin + radius*sin(radians(angle1+180));
  fill(0,76,153);
  stroke(0,76,153);
  ellipse(x1,y1,earthRadius,earthRadius);
  
  // Second Earth Position
  float x2 = origin + radius*cos(radians(angle2));
  float y2 = origin + radius*sin(radians(angle2+180));
  fill(0,76,153);
  stroke(0,76,153);
  ellipse(x2,y2,earthRadius,earthRadius);
  
  plotMars(origin, x1, y1, x2, y2, angle1, angle2 ,marsAngle1, marsAngle2);
}

/* Calculates and plots Mars Postion based on both earth positions given and Mars angle from Earth Position 2 */
void plotMars(float o, float xE1, float yE1, float xE2, float yE2, float angleE1,float angleE2,float angleM1, float angleM2){
  stroke(0); 
  // Line from Sun to Earth
  line(o, o, xE1, yE1);
  
  // Calulate equation of the line from Sun to Earth
  float slope = (yE1 - o)/(xE1 - o); // slope (m)
  float b = o - (slope*o);           // y-intercept
//  float xIntercept = -b/slope;       // x-intercept
//  line(o,o, xIntercept, 0);
  
  /* Calculate/Triangulate distance on Sun-Earth Line using Known angles and lengths */
  // Get all angles
  float sunAngle = abs(angleE1 - angleE2);
  float earthAngle = abs(180-(angleM2-angleE2));
  float intersectionAngle = abs(180-sunAngle-earthAngle);
  println("Sun Angle: "  + sunAngle + "\nEarth Angle: " + earthAngle +"\nInt Angle: "+ intersectionAngle );
  
  // Get distance from 2nd earth point to line.
  float side = orbitalDiameter;
  
  // Calculate distance on Sun-Earth line for Mars' location
  float distance;
  if((angleE1 > 90 && angleE1 < 360)){
    distance = -(side * sin(radians(earthAngle)))/sin(radians(intersectionAngle));
  }else{
    distance = (side * sin(radians(earthAngle)))/sin(radians(intersectionAngle));
  }

  println("Distance: " + distance);
  
  // Calculate Mars plot position given distance
  float xM = o + distance/sqrt(1+sq(slope)); // x value
  float yM = slope*xM + b;                  // y value
//  float xM = o + distance * cos(radians(sunAngle)); // x value
//  float yM = o + distance * sin(radians(sunAngle)); // y value

  fill(165,0,0);
  stroke(165,0,0);
  ellipse(xM,yM,10,10); // Mars Plot
  
  // Add Coordinates to array for connecting eath position with a curve.
  marsCoords.append(xM); 
  marsCoords.append(yM);

}

