float scale = 500;
float thickness = -0.1;

float[] x = {0.1, 0.9, 0.8, 0.9, 0.5, 0.1, 0.2};
float[] y = {0.1, 0.1, 0.5, 0.9, 0.8, 0.9, 0.5};

void setup(){
  size(500, 500);
  Polygon polygon = new Polygon(x, y);
  polygon.show();
  polygon.offset(thickness);
  fill(255, 0, 0, 100);
  polygon.show();
}

void draw(){
  
}