class Polygon{
  PVector[] vertices;
  PVector[] normal;
  int n;
  
  Polygon(float[] x, float[] y){
    n = x.length;
    vertices = new PVector[n];
    for(int i = 0; i < n; i++){
      vertices[i] = new PVector(x[i], y[i]);
    }
  }
  
  void offset(float thickness){
    calcNormal();
    int u = n-1;
    for(int i = 0; i < n; i++){
      PVector na = normal[u];PVector nb = normal[i];
      PVector bis = PVector.add(na, nb).normalize();
      float l = thickness*sqrt(2) / sqrt(1 + PVector.dot(na, nb));
      vertices[u].add(PVector.mult(bis, l));
      u = i;
    }
  }
  
  void calcNormal(){
    int u = n-1;
    normal = new PVector[n];
    for(int i = 0; i < n; i++){
      PVector ndir = PVector.sub(vertices[i], vertices[u]).normalize();
      normal[i] = new PVector(ndir.y, -ndir.x);
      u = i;
    }
  }
  
  void show(){
    beginShape();
    for(PVector v : vertices){
      vertex(v.x*scale, v.y*scale);
    }
    endShape(CLOSE);
  }
}