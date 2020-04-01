class Polygon{
  PVector[] vertices;
  PVector[] dir;//normalized direction
  int n;
  
  Polygon(float[] x, float[] y){
    n = x.length;
    vertices = new PVector[n];
    for(int i = 0; i < n; i++){
      vertices[i] = new PVector(x[i], y[i]);
    }
  }
  
  void offset(float thickness){
    calcDir();
    int u = 0;
    for(int i = n; i--!=0;){
      float k = thickness/(dir[u].x*dir[i].y - dir[i].x*dir[u].y);
      float x = (dir[u].x - dir[i].x)*k + vertices[i].x;
      float y = (dir[u].y - dir[i].y)*k + vertices[i].y;
      vertices[i] = new PVector(x, y);
      u = i;
    }
  }
  
  void calcDir(){
    int u = n-1;
    dir = new PVector[n];
    for(int i = 0; i < n; i++){
      PVector ndir = PVector.sub(vertices[u], vertices[i]).normalize();
      dir[i] = ndir;
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