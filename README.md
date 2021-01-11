# Snake
This awesome game is made with x86 assembly depended on Irvine library.
There are many features and options that the user can select:
1. The player can enter his name
2. He can select game difficulty (Easy - Normal - Hard)
3. The snake grows when eating the food
4. The food appears randomly
5. The score increases when eating the food
6. The speed depends on user difficulty
7. The player loses when the snake collides the wall
8. The player has 3 lives 

## Gameboard map
```
------(1 1 1 1)-------
|                    |
|					           |
|                    | 
(0 0 0)           (maxX)
|                    |  
|                    |
|                    |
--------(maxY)--------
```
## Main Functions
1. Main Function:
  This function handles the game by calling the other functions and taking the user to the game.
2. PrintWalls Function:
  This function Prints the border of the windows and the wall of the game.
3. DrawTitleScreen Function:
  This function has the design of the first window (welcome window).
4. DrawMainMenu Function:
  This function has the design of the game configuration, taking the player name and game difficulty.
5. ScoreInfo Function:
  This function prints the score and the player name.
6. GenerateFood Function:
  This function generates food in a random postion (depening on Randomize and random32 functions of ivrine library).
7. Grow Function:
  This function grows the snake length (increament the head index), and increasing the score.
9. SetDirection Function:
  This function sets the direction to move the snake when pressing of the appropriate arrow.
9. KeySync Function:
  This function works as a listener in background to detect user key pressing to change the snake direction.
10. MaveSnake Function:
  This function is responsible for moving the snake (increasing the head and deleting the tail).
11. IsCollision Function:
  This function is fired each time the snake moves and it has three cases: 
  a) If the snake doesn't hit the wall, then continue playing.
  b) If the snake hits the wall but the players has lives, so decreament lives by 1 and continue playing.
  c) If the snake hits the wall and the player has no more chances, then the game is over.
12. DrawGameOver Function:
  This function prints the gameover window and score.
13. ResetData Function:
  This function resets the snake position, the head and tail indexes ,and the default direction to allow the player to play again.
  
 ## Macros Functions
 1. mGotoxy MACRO
  This function is used to go to a specific position on the screen by x and y coordinates.
 2. mWrite MACRO
  This function is used to encapsulate a text string to a string variable to be written on the screen.
 3. mWriteString MACRO
  This function is used to write a string variable on the screen.
 4. mReadString MACRO
  This function is used to take a string from the user.
  
  ## Authors 
   1. [Mostafa Abobakr](https://github.com/imostafaabobakr) 
   2. [Ahmed Samy](https://github.com/samyvic)
   3. [Mostafa Ramzy](https://github.com/mostafaramzyabdelganey)
   4. [Mahmoud Diab](https://github.com/mahmouddiab74)
   5. [Mohamed Mahmoud Omar](https://github.com/mhmdomar)
   
   ### Ivrine32 Docs
    http://csc.csudh.edu/mmccullough/asm/help/index.html?page=source%2Fwin32lib%2Fsetfilepointer.htm
    
   
