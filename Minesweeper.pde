import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons;
//2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>();
//ArrayList of just the minesweeper buttons that are mined
int NUM_ROWS = 10;
int NUM_COLS = 10;
//make game over or you win display on screen
//losing mesage, make all red and !!

public void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  textSize(24);
  // make the manager
  Interactive.make( this );
  buttons = new MSButton [NUM_ROWS][NUM_COLS];
  //your code to initialize buttons goes here
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      buttons[r][c] = new MSButton (r, c);
    }
  }
  setMines();
}
public void setMines()
{
  //your code
  int NUM_MINES = 6;
  while (mines.size() < NUM_MINES) {
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[row][col])  ) {
      mines.add (buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  
  //displays all the mines
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      if (mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false) {
        fill (255);
        buttons[r][c].setLabel("!!");
      }
    }
  }
 pushMatrix(); 
  fill (255); 
  textSize(25); 
  text ("Game Over", 200, 200);
  popMatrix();
  System.out.println("Game Over");
}
public void displayWinningMessage()
{
  for (int i = 0; i < mines.size(); i++) {
    MSButton mine = mines.get(i);
    fill (255);
    mine.setLabel("!!");
  }
  pushMatrix(); 
  fill (#19F530); 
  textSize(25); 
  text ("You Win", 200, 200);
  popMatrix();
  System.out.println("You Win!");
}
public boolean isValid(int row, int col) {
  if (row >= 0 && row < NUM_ROWS
    && col >= 0 && col < NUM_COLS) {
    return true;
  }
  return false;
}

public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = -1; i < 2; i++) {
    for (int e = -1; e < 2; e++) {
      if (i == 0 && e == 0) {
        e++;
      }
      if (isValid(row+i, col+e) &&
        mines.contains(buttons[row + i][col + e])) {
        numMines ++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;
    if (mouseButton == RIGHT)
    {
      if (flagged == true) {
        flagged = false;
      } else {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
      return;
    } else if (countMines(myRow, myCol)>0) {
      setLabel(countMines(myRow, myCol));
    } else if (countMines (myRow, myCol) == 0) {
      for (int r = myRow-1; r <= myRow+1; r++) {
        for (int c = myCol-1; c <= myCol+1; c++) {
          if (isValid(r, c) && !buttons[r][c].isClicked()) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
    if (isWon()) {
      displayWinningMessage();
    }
  }
  public void draw ()
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked()
  {
    return clicked;
  }
}
