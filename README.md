# BREAKOUT_ECE3140

## SUMMARY

This was done for Dr. Bruce's ECE 3140 Digital System Design class as the class project to make the pixel-art style game, BREAKOUT, with a few spins on the game. Some of these aspects included a color version of the game, along with a two-player variant of the game. The project was a group effort with Ty, Blake, and Daniel to create and develop the game. The board used was a DE10-Lite Development board with an Intel CPU on board, and was programmed using VHDL, using Quartus 20.1 as the software to upload the programs onto the DE10-Lite board. Following this section are other sections that helped in the development of the project or other notes to help readers with dissecting the VHDL descriptions.


## Standards for Design

### Paddle Movement & Design
To move the paddle, use a variable that is either increased or decreased depending on the rotary encoder's movement (right or left).

Have the process for changing the variable be dependent on the rise of Channel A, and use Channel B to determine if the variable should increment or decrement.

Have the shift be based on the middlemost pixel of the paddle, with the same distance left and right of the paddle to draw the entirety of the paddle. Also, save the leftmost and rightmost locations of the paddle at the top of the paddle to then compare to the ball location to change the direction of the bounce.

### Ball Movement

The ball will move in one of four quadrants. These are saved as integers so that the ball's scaling can be changed when contacting another block.

Ball size: 6x6 pixels

  x x x x x x
  x x x x x x
  x x x x x x
  x x x x x x
  x x x x x x
  x x x x x x
  
Ball Directional Standard:

   __________________________________
  |                |                 |
  |                |                 |
  |   Quadrant 2   |    Quadrant 1   |
  |                |                 |
  |                |                 |
  |----------------|-----------------|
  |                |                 |
  |                |                 |
  |   Quadrant 3   |    Quadrant 4   |
  |                |                 |
  |________________|_________________|
