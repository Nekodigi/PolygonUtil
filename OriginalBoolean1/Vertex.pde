class Vertex{
  PVector pos;
  int id;
  int tag;
  
  Vertex(){
    
  }
  
  Vertex(PVector pos){
    this.pos = pos;
  }
  
  boolean isEqual(PVector p){
    if(PVector.dist(p, pos) < EPSILON){
      return true;
    }else{
      return false;
    }
  }
  
  void show(){
    text(id, pos.x, pos.y);
    ellipse(pos.x, pos.y, 10, 10);
  }
}