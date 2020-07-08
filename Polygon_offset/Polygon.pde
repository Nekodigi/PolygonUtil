class Polygon{
  PVector[] vertices, offsetV;
  ArrayList<PVector> resV;
  PVector[] normal;
  int n;
  
  Polygon(float[] x, float[] y){
    n = x.length;
    vertices = new PVector[n];
    for(int i = 0; i < n; i++){
      vertices[i] = new PVector(x[i], y[i]);
    }
  }
  
  void solveSelfIntersection(float thickness){//we can use for convex hull
    calcNormal();
    //calclate self intersections
    resV = new ArrayList<PVector>();
    for(int i=0; i<offsetV.length; i++){
      PVector A = offsetV[i];
      PVector B = offsetV[(i+1)%offsetV.length];
      resV.add(A);
      for(int j=0; j<offsetV.length; j++){//we might improve this
        PVector C = offsetV[j];
        PVector D = offsetV[(j+1)%offsetV.length];
        PVector p = intersection(A, B, C, D);
        if(p != null){
          //ellipse(p.x*scale, p.y*scale, 10, 10);
          resV.add(p);
        }
      }
    }
    //delete illegal points
    for(int i=0; i<vertices.length; i++){
      PVector A = vertices[i];
      PVector C = vertices[(i+vertices.length-1)%vertices.length];
      for(int j=resV.size()-1; j>=0; j--){
        //if(j != i && j != (i+vertices.length-1)%vertices.length){
          PVector B = resV.get(j);
          float nd = lineDist(B, A, C);//which side of AC?
          //line(A.x*scale, A.y*scale, A.x*scale+n.x*100, A.y*scale+n.y*100);
          nd = isClockwise() ? -nd : nd;
          if(nd > thickness+EPSILON){//println(thickness, nd);
            //ellipse(B.x*scale, B.y*scale, 10, 10);
            resV.remove(j);
          }
        //}
      }
    }
  }
  
  
  //boolean isValidCo(){//check valid. !we can use this for only convex full
  //  boolean result = true;
  //  for(int i=0; i<vertices.length; i++){
  //    PVector A = vertices[i];
  //    for(int j=0; j<vertices.length; j++){ 
  //      if(j != i && j != (i+vertices.length-1)%vertices.length){
  //        PVector B = vertices[j];
  //        PVector n = normal[i];
  //        //line(A.x, A.y, A.x+n.x*100, A.y+n.y*100);
  //        //ellipse(B.x, B.y, 10, 10);
  //        float nd = n.dot(A) - n.dot(B);//which side of AC?
  //        boolean whichSide = nd >= 0;
  //        boolean isValid = isClockwise() ? whichSide : !whichSide;
  //        result = result && isValid;//println(isValid, i, j);
  //      }
  //    }
  //  }
  //  return result;
  //}
  
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
  
  void offset(float thickness, boolean isConvexHull){
    calcNormal();
    if(!isClockwise())thickness = -thickness;
    offsetV = vertices.clone();
    int u = n-1;
    for(int i = 0; i < n; i++){
      offsetV[u] = vertices[u].copy();
      PVector na = normal[u];PVector nb = normal[i];
      PVector bis = PVector.add(na, nb).normalize();
      float l = thickness*sqrt(2) / sqrt(1 + PVector.dot(na, nb));
      offsetV[u].add(PVector.mult(bis, l));
      u = i;
    }
    if(isConvexHull)solveSelfIntersection(thickness);
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
    fill(255, 0, 0, 100);
    beginShape();
    for(PVector v : vertices){
      vertex(v.x*scale, v.y*scale);
    }
    endShape(CLOSE);
    beginShape();
    for(PVector v : resV){
      vertex(v.x*scale, v.y*scale);
    }
    endShape(CLOSE);
  }
}
