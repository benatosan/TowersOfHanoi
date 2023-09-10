//Towers of Hanoi - Evan James (drag other files into this window and it should run even if there are red lines still)
//This program makes a playable program of the game "Towers of Hanoi"
//Note : this program contains both a drag&drop and button system for playing the game. Both are fully functional, try them both out!
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
import java.util.ArrayList;
import java.util.ArrayDeque;
import java.util.Iterator;

//Initializing and declaring variables
boolean sent = false;
boolean ringInit = false;
boolean buttonInit = false;
boolean held = false;
boolean clicked;
boolean firstClick = false;
boolean buttonSequence = false;
boolean validMove;
boolean outOfPos = false;
boolean usingButtons;
boolean solving;
int sourceTower;
int numRings = 3;
int moves = 0;
String msg;
int startButton;
int endButton;

int n;
int start = 0;
int mid = 1;
int end = 2;

//Creates a stack of stacks called towers
ArrayList<ArrayDeque> towers = new ArrayList<ArrayDeque>();

//Creates a stack of type "TEXTBOX" (in TEXTBOX tab)
ArrayList<TEXTBOX> textbox = new ArrayList<TEXTBOX>();

//Creates a button array
Button[] buttonArr;

//Recursive hanoi function (this is by itself on the replit I also submitted)
void hanoi(ArrayList<ArrayDeque> towers, int ring, int start, int mid, int end){
    if (ring == 1){
        towers.get(end).push(towers.get(start).pop());
        delay(500);
    } else {
        hanoi(towers, ring-1, start, end, mid);
        towers.get(end).push(towers.get(start).pop());
        delay(500);
        hanoi(towers, ring-1, mid, start, end);
    }
}

void setup(){ 
    size(600, 600);
    background(255,255,255);
    buttonArr = new Button[4];                //Loads the button array
    for (int i = 0; i < 3; i++){              //for loop to create the towers and buttons (3)
      towers.add(new ArrayDeque<Ring>());
      buttonArr[i] = new Button();
    }
    InitTextbox();  //Initializes the textbox //<>//
}

