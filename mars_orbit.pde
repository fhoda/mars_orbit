/* Author: Faisal Hoda
*  Kepler - Tycho Brache Data Plot for Mars Obrbit
*/

String legend = "White: Earth Obrit /n Red: Mars Orbit";  
float center = 500; // Center of drawing
float orbitalDiameter = 200; // radius of Earth's orbit
float orbitalRadius = orbitalDiameter/2;
float sunRadius = 20;

void setup(){
  size(1000,1000);
  background(0,0,0);
//  frameRate(1);
//  noLoop();
}


void draw(){
//  ellipseMode(CENTER);
  // Draw Earth's orbial 
  fill(0);
  stroke(255);
  ellipse(center,center,orbitalDiameter,orbitalDiameter); //Earth's Orbital
  
  // Draw the sun
  fill(255,255,0);
  stroke(255,255,0);
  ellipse(center,center,sunRadius,sunRadius); // Sun
  
  plotEarth(66.5, 22.5, 66.5, 107.0, orbitalRadius, center);  // 1
  plotEarth(107.0, 62.5, 107.0, 144.0, orbitalRadius, center); // 2
  plotEarth(141.5, 97.5, 141.5, 177.0, orbitalRadius, center); // 3
  plotEarth(175.5, 132.0, 175.5, 212.0, orbitalRadius, center); // 4
  plotEarth(214.5, 171.5, 214.5, 253.5, orbitalRadius, center); // 5
  plotEarth(266.5, 225.0, 266.5, 311.0, orbitalRadius, center); // 6
  plotEarth(342.5, 300.5, 342.5, 29.5, orbitalRadius, center); // 7
  plotEarth(47.5, 4.0, 47.5, 90.0, orbitalRadius, center); // 8
  plotEarth(92.5, 48.0, 92.5, 130.5, orbitalRadius, center); // 9
//  plotEarth(277.0, 235.0, 208.5, 272.5, orbitalRadius, center); // 10
//  plotEarth(308.0, 266.5, 260.5, 335.0, orbitalRadius, center); // 11
//  plotEarth(345.5, 304.0, 273.0, 247.5, orbitalRadius, center); // 12
//  plotEarth(9.5, 327.0, 337.5, 44.5, orbitalRadius, center); // 13
//  plotEarth(60.5, 17.0, 350.5, 56.0, orbitalRadius, center); // 14 
}


void plotEarth(float angle1, float angle2, float marsAngle1, float marsAngle2, float radius, float origin){
  
  float x1 = origin + radius*cos(radians(angle1));
  float y1 = origin + radius*sin(radians(angle1+180));
  fill(0,76,153);
  stroke(0,76,153);
  ellipse(x1,y1,15,15);
  
  
  float x2 = origin + radius*cos(radians(angle2));
  float y2 = origin + radius*sin(radians(angle2+180));
  fill(0,76,153);
  stroke(0,76,153);
  ellipse(x2,y2,15,15);
  
  plotMars(origin, x1, y1, x2, y2, angle1, angle2 ,marsAngle1, marsAngle2);
}

void plotMars(float o, float xE1, float yE1, float xE2, float yE2, float angleE1,float angleE2,float angleM1, float angleM2){
  stroke(255); 
  // Line from Sun to Earth
  line(o, o, xE1, yE1);
  
  // Calulate equation of the line from Sun through Earth to x-axis
  float slope = (yE1 - o)/(xE1 - o); // slope (m)
  float b = o - (slope*o);           // b
//  float xIntercept = -b/slope;       // x-intercept
//  line(o,o, xIntercept, 0);
  
  /* Calculate/Triangulate distnace on Sun-Earth Line using Known angles lengths */
  // Get all angles
  float sunAngle = angleE1 - angleE2;
  float earthAngle = 180-angleM2;
  float intersectionAngle = 180-sunAngle-earthAngle;
  println(sunAngle + "\n" + earthAngle +"\n"+ intersectionAngle );
  
  // Get distance from 2nd earth point to line.
  float side = orbitalDiameter;
  
  // Calculate distance on line for Mars' location
  float distance;
  if(angleE1 > 90 && angleE1 < 270){
    distance = -(side * sin(radians(earthAngle)))/sin(radians(intersectionAngle));
  }else{
    distance = (side * sin(radians(earthAngle)))/sin(radians(intersectionAngle));
  }

  println(distance);
  
  // Calculate Mars plot position given distance
  float xM = o + distance/sqrt(1+sq(slope)); // x value
  float yM = slope*xM + b;                  // y value
//  float xM = o + distance * cos(radians(sunAngle)); // x value
//  float yM = o + distance * sin(radians(sunAngle));                  // y value

  fill(165,0,0);
  stroke(165,0,0);
  ellipse(xM,yM,10,10); // Mars Plot
}

