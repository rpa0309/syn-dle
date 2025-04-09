PImage title;
String[] pairs;
boolean gameStart = false;
boolean gameWon = false;
//load pairs from txt file

void setup(){
  size(500,500);
  title = loadImage("Syn-dle title.png");
  title.resize(500,500);
  background(231, 212, 192);
  
  
  //starting screen
  image(title, 0, 0);
  
  //buttons
  fill(136, 178, 204);
  rect(80, 400, 150, 50);
  rect(270, 400, 150, 50);
  
  //text
  fill(0);
  textSize(35);
  text("Start", 120, 435); 
  text("Difficulty", 280, 435); 
}

void draw(){
  
}

void mousePressed(){
  //if difficulty button is pressed, set the difficulty level
  //if start button is pressed, start the game
  //if the exit button is pressed, exit the game
  //if the start again button is pressed, get a new pair of syn/solution and clear the board
}

void keyPressed(){
  //if alphabetic key pressed, add to current index of guesses
  //if enter is pressed, check that there is a valid guess, and add to guesses board
}

void startGame(){
  //pick the solution
  //initialize the board
  //set gameStart to true
  //show syn on board
}

void checkWinner(String[] guess){
  //check if the guess == the solution
  //update gameWon
}

int[] guessInfo(String[] guess){
 //check what letters are right and if their positions are correct
 int[] info = new int[5];
 return info;
}

class Board{
  String[][] board = new String[6][5]; //1 row for each guess, 1 column for each letter of the word
  
  //void updateCurrentGuess(1 letter)
  //String[] getGuess
  
  
}
