/* 
 *  Author: Faisal Hoda
 *  Kepler planetary motion - Tycho Brache Data Plot for Mars Obrbit
 */

import processing.pdf.*;

float centerX; // Center of drawing
float centerY;
float orbitalDiameter; // radius of Earth's orbit
float orbitalRadius;
float sunRadius = 20;
float earthRadius = 15;
int text_distance = 10;

float[][] data = {
                  {1, 66.5, 22.5, 66.5, 107.0},
                  {2, 107.0, 62.5, 107.0, 144.0},
                  {3, 141.5, 97.5, 141.5, 177.0},
                  {4, 175.5, 132.0, 175.5, 212.0},
                  {5, 214.5, 171.5, 214.5, 253.5},
                  {6, 266.5, 225.0, 266.5, 311.0},
                  {7, 342.5, 300.5, 342.5, 29.5},
                  {8, 47.5, 4.0, 47.5, 90.0001},
                  {9, 92.5, 48.0, 92.5, 130.5},
                  {10, 277.0, 235.0, 208.5, 272.5},
                  {11, 308.0, 266.5, 260.5, 335.0},
                  {12, 345.5, 304.0, 273.0, 347.5},
                  {13, 9.5, 327.0, 337.5, 44.5},
                  {14, 60.5, 17.0, 350.5, 56.0}
                 };
                 
String[][] dates = {
                    {"11/28/1580","10/26/1582"}, 
                    {"1/7/1583","11/24/1584"},
                    {"2/10/1585","12/29/1586"},
                    {"3/16/1587","1/31/1589"},
                    {"4/24/1589","3/12/1591"},
                    {"6/18/1591","5/5/1593"},
                    {"9/5/1593","7/24/1595"},
                    {"11/10/1595","9/27/1597"},
                    {"12/24/1597","11/11/1599"},
                    {"6/29/1589","5/16/1591"},
                    {"8/1/1591","6/18/1593"},
                    {"9/9/1591","7/27/1593"},
                    {"10/3/1593","8/20/1595"},
                    {"11/23/1593","10/10/1595"}
                  };              
                  
int[] curveOrder = {8,1,9,2,3,4,5,10,6,11,12,7,13,13,14};

FloatList marsCoords = new FloatList(); // Store mars coordinates

void setup() {
  // int canvas_size = displayHeight - 100;
  size(displayWidth-100, displayHeight-100);
  centerX = displayWidth/2; 
  centerY = displayHeight/2; // Center of drawing
  orbitalDiameter = displayHeight/2; // radius of Earth's orbit
  orbitalRadius = orbitalDiameter/2;
  background(255);
  smooth();
  noLoop();
  beginRecord(PDF, "mars_orbit.pdf"); // Begin writing to pdf file
}


void draw() {
  // Draw Earth's orbital 
  fill(255);
  stroke(0);
  ellipse(centerX, centerY, orbitalDiameter, orbitalDiameter); //Earth's Orbital

  plotEarth();

  // Draw the sun
  fill(255, 255, 0);
  stroke(255, 255, 0);
  ellipse(centerX, centerY, sunRadius, sunRadius); // Sun
  
  printData();
  
//  drawCurve();

  endRecord(); // Finish writing to PDF file
}

/* Calculates and plots both positions for Earth given a data set */
void plotEarth() {
  int i;
  float angle1, angle2, marsAngle1, marsAngle2;
  int plotNumber;
  
  for(i=0; i<data.length; i++){
    plotNumber = int(data[i][0]);
    angle1 = data[i][1];
    angle2 = data[i][2];
    marsAngle1 = data[i][3];
    marsAngle2 = data[i][4];
    
    // First Earth position
    float x1 = centerX + orbitalRadius*cos(radians(angle1));
    float y1 = centerY + orbitalRadius*sin(radians(angle1+180));
    fill(0, 76, 153);
    stroke(0, 76, 153);
    ellipse(x1, y1, earthRadius, earthRadius);
  
    // Display First Earth Point number from Kepler's data
    printPlotNumber(plotNumber, x1, y1, "earth1");

  
    // Second Earth Position
    float x2 = centerX + orbitalRadius*cos(radians(angle2));
    float y2 = centerY + orbitalRadius*sin(radians(angle2+180));
    fill(0, 76, 153);
    stroke(0, 76, 153);
    ellipse(x2, y2, earthRadius, earthRadius);
      
    // Display Second Earth Point number from Kepler's data
    printPlotNumber(plotNumber, x2, y2, "earth2");

  
    println("Eart "+plotNumber+".1 : " + x1 + "," + y1 + "\n" + "Earth "+plotNumber+".2: " + x2 + "," + y2);
    plotMars(x1, y1, x2, y2, angle1, angle2, marsAngle1, marsAngle2, plotNumber);    
  }
}


