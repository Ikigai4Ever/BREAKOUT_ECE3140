# BREAKOUT_ECE3140


## Paddle Movement & Design
To move the paddle, use a variable that is either increased or decreased dependent on the movement (right or left) of the rotary encoder.

Have the process for changing the variable be dependent on the rise of Channel A and use Channel B to determine if the variable should increment or decrement.

Have the shift be based on the middlemost pixel of the paddle, with the same distance left and right of the paddle to draw the entirety of the paddle. Also save the leftmost and rightmost locations of the paddle at the top of the paddle to then compare to the ball location to change the direction of the bounce.

