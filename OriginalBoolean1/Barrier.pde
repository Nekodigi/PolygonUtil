class Barrier{
  PVector sp, ep;
  int id;
  
  Barrier(PVector sp, PVector ep){
    this.sp = sp;
    this.ep = ep;
  }
  
  void show(){
     line(sp, ep);
  }
}