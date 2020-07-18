ArrayList<PVector> ps = new ArrayList<PVector>();
boolean debug = true;

void setup(){
  fullScreen();
  
  strokeJoin(ROUND);
}

void draw(){
  background(255);
  strokeWeight(20);
  noFill();
  beginShape();//show polygon
  for(PVector p : ps){
    vertex(p.x, p.y);
  }
  endShape(CLOSE);
  float sumS1 = 0;//Calculate area with Gauss theorem A=(x, 0)
  for(int i = 0; i < ps.size(); i++){
    PVector pa = ps.get(i);
    PVector pb = ps.get((i+1)%ps.size());
    float l = PVector.dist(pa, pb);
    PVector mid = PVector.add(pa, pb).div(2);
    PVector normal = PVector.sub(pb, pa).rotate(HALF_PI).normalize();
    sumS1 += mid.x*normal.x*l;
  }
  float sumS2 = 0;
  if(ps.size() >= 3){//Calculate area with Heron's formula
    PVector p1 = ps.get(0);//Usage are limited, but sector division for simplicity
    for(int i = 1; i < ps.size()-1; i++){
      PVector p2 = ps.get(i);
      PVector p3 = ps.get(i+1);
      float a = PVector.dist(p1, p2);
      float b = PVector.dist(p2, p3);
      float c = PVector.dist(p3, p1);
      float s = (a + b + c) / 2;
      sumS2 += sqrt(s*(s-a)*(s-b)*(s-c));
      if(debug){
        strokeWeight(1);
        triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
      }
    }
  }
  fill(0);
  textSize(100);
  text("Gauss theorem:"+sumS1, 0, 100);
  if(debug) text("Heron's formula:"+sumS2, 0, 200);
}

void mousePressed(){
  ps.add(new PVector(mouseX, mouseY));
}

void keyPressed(){
  if(key == 'r'){
    ps = new ArrayList<PVector>();
  }
  if(key == 'd'){
    debug = !debug;
  }
}