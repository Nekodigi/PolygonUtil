PVector lineDist(PVector c, PVector a, PVector b) {//x = distance, y = distance from normal
  PVector ap = PVector.sub(c, a);
  PVector ab = PVector.sub(b, a);
  float l = PVector.dist(a, b);
  PVector n = new PVector(ab.y, -ab.x);
  int sign = 1;
  if(n.dot(c)<0)sign = -1;
  ab.normalize(); // Normalize the line
  float scala = ap.dot(ab);
  ab.mult(scala);
  PVector normalPoint = PVector.add(a, ab);
  if(scala <= 0){
    return new PVector(PVector.dist(c, a), PVector.dist(c, normalPoint));
  }else if(scala >= l){
    return new PVector(PVector.dist(c, b), PVector.dist(c, normalPoint));
  }
  else{
    return new PVector(PVector.dist(c, normalPoint), 0);
  }
}
