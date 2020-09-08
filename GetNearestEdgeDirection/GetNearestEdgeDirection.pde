int pixelS = 1;//pixel size
Polygon pA;

void setup(){
  size(500, 500);
  colorMode(HSB, 360, 100, 100);
  pA = new Polygon(width/2, height/2, height/4, 10);
}

void draw(){
  noStroke();
  for(int i=0; i<width; i+=pixelS){
    for(int j=0; j<height; j+=pixelS){
      PVector result = pA.findNearestEdge(new PVector(i, j));
      float dir = atan2(result.y, result.x);
      fill(map(dir, -PI, PI, 0, 360), 100, 100);
      rect(i, j, pixelS, pixelS);
    }
  }
  noFill();
  stroke(0);
  pA.show();
}
