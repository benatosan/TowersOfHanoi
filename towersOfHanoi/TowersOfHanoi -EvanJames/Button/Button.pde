class Button{
  private
  float x, y;
  int colour = 1;
  
  public
  Button(){} //<>//
  
  float getButtonX(){
    return x;
  }
  
  float getButtonY(){
    return y;
  }
  
  void setColour(int i){
    colour = i;
  }
  
  void drawButton(float Xpos, float Ypos){
    switch (colour){
     case 0 : fill (255,0,0);
              stroke(0,0,0);
              rect(Xpos, Ypos, 20, 20, 8);
              x = Xpos;
              y = Ypos;
              break;
     case 1 : fill (0,255,0);
              stroke(0,0,0);
              rect(Xpos, Ypos, 20, 20, 8);
              x = Xpos;
              y = Ypos;
              break;
    }
  }
};
