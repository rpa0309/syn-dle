import processing.sound.*;
SoundFile enter;
SoundFile win;

PImage title;
PImage title2;
PImage won;
PImage lost;
color[] colors = {color(231, 212, 192), color(233,137,115), color(136,178,204), 
                  color(101,142,169), color(51,161,253)};
                //background 0 //orange 1 //dull light blue 2
                //dull dark blue 3   //royal blue 4
String[] solutionPairs;
String[] guess;
boolean gameBegin = true;
boolean gameStart = false;
boolean gameRunning = false;
boolean hardMode = false;
boolean diffChanged = false;

Board game;

void setup(){
  size(500,500);
  
  title = loadImage("Syn-dle title.png");
  title.resize(500,500);
  title2 = loadImage("Syn-dle.png");
  title2.resize(500,500);
  won = loadImage("Winner.png");
  won.resize(500,500);
  lost = loadImage("Loser.png");
  lost.resize(500,500);
  
  enter = new SoundFile(this, "submitSound.mp3");
  win = new SoundFile(this, "winSound.mp3");
  
  background(colors[0]);
  
  solutionPairs = loadStrings("solutions.txt");
}

void draw(){
  if(gameBegin){
    //starting screen
    image(title, 0, 0);
    
    //buttons
    fill(136, 178, 204); //change
    rect(80, 400, 150, 50);
    rect(270, 400, 150, 50);
    
    //text
    fill(0);
    textSize(35);
    text("Start", 120, 435); 
    text("Difficulty", 280, 435);
    
    gameBegin = false;
  }
  
  if(diffChanged){
    image(title2, 0, 0);
    //title
    fill(colors[1]);
    rect(100, 150, 300, 75);
    
    //buttons
    fill(colors[2]);
    rect(160, 260, 185, 50);
    rect(160, 350, 185, 50);

    //text
    fill(0);
    textSize(75);
    text("Difficulty", 110, 210);
    textSize(35);
    text("Normal", 200, 295); 
    text("Hard", 215, 385); 
  }
  
  if(gameStart){
    //pick the solution
    String[] sol = new String[5];
    String[] list = split(solutionPairs[int(random(solutionPairs.length))], '\t');
    for(int i = 0; i < 5; i++){
      sol[i] = list[0].substring(i, i+1);
    }
    //initialize the board
    game = new Board(list[1], sol);
    //show syn on board
    fill(0);
    textSize(30);
    text("Synonym: " + list[1], 125, 490);
    
    image(title2, 0, 0);
    
    //buttons
    fill(colors[1]);
    rect(20, 20, 50, 50);
    rect(430, 20, 50, 50);
    fill(0);
    textSize(50);
    text("R", 30, 60); 
    text("X", 440, 60); 
    
    //boxes
    fill(colors[3]);
    for(int i = 0; i < 5; i++){
      for(int j = 0; j < 6; j++){
        rect(110+(55*i), 130+(55*j), 50, 50);
      }
    }
    
    gameStart = false;
  }
}

void mousePressed(){
  //if difficulty button is pressed, set the difficulty level
  if(mouseX >= 270 && mouseX <= 420 && mouseY >= 400 && mouseY <= 450 && !gameStart){
    background(colors[0]);
    diffChanged = true;
  }
  //if normal button is pressed, start game
  if(mouseX >= 160 && mouseX <= 345 && mouseY >= 260 && mouseY <= 310 && diffChanged && !gameStart){
    background(colors[0]);
    diffChanged = false;
    gameStart = true;
    gameRunning = true;
  }
  //if hard button is pressed, update difficulty and start game
  if(mouseX >= 160 && mouseX <= 345 && mouseY >= 350 && mouseY <= 400 && diffChanged && !gameStart){
    background(colors[0]);
    diffChanged = false;
    hardMode = true;
    gameStart = true;
    gameRunning = true;
  }
  //if start button is pressed, start the game
  if(mouseX >= 80 && mouseX <= 230 && mouseY >= 400 && mouseY <= 450 && !gameStart){
    background(colors[0]);
    gameStart = true;
    gameRunning = true;
  }
  //if the exit button is pressed, exit the game
  if(mouseX >= 430 && mouseX <= 480 && mouseY >= 20 && mouseY <= 70 && gameRunning){
    exit();
  }
  //if the start again button is pressed, get a new pair of syn/solution and clear the board
  if(mouseX >= 20 && mouseX <= 70 && mouseY >= 20 && mouseY <= 70 && gameRunning){
    background(colors[0]);
    gameBegin = true;
    gameRunning = false;
    if(win.isPlaying()){
      win.pause();
    }
  }
}

