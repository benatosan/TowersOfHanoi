import java.util.ArrayList;
import java.util.ArrayDeque;
import java.util.Iterator;

boolean sent = false;
boolean ringInit = false;
boolean held;
boolean outOfPos = false;
boolean firstChecked;
int sourceTower;
int numRings = 3;
int moves;
String msg = "3";

ArrayList<ArrayDeque> towers = new ArrayList<ArrayDeque>();

ArrayList<TEXTBOX> textbox = new ArrayList<TEXTBOX>();

int main(){
  hanoi(towers, 3, moves, 0, 1, 2); 
  text(moves, 300, 20);
  return 0;
}

void hanoi(ArrayList<ArrayDeque> towers, int ring, int moves, int start, int mid, int end){
    if (ring == 1){
        towers.get(end).push(towers.get(start).pop());
        moves++;
    } else {
        hanoi(towers, ring-1, moves, start, end, mid);
        towers.get(end).push(towers.get(start).pop());
        moves++;
        hanoi(towers, ring-1, moves, mid, start, end);
    }
}

void setup(){ 
  size(600, 400);
  background(255,255,255);
  smooth();
  
  for (int i = 0; i < 3; i++){
    towers.add(new ArrayDeque<Ring>());
  }
  InitTextbox();
  held = false;
}

void draw(){
  makeTowers();
  for (TEXTBOX t : textbox){
    t.DRAW();
  }
  if (sent && ringInit == false){
    numRings = Integer.parseInt(msg);
    for (int i = numRings; i > 0; i--){
      Ring ring = new Ring(i);
      ring.setPos(100 - ((i*10) - 10), 330 - ((numRings-i)*20));
      towers.get(0).push(ring);
    }
    ringInit = true;
  }
    if (numRings < 3 || numRings > 9){
      textSize(20);
      text("Invalid, restart program", 50, 50);
    } else {
    int i = numRings;
    for(int t = 0; t < 3; t++){
        Iterator<Ring> iter = towers.get(t).iterator();
        int ringIndex = towers.get(sourceTower).size() - 1;      
        while (iter.hasNext()){
          var currentRing = iter.next();
          if (ringIndex == towers.get(sourceTower).size() -1){
            currentRing.isFirst = true;
          }
          if(held && cursorInRing((numRings-i+1)*20, 20, currentRing) && currentRing.isFirst){
            outOfPos = true;
            currentRing.setPos(mouseX-pmouseX, mouseY-pmouseY);
            currentRing.isDragged = true;
            background(255);
            makeTowers();
          }
          currentRing.render(i%3); //to-do: set colour on creation
          i--;
          ringIndex--;
          currentRing.isFirst = false;
        }
    }
  }
}
void InitTextbox(){
  TEXTBOX receiver = new TEXTBOX();
  receiver.W = 30;
  receiver.H = 30;
  receiver.X = 10;
  receiver.Y = 30;
  
  textbox.add(receiver);
}

void mousePressed(){
  for (TEXTBOX t : textbox){
    t.PRESSED(mouseX, mouseY);
  }
  if (held == false){
    held = true;
  }
  sourceTower = closestTower(mouseX);
  print("\n sourceTower ", sourceTower);
}

void keyPressed(){
   for (TEXTBOX t : textbox){
     if (t.KEYPRESSED(key, keyCode) == true){ //if user hits enter
       sent = true;
       msg = textbox.get(0).Text;
     }
   }
}

boolean cursorInRing(float ringW, float ringH, Ring ring){
  return ((mouseX > ring.getX() && mouseX < (ring.getX() + ringW)) && (mouseY > ring.getY() && mouseY < (ring.getY() + ringH)));
}

void mouseReleased(){
  held = false;
  if (outOfPos) {
    var droppedRing = (Ring)towers.get(0).getFirst();
    for(int t = 0; t < 3; t++){
      Iterator<Ring> iter = towers.get(t).iterator();
      while (iter.hasNext()){
        var currentRing = iter.next();
        if (currentRing.isDragged) {
          droppedRing = currentRing;
        }
     }
    }
    switch (closestTower(droppedRing.getX())){
      case 0 : towers.get(sourceTower).pop();
               towers.get(0).push(droppedRing);
               droppedRing.currentTower = 0;
               print(" to tower 1");
               break;     
      case 1 : towers.get(sourceTower).pop();
               towers.get(1).push(droppedRing);
               droppedRing.currentTower = 1;
               print(" to tower 2");
               break;                      
      case 2 : towers.get(sourceTower).pop();
               towers.get(2).push(droppedRing);
               droppedRing.currentTower = 2;
               print(" to tower 3");
               break;
      default : towers.get(sourceTower).pop();
                towers.get(0).push(droppedRing);
                print("error");
                break;
     }
     outOfPos = false;
   } 
}

int closestTower(float x){
  float min = 1000; int tower = 1;
  print("\n x is \n", x);
  if (abs(x - 100) < min) {
      min = abs(x - 100);
      tower = 0;
  }
  if (abs(x - 290) < min){
      min = abs(x - 290);
      tower = 1;
  }
  if (abs(x - 480) < min){
      min = abs(x - 480);
      tower = 2;
  }
  return tower;
            
}

void makeTowers(){
  fill (0,0,0);
  stroke(0,0,0);
  rect(290, 100, 20, 250);
  
  fill (0,0,0);
  stroke(0,0,0);
  rect(100, 100, 20, 250);
  
  fill (0,0,0);
  stroke(0,0,0);
  rect(480, 100, 20, 250);
  
  fill (0,0,0);
  stroke(0,0,0);
  rect(0, 350, 600, 10);
  
  textSize(20);
  text("Enter number of rings (3 - 9)", 10, 20);
}
