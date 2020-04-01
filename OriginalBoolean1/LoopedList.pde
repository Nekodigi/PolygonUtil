class LoopedList<T> extends ArrayList<T>{
  LoopedList(){
    
  }
  
  LoopedList(T t){
    add(t);
  }
  
  T next(int i){
    if(i + 1 < size()){
      return get(i+1);
    }else{
      return first();
    }
  }
  
  T prev(int i){
    if(i - 1 >= 0){
      return get(i-1);
    }else{
      return last();
    }
  }
  
  T first(){
    return get(0);
  }
  
  T last(){
    return get(size() - 1);
  }
}