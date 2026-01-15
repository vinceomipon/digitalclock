# DE1-SoC Digital Clock
This projects focuses on building a 24-hour format digital clock using the DE1-SoC board while writing HDL.



## How It's Made:

**Tech used:** SystemVerilog<br>
**Tools & Services:** Quartus, Questa, ModelSim, EDAplayground<br>
**Hardware:** FPGA Board (DE1-SoC)

### Concept

The digital clock was designed using the built-in 50 MHz crystal oscillator on the board to continuously tick time forward. However, we need to convert 50 MHz to 1 Hz to generate one second. This is achieved using a clock divider which takes in the 50 MHz and outputs the 1 Hz required. This is achieved by using a moduluo-*n* counter that tracks the number of positive edges that the clock produces. The counter will reset to zero and produce a flag to increment seconds when the counter reaches 50,000,000 since it is converting from 50 MHz to 1 Hz.

A separate module was made to handle the unit conversions between seconds, minutes and hours. On the positive edge of the built-in clock, it checks if the flag to increment seconds is true. If it is true, it then checks sequentially whether seconds, minutes or hours has reached their max. If either has reached their max, it resets the time unit to zero and increments the next time unit if necessary.

This projects also allows user input to set the hours and minutes respectively. A Moore FSM was used to handle the user input. Shown below is the FSM designed to handle user input.

![fsm](https://github.com/vinceomipon/digitalclock/blob/main/fsm.png?raw=true)

The reset button is assigned to the display state. The input to the fsm is a mode button that will transition to another state when pressed, otherwise it will remain in its current state. The output of the fsm is the state encoding which indicates which time unit to set. For example, to set hours the state encoding would be 01 and minutes would be 10. The state encoding are assigned to the LEDR to help with debugging. When the user is in either hours or minute states, they can change the unit by using the up and down buttons which will only update if the number is within range of that time unit. This is implemented within the time handler module though, since multiple modules cannot drive the same signal.

When testing my implementation on the board, I noticed that my states were not transitioning in the fsm based on what the LEDs displayed. This was the result of several issues:
* The buttons are asynchronous to the built-in clock
* Metastability can occur since the button can be updated close to a clock edge
* The FSM races thorugh its states due to button bounce

To handle these issues the inputs were put into a two stage synchronizer to ensure that the fsm and time handler module receive reliable signals. In addition, A positive edge detector was used to send a single pulse instead of a continuous pulse to prevent racing between states in the fsm.

Lastly, the seconds, minutes and hours were all displayed on each seven segment display using a decoder module and produces decimal values 1-9.

## Future Improvements
* Time will only tick forward if the user sets the hours and minutes
* Swap between 24 hour format and 12 hour format
* Implement an alarm logic when the time reaches the user's set time

## Lessons Learned:

This project reinforced my learning of writing SystemVerilog code as well as use concepts learned in my computing system course into a practical project. I was able to practice designing an fsm and implementing it, using two stage synchronizers, flip flops, counters and so much more! This project also gave me the chance to practice my hardware validation skills by writing simple testbenches which I hope to write more in the future!
