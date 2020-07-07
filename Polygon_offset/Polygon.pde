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
  
  boolean isValidCo(){//check valid. !we can use this for only convex full
    boolean result = true;
    for(int i=0; i<vertices.length; i++){
      PVector vertex = vertices[i];
      PVector A = vertex.copy();
      for(int j=0; j<vertices.length; j++){ 
        if(j != i && j != (i+vertices.length-1)%vertices.length){
          PVector target = vertices[j];
          PVector B = target.copy();
          PVector n = normal[i];
          //line(A.x, A.y, A.x+n.x*100, A.y+n.y*100);
          //ellipse(B.x, B.y, 10, 10);
          float nd = n.dot(A) - n.dot(B);//which side of AC?
          boolean whichSide = nd >= 0;
          boolean isValid = isClockwise() ? whichSide : !whichSide;
          result = result && isValid;//println(isValid, i, j);
        }
      }
    }
    return result;
  }
  
  boolean isClockwise(){
    float sum = 0;
    int u = vertices.length-1;
    for(int i = 0; i < vertices.length; i++){
      PVector v = vertices[u];
      PVector v2 = vertices[i];
      sum += (v.x*v2.y - v2.x*v.y);
      u = i;
    }
    if(sum > 0) return true;
    else return false;
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
