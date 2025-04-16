# BREAKOUT_ECE3140


## Paddle Movement & Design
To move the paddle, use a variable that is either increased or decreased dependent on the movement (right or left) of the rotary encoder.

Have the process for changing the variable be dependent on the rise of Channel A and use Channel B to determine if the variable should increment or decrement.

Have the shift be based on the middlemost pixel of the paddle, with the same distance left and right of the paddle to draw the entirety of the paddle. Also save the leftmost and rightmost locations of the paddle at the top of the paddle to then compare to the ball location to change the direction of the bounce.

## Ball Movement

The ball will be made to move in one of four quadrants. These are saved as integers so that the scaling of the ball can be changed when contacting another block.

Ball size: 6x6 pixels

    x x x x x x
    x x x x x x
    x x x x x x
    x x x x x x
    x x x x x x
    x x x x x x

                |
                |
   Quadrant 2   |    Quadrant 1   
                |    
                |
----------------|----------------
                |
                |
   Quadrant 3   |    Quadrant 4   
                |
                |
