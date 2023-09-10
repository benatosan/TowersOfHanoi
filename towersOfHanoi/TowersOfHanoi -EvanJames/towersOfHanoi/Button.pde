class Button{
  private
  float x, y;
  float h = 20;
  float w = 20;
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
  
  void setSize(int H, int W){
    h = H;
    w = W;
  }
  
  void drawButton(float Xpos, float Ypos){
    switch (colour){
     case 0 : fill (255,0,0);
              stroke(0,0,0);
              rect(Xpos, Ypos, h, w, 8);
              break;
     case 1 : fill (0,255,0);
              stroke(0,0,0);
              rect(Xpos, Ypos, h, w, 8);
              break;
    }
     x = Xpos;
     y = Ypos;
  }
};
