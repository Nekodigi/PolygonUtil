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

PVector intersection(PVector p1s, PVector p1e, PVector p2s, PVector p2e) {
  float x1 = p1s.x;float y1 = p1s.y;
  float x2 = p1e.x;float y2 = p1e.y;
  float x3 = p2s.x;float y3 = p2s.y;
  float x4 = p2e.x;float y4 = p2e.y;
  float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  if (den == 0) {
    return null;
  }
  
  float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
  float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;
  if (t > 0 && t < 1 && u > 0) {
    PVector pt = new PVector();
    pt.x = x1 + t * (x2 - x1);
    pt.y = y1 + t * (y2 - y1);
    return pt;
  } else {
    return null;
  }
}
