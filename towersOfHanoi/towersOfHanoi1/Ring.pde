class Ring {
  protected
  int size;
  int colour;
  float x;
  float y;
  
  public 
  Ring(int ringSize){
    size = ringSize;
    isFirst = false;
  }
  
  boolean isFirst;
  boolean isDragged;
  int currentTower;
  
  void setPos(float Xval, float Yval){
    x += Xval;
    y += Yval;
  }
  
  void setX(float Xvalue){
    x = Xvalue;
  }
  
  void setY(float Yvalue){
    y = Yvalue;
  }
  
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  
  void render(int colour){
      switch (colour){
        case 0 : fill (255,0,0);
                  stroke(0);
                  rect(x, y, size*20, 20);
                  break;
        case 1 : fill (0,0,255);
                  stroke (0);
                  rect(x, y, size*20, 20);
                  break;
        case 2 : fill (255,255,0);
                  stroke(0);
                  rect(x, y, size*20, 20);
                  break;
      }
  }
  int getSize(){
    return size;
  }
  
};