void keyTyped(){
  int[] index = game.getAttempt();
  //if alphabetic key pressed, add to current index of guesses
  if (key <= 122 && key >= 97 && gameRunning) {
    if(index[0] != -1 && index[1] != -1 && game.getGuess()[index[1]] == null){
      game.updateCurrentGuess(str(key));      
    } else{
      //handle no attempts left
      background(colors[0]);
      println("letter no attempts");
    }
  }
  //if enter is pressed, check that there is a valid guess, and add to guesses board
  if(key == 10 && gameRunning){
    boolean validGuess = true;
    for(int i = 0; i < 5; i++){
      if(game.getGuess()[i] == null){
        validGuess = false;
        println("Please enter a guess of 5 letters exactly");
        break;
      }
    }
    if(validGuess){
      enter.play();
      game.guessInfo(index[0]-1);
      game.clearCurrentGuess();
    }   
  }
}

class Board{
  String[][] board = new String[6][5]; //1 row for each guess, 1 column for each letter of the word
  String[] guess = new String[5];
  String[] solution;
  String syn;
  
  Board(String syn, String[] sol){
    this.syn = syn;
    solution = sol;
  }
  
  void updateCurrentGuess(String a){
    int[] index = getAttempt();
    guess[index[1]] = a;
    board[index[0]][index[1]] = a;
    fill(255);
    textSize(50);
    text(key, 120+(55*index[1]), 170+(55*index[0])); 
  }
  
  void clearCurrentGuess(){
    guess = new String[5];
  }
  
  void guessInfo(int j){
    if(j < 0){
      j = 5;
    }
   //check what letters are right and if their positions are correct
   if(!hardMode){
     //check which letters are correct, but not in the correct place
     for(int i = 0; i < 5; i++){
       for(int k = 0; k < 5; k++){
         if(guess[i].equals(solution[k]) && i != k){
           //draw orange box with letter over it to signify a correct letter in the incorrect place
           fill(colors[1]);
           rect(110+(55*(i)), 130+(55*j), 50, 50);
           fill(255);
           textSize(50);
           text(guess[i], 120+(55*i), 170+(55*j)); 
         }
       }
     }
   }
   for(int i = 0; i < 5; i++){
       if(guess[i].equals(solution[i])){
         //draw blue box with letter over it to signify a correct letter in correct place
         fill(colors[4]);
         rect(110+(55*(i)), 130+(55*j), 50, 50);
         fill(255);
         textSize(50);
         text(guess[i], 120+(55*i), 170+(55*j)); 
       }
   }
   if(checkWinner()){
     fill(colors[0]);
     stroke(colors[0]);
     rect(100,0, 300, 500);
     image(won, 0, 0);
     win.loop();
   } else if(j == 5){
     fill(colors[0]);
     stroke(colors[0]);
     rect(100,0, 300, 500);
     image(lost, 0, 0);
   }
  }
  
  boolean checkWinner(){
    for(int i = 0; i < 5; i++){
      if(!guess[i].equals(solution[i])){
        return false;
      }
    }
    return true;
  }
  
  void printBoard(){
    print(board[0][0]);
  }
  
  int[] getAttempt(){
    int[] sols = {-1, -1};
    for(int i = 0; i < 6; i++){
       for(int j = 0; j < 5; j++){
          if(board[i][j] == null){
            sols[0] = i;
            sols[1] = j;
            return sols;
          }
       }
    }
    return sols;
  }
  
  String[] getSol(){
    return solution;
  }
  
  String[] getGuess(){
    return guess;
  }
}
