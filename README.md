# DE1-SoC Digital Clock
This projects focuses on building a 24-hour format digital clock using the DE1-SoC board while writing HDL.

**Link to project:** http://recruiters-love-seeing-live-demos.com/


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

To handle these issues 

Here's where you can go to town on how you actually built this thing. Write as much as you can here, it's totally fine if it's not too much just make sure you write *something*. If you don't have too much experience on your resume working on the front end that's totally fine. This is where you can really show off your passion and make up for that ten fold.

## Optimizations
*(optional)*

You don't have to include this section but interviewers *love* that you can not only deliver a final product that looks great but also functions efficiently. Did you write something then refactor it later and the result was 5x faster than the original implementation? Did you cache your assets? Things that you write in this section are **GREAT** to bring up in interviews and you can use this section as reference when studying for technical interviews!

## Lessons Learned:

No matter what your experience level, being an engineer means continuously learning. Every time you build something you always have those *whoa this is awesome* or *wow I actually did it!* moments. This is where you should share those moments! Recruiters and interviewers love to see that you're self-aware and passionate about growing.

## Examples:
Take a look at these couple examples that I have in my own portfolio:

**Palettable:** https://github.com/alecortega/palettable

**Twitter Battle:** https://github.com/alecortega/twitter-battle

**Patch Panel:** https://github.com/alecortega/patch-panel
