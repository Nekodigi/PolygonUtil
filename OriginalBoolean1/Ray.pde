class Ray{
  PVector o, d, intersect;
  int hitBarrierID;
  boolean estInside = false;
  boolean inside = false;
  boolean isFinal = false;
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  
  Ray(float ox, float oy, float dx, float dy, ArrayList<Polygon> polygons){
    this(new PVector(ox, oy), new PVector(dx, dy), polygons);
  }
  
  Ray(PVector o, PVector d, ArrayList<Polygon> polygons){
    this.o = o;
    this.d = d;
    this.polygons = polygons;
  }
  
  Ray(PVector o, float angle, ArrayList<Polygon> polygons){
    this(o, PVector.fromAngle(angle), polygons);
  }
  
  void marchBit(){
    o.add(PVector.mult(d, EPSILON*10));
  }
  
  void update(){
    float bestDist = 10000000;
    PVector bestP = null;
    Barrier hitBarrier = null;
    for(Polygon polygon : polygons){
    for(Barrier barrier : polygon.barriers){
      PVector p = intersection(barrier.sp, barrier.ep, o, PVector.add(o, d));
      if(p != null){
        float distance = dist(p.x, p.y, o.x, o.y);
        if(distance < bestDist){
          bestDist = distance;
          hitBarrier = barrier;
          bestP = p;
        }
      }
    }
    }
    if(bestP != null){
      intersect = bestP;rect(bestP.x, bestP.y, 10, 10);
      hitBarrierID = hitBarrier.id;
    }
  }
  
  void pentUpdate(){//light will penterating. for point in polygon
    float bestDist = 10000000;
    PVector bestP = null;
    Barrier hitBarrier = null;
    for(Polygon polygon : polygons){
    for(Barrier barrier : polygon.barriers){
      PVector p = intersection(barrier.sp, barrier.ep, o, PVector.add(o, d));
      if(p != null){
        float distance = dist(p.x, p.y, o.x, o.y);
        if(distance < bestDist){
          bestDist = distance;
          hitBarrier = barrier;
          bestP = p;
        }
      }
    }
    }
    if(bestP != null){
       d = PVector.sub(bestP, o);
       Ray ray = new Ray(bestP, 0, polygons);
       ray.estInside = !estInside;
       ray.marchBit();
       ray.pentUpdate();
       isFinal = ray.isFinal;
       if(isFinal){
         inside = ray.inside;
       }
    }else{
      isFinal = true;
      inside = estInside;
      d.mult(100000);
    }
  }
  
  void show(){
    //if(estInside){
    //  stroke(255);
    //}else{
    //  stroke(255, 150);
    //}
    //if(inside){
    //  stroke(255, 0, 0);
    //}
    //for(Polygon polygon : polygons)polygon.show();
    line(o, PVector.add(o, d));
  }
}