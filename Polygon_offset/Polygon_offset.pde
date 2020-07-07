float scale = 500;
float thickness = -0.33;
//example of complex shape
//float[] x = {0.1, 0.9, 0.6, 0.9, 0.5, 0.1, 0.2};
//float[] y = {0.1, 0.1, 0.5, 0.9, 0.7, 0.9, 0.5};
//example of convex hull
float[] x = {0.2, 0.8, 0.9, 0.8, 0.5, 0.2, 0.1};
float[] y = {0.2, 0.1, 0.5, 0.8, 0.9, 0.8, 0.5};
//float[] x = {0.1, 0.1, 0.9, 0.9};
//float[] y = {0.1, 0.9, 0.9, 0.1};
//float[] x = {1.7,2,1.9,1.63,1.44,1.62,1.22,1.16,0.84,0.78,0.38,0.56,0.37,0.1,0,0.3,0.37,0.1,0.38,0.56,0.84,0.78,1.22,1.16,1.44,1.62,1.9,1.63};
//float[] y = {1,1,1.43,1.3,1.55,1.78,1.97,1.68,1.68,1.97,1.78,1.55,1.3,1.43,1,1,0.7,0.57,0.22,0.45,0.32,0.03,0.03,0.32,0.45,0.22,0.57,0.7};

void setup(){
  size(500, 500);
}

void draw(){
  background(255);
  thickness = map(mouseX, 0, width, -0.5, 0.5);
  Polygon polygon = new Polygon(x, y);
  polygon.show();
  //println(polygon.isClockwise());
  polygon.offset(thickness);
  fill(255, 0, 0, 100);
  polygon.show();
  println(polygon.isValidCo());//we can use for only convex hull
}
