Polygon A;
Polygon B;
pBoolean pboolean;

void setup(){
  size(500, 500);
  colorMode(HSB, 360, 100, 100);
  A = new Polygon(width/5, 10, new PVector(width/2, height/2).add(PVector.random2D().mult(width/6)));
  B = new Polygon(width/5, 10, new PVector(width/2, height/2).add(PVector.random2D().mult(width/6)));
  pboolean = new pBoolean(A, B);
  background(200);
  fill(360, 10);
  pboolean.calc();
  //background(0);
  fill(0, 100, 100, 100);
  A.show();
  fill(200, 100, 100, 100);
  B.show();
  fill(360, 100);
  textSize(25);
  pboolean.show();
}

void draw(){
}