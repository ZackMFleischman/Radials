import controlP5.*;
ControlP5 cp5;

float C1x; 
float C1y;
float C2x; 
float C2y;

Slider C1xSlider;
Slider C1ySlider;
Slider C2xSlider;
Slider C2ySlider;
  

// PARAMS + STATE
int numRads = 15;
Slider numRadialsSlider;
int maxRads = 75;

CheckBox showControlLinesCheckbox;

float radialOffset = 0;
float radVel = 0.001;
Slider radVelSlider;

float curveScale = 1.0;
float curveScaleVelocity = 0.0003;
float curveScaleMaxDelta = 0.15;

float cpRange = 350;

float cpVel = 0.7;
float C1xVelocity = 1;
float C1yVelocity = 1;
float C2xVelocity = 1;
float C2yVelocity = 1;

Slider cpVelSlider;

///////////

PFont font;
int fontSize = 24;


Curve baseCurve;
PVector worldOffset = new PVector(250,250);

class Curve { 
  float ypos, speed;
  PVector A1, A2;
  PVector C1, C2;
  
  Curve (float a1x, float a1y, float c1x, float c1y, float c2x, float c2y, float a2x, float a2y) {  
    this.A1 = new PVector(a1x, a1y); 
    this.C1 = new PVector(c1x, c1y); 
    this.C2 = new PVector(c2x, c2y); 
    this.A2 = new PVector(a2x, a2y); 
  }
  
  void render(color c, float rotation, boolean drawControls) {
     noFill();
     PVector rA1 = new PVector(this.A1.x, this.A1.y);
     PVector rC1 = new PVector(this.C1.x, this.C1.y);
     PVector rC2 = new PVector(this.C2.x, this.C2.y);
     PVector rA2 = new PVector(this.A2.x, this.A2.y);
     
     rA1 = rA1.rotate(rotation).mult(curveScale).add(worldOffset);
     rC1 = rC1.rotate(rotation).mult(curveScale).add(worldOffset);
     rC2 = rC2.rotate(rotation).mult(curveScale).add(worldOffset);
     rA2 = rA2.rotate(rotation).mult(curveScale).add(worldOffset);
     
    if (drawControls) {
      stroke(255, 102, 0);
      line(rA1.x, rA1.y, rC1.x, rC1.y);
      line(rC2.x, rC2.y, rA2.x, rA2.y);
    }
    
  
    stroke(c);
    bezier(rA1.x, rA1.y, rC1.x, rC1.y, rC2.x, rC2.y, rA2.x, rA2.y);
  } 
} 

void setup() {
  size(500, 700);
  font = createFont("Arial", fontSize ,true);
  baseCurve = new Curve(0, 0, -150, -250, 100, 50, 0, -200);
  
  cp5 = new ControlP5(this);
  
  addControlPointSliders(570);
  
}

void addControlPointSliders(float y) {
  C1xSlider = addCPSlider("C1x", 20, y, -150);
  C1ySlider = addCPSlider("C1y", 20, y+30, -250);
  C2xSlider = addCPSlider("C2x", 20, y+60, 100);
  C2ySlider = addCPSlider("C2y", 20, y+90, 50);
  
  cpVelSlider = cp5
    .addSlider("cpVel")
    .setPosition(250, y)
    .setSize(200, 20)
    .setRange(0, 2)
    .setValue(cpVel)
    .setColorCaptionLabel(color(200));
    
  radVelSlider = cp5
    .addSlider("radVel")
    .setPosition(250, y+30)
    .setSize(200, 20)
    .setRange(-0.025, 0.025)
    .setValue(radVel)
    .setColorCaptionLabel(color(200));
    
  numRadialsSlider = cp5
    .addSlider("numRads")
    .setPosition(250, y+60)
    .setSize(200, 20)
    .setRange(1, maxRads)
    .setValue(numRads)
    .setNumberOfTickMarks(maxRads)
    .setColorCaptionLabel(color(200));
    
  showControlLinesCheckbox = cp5.addCheckBox("ShowControlLinesCheckbox")
                .setPosition(250, y+90)
                .setSize(20, 20)
                .addItem("Show Control Lines", 0);
                
}

Slider addCPSlider(String name, float posX, float posY, float startValue) {
  return cp5.addSlider(name)
     .setPosition(posX, posY)
     .setSize(200, 20)
     .setRange(-cpRange, cpRange)
     .setValue(startValue)
     .setColorCaptionLabel(color(200));
}

void draw() {
  background(0);
  
  updateState();
  render();
}

void updateState() {
   updateControlPoints();
  
   updateBaseCurve();
   
   radialOffset += radVel % (float)(2*Math.PI);
   updateCurveScale();
}

void updateControlPoints() {
  if (C1x >= cpRange || C1x <= -cpRange) C1xVelocity = -C1xVelocity;
  if (C1y >= cpRange || C1y <= -cpRange) C1yVelocity = -C1yVelocity;
  if (C2x >= cpRange || C2x <= -cpRange) C2xVelocity = -C2xVelocity;
  if (C2y >= cpRange || C2y <= -cpRange) C2yVelocity = -C2yVelocity;

   C1xSlider.setValue(C1x + C1xVelocity*cpVel);
   C1ySlider.setValue(C1y + C1yVelocity*cpVel);
   C2xSlider.setValue(C2x + C2xVelocity*cpVel);
   C2ySlider.setValue(C2y + C2yVelocity*cpVel);
}

void updateBaseCurve() {
  baseCurve = new Curve(0, 0, C1x, C1y, C2x, C2y, 0, -200);
}

void updateCurveScale() {
  if (curveScaleVelocity > 0) {
     if (curveScale >= 1.0 + curveScaleMaxDelta) {
       curveScaleVelocity = -curveScaleVelocity;
     }
   } else {
     if (curveScale <= 1.0 - curveScaleMaxDelta) {
       curveScaleVelocity = -curveScaleVelocity;
     }
   }
   
   curveScale += curveScaleVelocity;
}

void render() {
  renderContainingCircle();
  
  for (int i=0; i<round(numRads); ++i) {
    float rotation = (float)(2*Math.PI/round(numRads))*i;
    baseCurve.render(color(255), rotation+radialOffset, showControlLinesCheckbox.getState(0));
  }
}

void renderContainingCircle() {
  circle(250, 250, 400);
}
