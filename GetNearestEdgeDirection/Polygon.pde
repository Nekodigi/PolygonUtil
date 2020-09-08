class Polygon{
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  
  Polygon(float x, float y, float mr, int n){
    float Btheta = random(TWO_PI);
    for(int i = 0; i < n; i++){
      float theta = map(i, 0, n, 0, TWO_PI)+Btheta;
      float r = random(mr);
      vertices.add(new PVector(x+cos(theta)*r, y+sin(theta)*r));
    }
  }
  
  PVector findNearestEdge(PVector p){//get nearest edge direction(x,y) and distance(z)
    float bestD = Float.POSITIVE_INFINITY;
    float bestDS = Float.POSITIVE_INFINITY;//support when determin distance
    PVector bestE = null;
    for(int i=0; i<vertices.size(); i++){
      PVector A = vertices.get(i);
      PVector B = vertices.get((i+1)%vertices.size());
      PVector dist = lineDist(p, A, B);
      if(dist.x <= bestD){
        if(abs(dist.x-bestD) == 0)if(dist.y <= bestDS){continue;}
        bestD = dist.x;
        bestDS = dist.y;
        bestE = PVector.sub(B, A);
      }
    }
    return bestE;
}
  
  Polygon(ArrayList<PVector> vertices){
    this.vertices = vertices;
  }
  
  void show(){
    beginShape();
    for(PVector vertice : vertices){
      vertex(vertice.x, vertice.y);
    }
    endShape(CLOSE);
  }
}
