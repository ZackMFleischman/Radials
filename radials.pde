PFont font;
int fontSize = 24;


float gameStepTime = 150;
float currentStepTime = 0;
float lastStepTime = 0;

Curve baseCurve;

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
  
  void render(color c, boolean drawControls) {
     noFill();
     
    if (drawControls)
      renderControlLines();
    
  
    stroke(c);
    bezier(this.A1.x, this.A1.y, this.C1.x, this.C1.y, this.C2.x, this.C2.y, this.A2.x, this.A2.y);
  } 
  
  void renderControlLines () {
    stroke(255, 102, 0);
    line(this.A1.x, this.A1.y, this.C1.x, this.C1.y);
    line(this.C2.x, this.C2.y, this.A2.x, this.A2.y);
  }
} 

void setup() {
  size(500, 500);
  font = createFont("Arial", fontSize ,true);
  
  baseCurve = new Curve(340, 80, 40, 40, 360, 360, 60, 320);
   
  
}

void draw() {
  background(0);
  render();
}

void render() {
  baseCurve.render(color(255), true);
}
