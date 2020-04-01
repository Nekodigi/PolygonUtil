class Polygon{
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  
  Polygon(ArrayList<PVector> vertices){
    this.vertices = vertices;
  }
  
  Polygon(float r, int res, PVector o){//for demo
    for(int i = 0; i < res; i++){
      float theta = map(i, 0, res, 0, TWO_PI);
      PVector base = PVector.fromAngle(theta).mult(r).add(o);//point on circle
      PVector std = PVector.random2D().mult(r/4);
      vertices.add(base.add(std));
    }
  }
  
  void show(color col){
    beginShape();
    for(PVector v : vertices){
      vertex(v.x, v.y);
      point(v, col);
    }
    endShape(CLOSE);
  }
}