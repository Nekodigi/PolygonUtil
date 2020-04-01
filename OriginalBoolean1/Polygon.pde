class Polygon{
  LoopedList<Vertex> vertices = new LoopedList<Vertex>();
  ArrayList<Barrier> barriers = new ArrayList<Barrier>();
  int tag;
  
  Polygon(){}
  
  Polygon(LoopedList<Vertex> vertices){
    this.vertices = vertices;
  }
  //      radius    resolution  origin
  Polygon(float r, int res, PVector o){
    for(int i = 0; i < res; i++){
      float theta = map(i, 0, res, 0, TWO_PI);
      PVector base = PVector.fromAngle(theta).mult(r).add(o);//point on circle
      PVector std = PVector.random2D().mult(r/4);
      vertices.add(new Vertex(base.add(std)));
    }
    calcBarrier();
  }
  
  int tryJoin(Polygon polygon){
    int count = 0;
    if(vertices.first().id == polygon.vertices.first().id){
      vertices = reverse(vertices);
      vertices.addAll(polygon.vertices);
      count++;
    }else if(vertices.first().id == polygon.vertices.last().id){
      polygon.vertices.addAll(vertices);
      vertices = polygon.vertices;
      count++;
    }
    if(vertices.last().id == polygon.vertices.first().id){
      vertices.addAll(polygon.vertices);
      count++;
    }else if(vertices.last().id == polygon.vertices.last().id){
      vertices.addAll(reverse(polygon.vertices));
      count++;
    }
    return count;
  }
  
  void assignID(){
    for(int i = 0; i < vertices.size(); i++){
      vertices.get(i).id = i;
      barriers.get(i).id = i;
    }
  }
  
  void calcBarrier(){
    for(int i = 0; i < vertices.size(); i++){
      barriers.add(new Barrier(vertices.get(i).pos, vertices.get((i+1)%vertices.size()).pos));
    } 
  }
  
  void setVerticesTag(){
    for(Vertex v : vertices){
      v.tag = tag;
    }
  }
  
  void show(){
    show(false);
  }
  
  void show(boolean showVertices){
    beginShape();
    for(Vertex v : vertices){
      if(showVertices)ellipse(v.pos.x, v.pos.y, 10, 10);
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
  
  Polygon clone(){
    return new Polygon(vertices);
  }
}