void draw(){
  makeTowers(); //Function to draw the towers
  for (TEXTBOX t : textbox){               //Checks and draws the textbox/its contents
    t.DRAW();
  } //<>//
  if (sent && ringInit == false){          //Only occurs once (ringInit) and only when the user hits enter(sent) 
   numRings = Integer.parseInt(msg);       //Parses string returned from textbox into a int
    n = numRings;
    textSize(15);
    text("How to Play:\n1. Click the button under the tower you wish to move the ring FROM\n2. Then, the button under the tower you wish to move that ring TO\n3. Attempt to move all the rings from the first tower to the \nlast tower without putting a larger ring on top of a smaller ring\n4. You may also drag the rings from tower to tower", 50, 430);
    for (int i = numRings; i > 0; i--){
      Ring ring = new Ring(i,i%3);         //Creates however many rings the user wants and pushes them on the tower
      ring.setPos(100 - ((i*10) - 5), 330 - ((numRings-i)*20));
      towers.get(0).push(ring);
    }
    ringInit = true;
  }
    if (numRings < 3 || numRings > 9){           //Error message if user enters too few or too many rings
      textSize(20);
      text("Invalid, restart program", 50, 50);
    } else {
    int i = numRings;
    for(int t = 0; t < 3; t++){                        //Goes over each tower every frame
        buttonArr[t].drawButton(100 + t*190, 375);    //draws the buttons
        if (clicked && cursorOnButton(buttonArr[t]) && firstClick == false){ //Checks which buttons are pressed and stores them in variables
            fill(255);
            stroke(255);
            rect(140, 70, 400, 30);
            clicked = false;
            firstClick = true;
            startButton = t;
            buttonArr[t].setColour(0);        //sets colour to red as opposed to green for user ease
          } else if (clicked && cursorOnButton(buttonArr[t]) && firstClick){    //if a button has already been pressed once
            endButton = t;
            buttonSequence = true;
            buttonArr[startButton].setColour(1); //sets colour back to green once done
          } //<>//
        Iterator<Ring> iter = towers.get(t).iterator();   //Iterator that goes over every ring in the tower      
        while (iter.hasNext()){                            //while there is another ring in the tower
          var currentRing = iter.next();
         //BUTTON STARTS********************************************
          if (buttonSequence == true){                    //If 2 buttons have been pressed //<>//
            if (towers.get(startButton).isEmpty()){       //Checks if the tower of the first button is empty and outputs error msg if so 
              textSize(20);
              fill(255,0,0);
              text("no rings on the selected tower", 150,90);
              firstClick = false;
              clicked = false;
              buttonSequence = false;
              validMove = false;                          //Note: Allows user to keep playing without changing the state of the game
            } else {
              var movingRing = (Ring)towers.get(startButton).getFirst();    //the movingRing is the ring that was first selected
              if (!towers.get(endButton).isEmpty()){                        //if tower user is putting ring on is not empty, check if there is a smaller ring underneath
                var ringUnder = (Ring)towers.get(endButton).getFirst();
                if (movingRing.getSize() > ringUnder.getSize()){
                  textSize(20);
                  fill(255,0,0);
                  text("cannot put large ring on smaller", 150,90);        //error msg if so
                  firstClick = false;
                  clicked = false;
                  buttonSequence = false;
                  validMove = false;
                } else {
                  validMove = true;                                        //if not, what the user is doing is a valid move
                }
              } 
              if (validMove || towers.get(endButton).isEmpty()) {          //if it's a valid move or the user is trying to put a ring on an empty tower...
                if(startButton == endButton){                              //if user is putting the ring on the same tower, do nothing
                  firstClick = false;
                  clicked = false;
                  buttonSequence = false;
                  usingButtons = false;
                  break;
                } else {                                                  //otherwise, pop the movingRing off of the first tower and push it onto the target tower
                  towers.get(startButton).pop();
                  towers.get(endButton).push(movingRing);
                  movingRing.setX((100 + (endButton * 190)) - ((movingRing.getSize()*10) - 5)); //setting the position of the rings (with correct offset)
                  movingRing.setY(350 - 20*towers.get(endButton).size());
                  moves++; //increment moves
                  background(255);                                  //resetting
                  makeTowers();
                  firstClick = false;
                  clicked = false;
                  buttonSequence = false;
                  usingButtons = false;
                }
              }
            }
          }
         //BUTTONS END****************************************************
         var towerRing = (Ring)towers.get(sourceTower).peekFirst();  //for the hitbox
          if(!towers.get(sourceTower).isEmpty() && !usingButtons && held && cursorInRing((towerRing.getSize()+1) * 20 + 5, 20, (Ring)towers.get(sourceTower).getFirst())){ 
            outOfPos = true;                                            //^^^ if the buttons aren't being used, mouse is down, the cursor is in the ring and the tower isn't empty
            currentRing = (Ring)towers.get(sourceTower).getFirst(); //current ring set to the ring being dragged
            currentRing.setPos(mouseX-pmouseX, mouseY-pmouseY); //current ring's position follows the mouse
            background(255);
            makeTowers();
          }
          currentRing.render(); //draws the ring in its correct position after everything
          i--;
          currentRing.isFirst = false;
          
            if (towers.get(2).size() == numRings){ //if the user wins the game
              int m = (int)pow(2,numRings) - 1;
              textSize(50);
              text("YOU WIN!", 200, 90);
              textSize(20);
              text("Restart program to play again!", 175, 450);
              textSize(20);
              fill(0);
              text("Moves made: ",250, 500);
              text(moves, 370, 500);
              text("Min moves: ", 250, 525);
              text (m, 370, 525);
              if(moves == m){                    //checks if user played optimally and congratulates
                fill(0,255,15);
                text ("Perfectly done!", 250, 570);
              }
            }
        }
    }
  }
}
//Sets up the textbox
void InitTextbox(){ 
  TEXTBOX receiver = new TEXTBOX();
  receiver.W = 30;
  receiver.H = 30;
  receiver.X = 10;
  receiver.Y = 30;
  
  textbox.add(receiver);
}
//when the mouse is pressed
void mousePressed(){
  for (TEXTBOX t : textbox){ //checks if mouse is inside the textbox while textbox available //<>//
    t.PRESSED(mouseX, mouseY);
  }
  if (held == false){
    held = true;
  }
  clicked = true;
  if (cursorOnButton(buttonArr[0]) || cursorOnButton(buttonArr[1]) || cursorOnButton(buttonArr[2])){ //if the mouse is in the button's hitbox when mouse down
    usingButtons = true;
  }
  sourceTower = closestTower(mouseX); //the starting tower is set to the tower closest closest to the cursor
}

