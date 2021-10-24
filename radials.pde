// PARAMS + STATE
int numRadials = 30;
boolean showControlPoints = false;

float radialOffset = 0;
float radialOffsetVelocity = 0.005;

float curveScale = 1.0;
float curveScaleVelocity = 0.0005;
float curveScaleMin = 0.4;

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
}

void draw() {
  background(0);
  
  updateState();
  render();
}

void updateState() {
   radialOffset += radialOffsetVelocity % (float)(2*Math.PI);
   updateCurveScale();
}

void updateCurveScale() {
  if (curveScaleVelocity > 0) {
     if (curveScale >= 1.0) {
       curveScaleVelocity = -curveScaleVelocity;
     }
   } else {
     if (curveScale <= curveScaleMin) {
       curveScaleVelocity = -curveScaleVelocity;
     }
   }
   
   curveScale += curveScaleVelocity;
}

void render() {
  renderContainingCircle();
  
  for (int i=0; i<numRadials; ++i) {
    float rotation = (float)(2*Math.PI/numRadials)*i;
    baseCurve.render(color(255), rotation+radialOffset, showControlPoints);
  }
}

void renderContainingCircle() {
  circle(250, 250, 400);
}
