float lineDist(PVector c, PVector a, PVector b) {
  PVector ap = PVector.sub(c, a);
  PVector ab = PVector.sub(b, a);
  float l = PVector.dist(a, b);
  ab.normalize(); // Normalize the line
  float scala = ap.dot(ab);
  if(scala <= 0){
    return PVector.dist(c, a);
  }else if(scala >= l){
    return PVector.dist(c, b);
  }
  else{
    ab.mult(scala);
    PVector normalPoint = PVector.add(a, ab);
    return PVector.dist(c, normalPoint);
  }
}