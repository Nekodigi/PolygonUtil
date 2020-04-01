//based on this site https://github.com/Habrador/Computational-geometry

float r;

Polygon polyA;
Polygon polyB;
PolygonClippingController polygonClipping;

void setup(){
  size(500, 500);
  polyA = new Polygon(width/5, 10, new PVector(width/2, height/2).add(PVector.random2D().mult(width/6)));
  polyB = new Polygon(width/5, 10, new PVector(width/2, height/2).add(PVector.random2D().mult(width/6)));
  polygonClipping = new PolygonClippingController(polyA, polyB);
  noFill();
  polygonClipping.show();
}

void draw(){
  
}