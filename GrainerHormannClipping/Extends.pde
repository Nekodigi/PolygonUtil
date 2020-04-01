void point(PVector p, color col){
  stroke(col);
  strokeWeight(20);
  point(p.x, p.y);
  strokeWeight(4);
  stroke(0);
}