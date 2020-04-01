PVector intersection(PVector s1, PVector e1, PVector s2, PVector e2) {
  float x1 = s1.x;
  float y1 = s1.y;
  float x2 = e1.x;
  float y2 = e1.y;
  float x3 = s2.x;
  float y3 = s2.y;
  float x4 = e2.x;
  float y4 = e2.y;
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

boolean isInPolygon(PVector p, Polygon poly){//https://en.wikipedia.org/wiki/Point_in_polygon
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();polygons.add(poly);
  Ray ray = new Ray(p, 0, polygons);
  ray.pentUpdate();
  if(ray.inside)ray.show();
  return ray.inside;
}

ArrayList<Vertex> getNeighborHasTag(int i, int tag, LoopedList<Vertex> vertices){
  ArrayList<Vertex> result = new ArrayList<Vertex>();
  if(vertices.prev(i).tag == tag)result.add(vertices.prev(i));
  if(vertices.next(i).tag == tag)result.add(vertices.next(i));
  return result;
}

LoopedList<Vertex> reverse(LoopedList<Vertex> target){
  LoopedList<Vertex> result = new LoopedList<Vertex>();
  for(int i = 0; i < target.size(); i++){
    result.add(target.get(target.size()-i-1));
  }
  return result;
}