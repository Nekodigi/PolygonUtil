class pBoolean{
  Polygon A, B;
  ArrayList<Polygon> Aonly = new ArrayList<Polygon>();//tag = 0
  ArrayList<Polygon> AinB = new ArrayList<Polygon>();//tag = 1
  ArrayList<Polygon> Bonly = new ArrayList<Polygon>();
  ArrayList<Polygon> BinA = new ArrayList<Polygon>();
  ArrayList<Vertex> intersectPs = new ArrayList<Vertex>();
  ArrayList<Polygon> Result = new ArrayList<Polygon>();
  
  pBoolean(Polygon A, Polygon B){
    this.A = A;
    this.B = B;
  }
  
  void show(){
    for(Polygon polygon : Aonly){
      //polygon.show();
    }
    for(Polygon polygon : AinB){
      //polygon.show(true);
    }
    for(Polygon polygon : Bonly){
      //polygon.show();
    }
    for(Polygon polygon : BinA){
      //polygon.show(true);
    }
    for(Polygon polygon : Result){
      polygon.show();
    }
    for(Vertex v : A.vertices){
      if(v.tag == 0){
        fill(360);
      }else fill(0);
      v.show();
    }
    for(Vertex v : intersectPs){
      if(v.tag == 0){
        fill(360);
      }else fill(0);
      rect(v.pos.x, v.pos.y, 10, 10);
    }
  }
  
  void calc(){
    clear();
    A.assignID();
    B.assignID();
    tagging(A, B, Aonly, AinB);
    tagging(B, A, Bonly, BinA);
    treatIntersect(A, B, Aonly, BinA);
    treatIntersect(A, B, AinB, BinA);
    treatIntersect(B, A, Bonly, AinB);
    treatIntersect(B, A, BinA, AinB);
    intersectP();
  }
  
  void intersectP(){
    ArrayList<Polygon> partPool = new ArrayList<Polygon>();
    partPool.addAll(AinB);
    partPool.addAll(BinA);
    println("start intersect");
    while(partPool.size() >= 2){
      Polygon poly1 = partPool.get(0);
      Polygon poly2 = partPool.get(1);
      partPool.remove(poly1);
      partPool.remove(poly2);
      int status = poly1.tryJoin(poly2);
      println("status"+status);
      if(status == 0){
        partPool.add(poly1);
        partPool.add(poly2);
      }else if(status == 1){
        partPool.add(poly1);
      }else{
        Result.add(poly1);
      }
    }
  }
  
  void clear(){
    Aonly = new ArrayList<Polygon>();
    AinB = new ArrayList<Polygon>();
    Bonly = new ArrayList<Polygon>();
    BinA = new ArrayList<Polygon>();
  }
  
  void tagging(Polygon X, Polygon Y, ArrayList<Polygon> Xonly, ArrayList<Polygon> XinY){//Attach 4 type of tag. X > Y
    Polygon prev = new Polygon();
    Vertex v_ = X.vertices.get(0);
    prev.vertices.add(v_);
    prev.tag = isInPolygon(v_.pos, Y) ? 1 : 0;
    Polygon first = prev;
    for(int i = 1; i < X.vertices.size(); i++){
      Vertex v = X.vertices.get(i);
      int tag = isInPolygon(v.pos, Y) ? 1 : 0;
      if(tag == prev.tag){
        prev.vertices.add(v);
      }else{
        prev.setVerticesTag();
        if(prev.tag == 0){
          Xonly.add(prev);
        }else{
          XinY.add(prev);
        }
        prev = new Polygon();
        prev.vertices.add(v);
        prev.tag = tag;
      }
    }
    if(prev.tag == first.tag){
      first.vertices = reverse(first.vertices);
      first.vertices.addAll(reverse(prev.vertices));
    }else{
      prev.setVerticesTag();
      if(prev.tag == 0){
        Xonly.add(prev);
      }else{
        XinY.add(prev);
      }
    }
  }
  
  Vertex getSame(PVector p){
    for(Vertex v : intersectPs){
      if(v.isEqual(p))return v;
    }
    return null;
  }
  //                  vertex domain  intersect target  polygon has domain's vertex, if polygons is AinB oppsiteSet is BinA
  void treatIntersect(Polygon X, Polygon Y, ArrayList<Polygon> polygons, ArrayList<Polygon> oppsiteSet){//polygon is part of X
  out_of_loop:
    for(int i = 0 ; i < polygons.size(); i++){
      Polygon polygon = polygons.get(i);
      Vertex first = polygon.vertices.first();
      Vertex last =  polygon.vertices.last();
      int firstID = polygon.vertices.first().id;
      int lastID =  polygon.vertices.last().id;
      int notPTag = polygon.tag == 0 ? 1 : 0;//get inversed tag
      ArrayList<Vertex> result = getNeighborHasTag(firstID, notPTag, X.vertices);
      Vertex firstPrev = null;
      Vertex lastNext = null;
      switch(result.size()){
        case 0:
          break out_of_loop;
        case 1:
          firstPrev = result.get(0);
          result = getNeighborHasTag(lastID, notPTag, X.vertices);
          if(result.size() != 0){
            lastNext = result.get(0);
          }else{
            break out_of_loop;
          }
          break;
        case 2:
          firstPrev = result.get(0);
          lastNext = result.get(1);
          break;
      }
      ArrayList<Polygon> tPolys = new ArrayList<Polygon>();
      tPolys.add(Y);
      Ray ray = new Ray(first.pos, PVector.sub(firstPrev.pos, first.pos), tPolys);
      ray.update();
      int barrierID = ray.hitBarrierID;
      PVector intersectP = ray.intersect;
      Vertex v = getSame(intersectP);
      if(v == null){
        v = new Vertex(intersectP);
        intersectPs.add(v);
      }
      polygon.vertices.add(0, v);
      ray = new Ray(last.pos, PVector.sub(lastNext.pos, last.pos), tPolys);
      ray.update();
      intersectP = ray.intersect;
      Vertex v2 = getSame(intersectP);
      if(v2 == null){
        v2 = new Vertex(intersectP);
        intersectPs.add(v2);
      }
      polygon.vertices.add(v2);
      if(barrierID == ray.hitBarrierID){
        Polygon tpoly = new Polygon();
        tpoly.vertices.add(v);
        tpoly.vertices.add(v2);
        oppsiteSet.add(tpoly);
      }
    }
  }
}