//when a key is pressed
void keyPressed(){
   for (TEXTBOX t : textbox){
     if (t.KEYPRESSED(key, keyCode) == true){ //if user hits enter
       sent = true;
       msg = textbox.get(0).Text;
     }
   }
}

//returns true if the cursor is within the boundaries of a ring
boolean cursorInRing(float ringW, float ringH, Ring ring){
  return (mouseX > ring.getX() && mouseX < ring.getX() + ringW && mouseY > ring.getY() && mouseY < ring.getY() + ringH);
}

//when mouseReleased
void mouseReleased(){
  held = false; //<>//
  clicked = false;
  if (outOfPos) {
       background(255);
       makeTowers();
    var droppedRing = (Ring)towers.get(sourceTower).getFirst(); //ring that was being dragged and was just dropped
    int endTower = closestTower(droppedRing.getX());            //the target tower
    var ringBeneath = (Ring)towers.get(endTower).peekFirst();   //the top ring of the target tower
    if (ringBeneath != null && ringBeneath.getSize() < droppedRing.getSize()){  //if the target tower is not empty and its top ring is smaller than the one user dropped
      textSize(20);
      fill(255,0,0);
      text("cannot put large ring on a smaller one", 150,90); //error msg
      endTower = -1;                                          //sent to "do nothing" case
    } 
    if (sourceTower == endTower){ //if dropped on the tower it was taken from
      endTower = -1;              //sent to "do nothing" case
    }
      switch (endTower){ //pops off first tower and pushes onto target tower
        case 0 :                        //target tower is the first tower
                 towers.get(sourceTower).pop();
                 towers.get(0).push(droppedRing);
                 droppedRing.setX((100 + (endTower * 190)) - ((droppedRing.getSize()*10) - 5)); //setting the position of the rings (with correct offset)
                 droppedRing.setY(350 - 20*towers.get(endTower).size());
                 moves++;
                 print(" to tower 0");  
                 break;
        case 1 :                        //target tower is the middle tower
                 towers.get(sourceTower).pop();
                 towers.get(1).push(droppedRing);
                 droppedRing.setX((100 + (endTower * 190)) - ((droppedRing.getSize()*10) - 5)); //setting the position of the rings (with correct offset)
                 droppedRing.setY(350 - 20*towers.get(endTower).size());
                 moves++;
                 print(" to tower 1");  
                 break;
        case 2 :                       //target tower is the last tower
                 towers.get(sourceTower).pop();
                 towers.get(2).push(droppedRing);
                 droppedRing.setX((100 + (endTower * 190)) - ((droppedRing.getSize()*10) - 5)); //setting the position of the rings (with correct offset)
                 droppedRing.setY(350 - 20*towers.get(endTower).size());
                 moves++;
                 print(" to tower 2");  
                 break;
        default :                     //"do nothing" case
                 droppedRing.setX((100 + (sourceTower * 190)) - ((droppedRing.getSize()*10) - 5)); //setting the position of the rings (with correct offset)
                 droppedRing.setY(350 - 20*towers.get(sourceTower).size());
                 print("error");
                 break;
       }
    }
     outOfPos = false; 
}

//checks for and returns the closest tower relative to a position "x"
int closestTower(float x){
  float min = 1000; int tower = 1;
  //print("\n x is \n", x);
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

//draws the towers
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
  text("Type in # of rings(3 - 9) and hit enter", 10, 20);
  }

//returns true if the cursor is within the boundaries of a button
//Note: extra space outside the hitbox (+40 and -20) is on purpose to allow some human error when clicking
boolean cursorOnButton(Button button){
  return (mouseX > button.getButtonX() - 20 && mouseX < button.getButtonX() + 40 && mouseY > button.getButtonY() - 20 && mouseY < button.getButtonY() + 40);
}