void drawCurve(){
  // Draw Curve connecting mars plots
  noFill();
  stroke(0);
  beginShape();
  
  int curveX = curveOrder[0]+(curveOrder[0]-1)-1;
  int curveY = curveOrder[0]+(curveOrder[0]-1);
  int curveEndX = curveX;
  int curveEndY = curveY;
  curveVertex(marsCoords.get(curveX), marsCoords.get(curveY));
  int i; 
  for (i=1; i<=curveOrder.length; i++) {
    curveX = curveOrder[i]+(curveOrder[i]-1)-1;
    curveY = curveOrder[i]+(curveOrder[i]-1);
    curveVertex(marsCoords.get(curveOrder[i]+1), marsCoords.get(curveOrder[i]+2));
  }  
  curveVertex(marsCoords.get(curveEndX), marsCoords.get(curveEndY));
  curveVertex(marsCoords.get(curveEndX), marsCoords.get(curveEndY));

  endShape();
}

void printPlotNumber(int plot,float x, float y, String planet){
  if(planet=="earth1"){
    if (x>centerX && y<centerY) {
        text(plot+".1", x+text_distance, y);
      } else if (x<centerX && y<centerY) {
        text(plot+".1", x-text_distance-20, y);
      } else if (x<centerX && y>centerY) {
        text(plot+".1", x-text_distance-25, y+text_distance);
      } else {
        text(plot+".1", x+text_distance, y+text_distance);
      } 
  }else if(planet=="earth2"){
    if (x>centerX && y<centerY) {
        text(plot+".2", x+text_distance, y);
      } else if (x<centerX && y<centerY) {
        text(plot+".2", x-text_distance-20, y);
      } else if (x<centerX && y>centerY) {
        text(plot+".2", x-text_distance-25, y+text_distance);
      } else {
        text(plot+".2", x+text_distance, y+text_distance);
      } 
  }  else {
       if (x>centerX && y<centerY) {
          text(plot, x+text_distance, y-text_distance);
       } else if (x<centerX && y<centerY) {
           text(plot, x-text_distance, y-text_distance);
       } else if (x<centerX && y>centerY) {
          text(plot, x-text_distance-10, y+text_distance);
       } else {
          text(plot, x+text_distance, y+text_distance);
       }
  }
}

void printData(){
  fill(0);
  stroke(0);
  int i;
  int dataX = 5;
  int dataY = 5;

  for(i=0; i<data.length; i++){
    dataY += 30;
    String dataString = int(data[i][0]) + " -\t " + dates[i][0] + "\t " + data[i][1] + "\t " + data[i][3] + "\n" +
                                       "\t \t \t " + dates[i][1] + "\t " + data[i][2] + "\t " + data[i][4]; 
    text(dataString, dataX, dataY);
  }
}


/* Calculates and plots Mars Postion based on both earth positions given and Mars angle from Earth Position 2 */
void plotMars(float xE1, float yE1, float xE2, float yE2, float angleE1, float angleE2, float angleM1, float angleM2, int marsPlotNumber) {

  stroke(0); 
  // Line from Sun to Earth1
  line(centerX, centerY, xE1, yE1);

  //  Get any point on the line of mars angle 1 to determine slope of mars angle 1
  float x1_slope = xE1 + 100*cos(radians(angleM1)); 
  float y1_slope = yE1 + 100*sin(radians(angleM1+180));

  //Calculate slope of the line using points calculated above
  float slope1 = (yE1 - y1_slope)/(xE1 - x1_slope); // slope (m)
  float b1 = y1_slope - (slope1*x1_slope);          // y-intercept

  // Get any point on the line of mars angle 2 to determine slope of mars angle 2
  float x2_slope = xE2 + 100*cos(radians(angleM2)); 
  float y2_slope = yE2 + 100*sin(radians(angleM2+180));

  //Calculate slope of the line using points calculated above
  float slope2 = (yE2 - y2_slope)/(xE2 - x2_slope); // slope (m)
  float b2 = y2_slope - (slope2*x2_slope);          // y-intercept

  // Calculate mars coordinates
  float xM = (b2 - b1)/(slope1 - slope2);
  float yM = slope1*xM + b1;

  println("Mars "+marsPlotNumber+": "+xM + "," + yM);

  fill(165, 0, 0);
  stroke(165, 0, 0);
  ellipse(xM, yM, 10, 10); // Mars Plot

  // Display Mars Point number from Kepler's data
  printPlotNumber(marsPlotNumber, xM, yM, "mars");


  // Add Coordinates to array for connecting eath position with a curve.
  marsCoords.append(xM); 
  marsCoords.append(yM);
}

