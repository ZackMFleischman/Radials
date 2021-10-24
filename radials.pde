PFont font;
int fontSize = 24;


float gameStepTime = 150;
float currentStepTime = 0;
float lastStepTime = 0;

Curve baseCurve;

PVector worldOffset = new PVector(200,200);

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
     PVector rA1 = this.A1.rotate(rotation);
     PVector rC1 = this.C1.rotate(rotation);
     PVector rC2 = this.C2.rotate(rotation);
     PVector rA2 = this.A2.rotate(rotation);
     
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
  
  //baseCurve = new Curve(340, 80, 40, 40, 360, 360, 60, 320);
  baseCurve = new Curve(250, 250, 40, 40, 360, 360, 250, 50);
   
  
}

void draw() {
  background(0);
  render();
}

void render() {
  
  renderContainingCircle();
  
  //baseCurve.render(color(255), true);
  for (int i=0; i<10; ++i) {
    float rotation = (float)(2*Math.PI/10.0);
    baseCurve.render(color(255), rotation, true);
  }
}

void renderContainingCircle() {
  circle(250, 250, 400);
}
